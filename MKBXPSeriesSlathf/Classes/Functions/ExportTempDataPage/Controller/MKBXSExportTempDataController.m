//
//  MKBXSExportTempDataController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSExportTempDataController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertController.h"

#import "MKBXSExcelManager.h"

#import "MKBLEBaseSDKAdopter.h"
#import "MKBXSCentralManager.h"
#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBXSExportDataHeaderView.h"
#import "MKBXSFilterHistoryDataView.h"
#import "MKBXSHistoryDataMaskView.h"

#import "MKBXSExportTempDataCurveView.h"

#import "MKBXSFilterTempHistoryDataController.h"

#define textBackViewHeight (kViewHeight - kNavigationBarHeight - 170.f)

static CGFloat timeViewWidth = 130.f;
static CGFloat tempTextViewWidth = 80.f;
static CGFloat tTextViewOffset_Y = 160.f;

#define textViewSpace (kViewWidth - 30.f - timeViewWidth - 2 * tempTextViewWidth) / 4

@interface MKBXSExportTempDataController ()<MFMailComposeViewControllerDelegate,
MKBXSExportDataHeaderViewDelegate,
MKBXSFilterHistoryDataViewDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)MKBXSExportDataHeaderView *topView;

@property (nonatomic, strong)MKBXSFilterHistoryDataView *filterView;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)MKBXSExportTempDataCurveView *curveView;

/// 接收数据定时器，10s内没有新的数据到来就认为温湿度数据接收完毕
@property (nonatomic, strong)dispatch_source_t parseTimer;

@property (nonatomic, strong)dispatch_source_t displayTimer;

@property (nonatomic, assign)BOOL receiveComplete;

@property (nonatomic, strong)NSMutableArray *temperatureList;

@property (nonatomic, strong)UIView *textBackView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)NSMutableArray *contentList;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@property (nonatomic, strong)NSDate *runDate;

@property (nonatomic, strong)MKBXSHistoryDataMaskView *maskView;

@property (nonatomic, copy)NSString *textMsg;

@end

@implementation MKBXSExportTempDataController

- (void)dealloc {
    NSLog(@"MKBXSExportTempDataController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:mk_bxs_receiveRecordHTDataNotification
                                                  object:nil];
    [[MKBXSCentralManager shared] notifyRecordTHData:NO];
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
    if (self.displayTimer) {
        dispatch_cancel(self.displayTimer);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readDeviceRunTimes];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKBXSExportDataHeaderViewDelegate
- (void)bxs_syncButtonPressed:(BOOL)selected {
    if (selected) {
        //开始旋转
        self.textView.text = @"";
        self.textMsg = @"";
        [self.contentList removeAllObjects];
        [self.dataList removeAllObjects];
        [self.temperatureList removeAllObjects];
        
        [self readTotalNumbers];
        return;
    }
    [[MKBXSCentralManager shared] notifyRecordTHData:NO];
    self.receiveComplete = NO;
    if (self.parseTimer) {
        dispatch_cancel(self.parseTimer);
    }
}

- (void)bxs_switchButtonPressed:(BOOL)selected {
    if (selected) {
        //显示曲线图
        [UIView animateWithDuration:.3f animations:^{
            self.textBackView.frame = CGRectMake(-(kViewWidth - 10.f), tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
            self.curveView.frame = CGRectMake(10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
        } completion:^(BOOL finished) {
            [self drawHTCurveView];
        }];
        return;
    }
    //显示textView
    [UIView animateWithDuration:.3f animations:^{
        self.textBackView.frame = CGRectMake(10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
        self.curveView.frame = CGRectMake(kViewWidth - 10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bxs_deleteButtonPressed {
    NSString *msg = @"Are you sure to erase all the saved temperature datas？";
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.notificationName = @"mk_bxs_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self deleteRecordDatas];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)bxs_exportButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
    [MKBXSExcelManager exportExcelWithTHDataList:self.dataList sucBlock:^{
        [[MKHudManager share] hide];
        [self sharedExcel];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKBXSFilterHistoryDataViewDelegate
- (void)bxs_dateSelectedView_startPressed:(NSString *)startDate endDate:(NSString *)endDate {
    NSLog(@"%@   %@",startDate,endDate);
    // 创建日期范围的谓词
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    NSDate *start = [self.dateFormatter dateFromString:startDate];
    NSDate *end = [self.dateFormatter dateFromString:endDate];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *data, NSDictionary *bindings) {
        NSDate *date = [self.dateFormatter dateFromString:data[@"date"]];
        return ([date compare:start] != NSOrderedAscending) && ([date compare:end] != NSOrderedDescending);
    }];

    // 筛选满足条件的数据
    NSArray *filteredDataList = [self.dataList filteredArrayUsingPredicate:predicate];
    
    [[MKHudManager share] hide];
    
    if (!ValidArray(filteredDataList)) {
        [self.view showCentralToast:@"No matching data!"];
        return;
    }
    
    MKBXSFilterTempHistoryDataController *vc = [[MKBXSFilterTempHistoryDataController alloc] init];
    vc.dataList = [NSArray arrayWithArray:filteredDataList];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - note
- (void)receiveRecordHTData:(NSNotification *)note {
    NSString *content = note.userInfo[@"content"];
    NSInteger total = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(6, 4)];
    NSInteger index = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
    [self.contentList addObject:content];
    if (total == (index + 1)) {
        [[MKBXSCentralManager shared] notifyRecordTHData:NO];
        self.receiveComplete = YES;
        return;
    }
}

#pragma mark - interface
- (void)deleteRecordDatas {
    [self.dataList removeAllObjects];
    [self.temperatureList removeAllObjects];
    [self.contentList removeAllObjects];
    [self.textView setText:@""];
    self.textMsg = @"";
    [self.topView resetAllStatus];
    //显示textView
    [UIView animateWithDuration:.3f animations:^{
        self.textBackView.frame = CGRectMake(10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
        self.curveView.frame = CGRectMake(kViewWidth - 10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight);
    } completion:nil];
    [[MKBXSCentralManager shared] notifyRecordTHData:NO];
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXSInterface bxs_deleteBXPRecordHTDatasWithSucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Empty successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readDeviceRunTimes {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXSInterface bxs_readDeviceRuntimeWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSInteger count = [returnData[@"result"][@"time"] integerValue];
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
        self.runDate = [NSDate dateWithTimeIntervalSince1970:(current - count)];
        
        [self loadSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveRecordHTData:)
                                                     name:mk_bxs_receiveRecordHTDataNotification
                                                   object:nil];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readTotalNumbers {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    self.receiveComplete = NO;
    [MKBXSInterface bxs_readHTRecordTotalNumbersWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.maskView showWithView:self.view];
        [self.maskView updateTotalNumber:returnData[@"result"][@"count"]];
        if ([returnData[@"result"][@"count"] integerValue] == 0) {
            [self.topView resetAllStatus];
            self.textView.text = @"";
            self.textMsg = @"";
            [self.maskView updateCurrentNumber:@"0"];
            [self performSelector:@selector(dismissMaskView) withObject:nil afterDelay:2.f];
            return;
        }
        [[MKBXSCentralManager shared] notifyRecordTHData:YES];
        [self startparseTimer];
        [self startDisplayTimer];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)startparseTimer {
    self.parseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.parseTimer, dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC),  0.3 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.parseTimer, ^{
        @strongify(self);
        if (self.receiveComplete && self.contentList.count == 0) {
            //数据接收完毕并且已经解析完毕
            moko_dispatch_main_safe(^{
                dispatch_cancel(self.parseTimer);
                [self.topView resetAllStatus];
                [self performSelector:@selector(dismissMaskView) withObject:nil afterDelay:2.f];
            });
            return;
        }
        moko_dispatch_main_safe(^{
            [self processNotifyDatas];
        });
        
    });
    dispatch_resume(self.parseTimer);
}

- (void)startDisplayTimer {
    self.displayTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.displayTimer, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),  2 * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.displayTimer, ^{
        @strongify(self);
        if (self.receiveComplete && self.contentList.count == 0) {
            //数据接收完毕并且已经解析完毕
            dispatch_cancel(self.displayTimer);
            return;
        }
        moko_dispatch_main_safe(^{
            self.textView.text = self.textMsg;
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
        });
        
    });
    dispatch_resume(self.displayTimer);
}

- (void)drawHTCurveView {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [self.curveView updateTemperatureDatas:self.temperatureList
                            temperatureMax:[[self.temperatureList valueForKeyPath:@"@max.floatValue"] floatValue]
                            temperatureMin:[[self.temperatureList valueForKeyPath:@"@min.floatValue"] floatValue]
                             completeBlock:^{
        [[MKHudManager share] hide];
    }];
}

- (void)processNotifyDatas {
    if (self.contentList.count == 0) {
        return;
    }
    NSString *content = self.contentList.firstObject;
    NSString *text = [self parseTemperatureHumidityData:[content substringFromIndex:16]];
    
    [self.contentList removeObjectAtIndex:0];
    
    self.textMsg = [self.textMsg stringByAppendingString:text];
    [self.maskView updateCurrentNumber:[NSString stringWithFormat:@"%ld",(long)self.dataList.count]];
}

- (void)dismissMaskView {
    [self.maskView dismiss];
}

- (NSString *)parseTemperatureHumidityData:(NSString *)content {
    NSInteger total = content.length / 16;
    NSString *text = @"";
    for (NSInteger i = 0; i < total; i ++) {
        NSString *subContent = [content substringWithRange:NSMakeRange(i * 16, 16)];
        NSInteger time = strtoul([[subContent substringWithRange:NSMakeRange(0, 8)] UTF8String],0,16);
        NSString *timestamp = @"";
        if (time < 1577808000) {
            //需要反推
            timestamp = [self.dateFormatter stringFromDate:[self.runDate dateByAddingTimeInterval:time]];
        }else {
            timestamp = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        }
        
        NSInteger tempTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:[subContent substringWithRange:NSMakeRange(8, 4)]] integerValue];
        NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
        NSString *tempTemperature = [NSString stringWithFormat:@"%@%@",temperature,@"℃"];
        [self.temperatureList addObject:temperature];
        NSString *tempString = [NSString stringWithFormat:@"\n%@\t\t%@",timestamp,tempTemperature];
        text = [text stringByAppendingString:tempString];
        NSDictionary *htData = @{
                                 @"temperature":temperature,
                                 @"date":timestamp,
                                 };
        [self.dataList addObject:htData];
    }
    return text;
}

- (void)sharedExcel {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"]
                                          options:@{}
                                completionHandler:nil];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Temperature&HumidityDatas.xlsx"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self.view showCentralToast:@"File not exist"];
        return;
    }
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if (!ValidData(data)) {
        [self.view showCentralToast:@"Load file error"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:data
                           mimeType:@"application/xlsx"
                           fileName:@"Temperature.xlsx"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"Export Temperature Data";
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.view addSubview:self.backView];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(10.f);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10.f);
    }];
    [self.backView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(50.f);
    }];
    [self.backView addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(80.f);
    }];
    
    [self.backView addSubview:self.textBackView];
    [self.textBackView addSubview:self.textView];
    [self.backView addSubview:self.curveView];
}

#pragma mark - setter & getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (MKBXSExportDataHeaderView *)topView {
    if (!_topView) {
        _topView = [[MKBXSExportDataHeaderView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (MKBXSFilterHistoryDataView *)filterView {
    if (!_filterView) {
        _filterView = [[MKBXSFilterHistoryDataView alloc] init];
        _filterView.delegate = self;
    }
    return _filterView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10.f, 3 * 5.f + MKFont(13.f).lineHeight, kViewWidth - 30.f - 2 * 10.f, textBackViewHeight - 100.f - MKFont(13.f).lineHeight)];
        _textView.backgroundColor = COLOR_WHITE_MACROS;
        _textView.font = MKFont(13.f);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textView;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight)];
        _textBackView.layer.masksToBounds = YES;
        _textBackView.layer.borderWidth = 0.5f;
        _textBackView.layer.cornerRadius = 2.f;
        _textBackView.layer.borderColor = [UIColor colorWithRed:227.0 / 255 green:227.0 / 255 blue:227.0 / 255 alpha:1].CGColor;
        
        UILabel *timeLabel = [self loadTextLabel:@"Time"];
        UILabel *tempLabel = [self loadTextLabel:@"Temperature"];
        
        [_textBackView addSubview:timeLabel];
        [_textBackView addSubview:tempLabel];
        
        timeLabel.frame = CGRectMake(textViewSpace, 5.f, timeViewWidth, MKFont(13.f).lineHeight);
        tempLabel.frame = CGRectMake(2 * textViewSpace + timeViewWidth, 5.f, tempTextViewWidth, MKFont(13.f).lineHeight);
    }
    return _textBackView;
}

- (MKBXSExportTempDataCurveView *)curveView {
    if (!_curveView) {
        _curveView = [[MKBXSExportTempDataCurveView alloc] initWithFrame:CGRectMake(kViewWidth - 10.f, tTextViewOffset_Y, kViewWidth - 30.f, textBackViewHeight)];
    }
    return _curveView;
}

- (NSMutableArray *)temperatureList {
    if (!_temperatureList) {
        _temperatureList = [NSMutableArray array];
    }
    return _temperatureList;
}

- (NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray array];
    }
    return _contentList;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    }
    return _dateFormatter;
}

- (MKBXSHistoryDataMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[MKBXSHistoryDataMaskView alloc] init];
    }
    return _maskView;
}

- (UILabel *)loadTextLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.font = MKFont(13.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}

@end
