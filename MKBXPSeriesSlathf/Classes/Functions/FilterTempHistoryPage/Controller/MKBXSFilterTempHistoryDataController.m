//
//  MKBXSFilterTempHistoryDataController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSFilterTempHistoryDataController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertController.h"

#import "MKBLEBaseSDKAdopter.h"
#import "MKBXSCentralManager.h"
#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBXSFilterTempHistoryHeaderView.h"

#import "MKBXSExportTempDataCurveView.h"

#define textBackViewHeight (kViewHeight - kNavigationBarHeight - 70.f)

static CGFloat timeViewWidth = 130.f;
static CGFloat tempTextViewWidth = 80.f;
static CGFloat tTextViewOffset_Y = 60.f;

#define textViewSpace (kViewWidth - 30.f - timeViewWidth - 2 * tempTextViewWidth) / 4

@interface MKBXSFilterTempHistoryDataController ()<MFMailComposeViewControllerDelegate,
MKBXSFilterTempHistoryHeaderViewDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)MKBXSFilterTempHistoryHeaderView *topView;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)MKBXSExportTempDataCurveView *curveView;

@property (nonatomic, strong)NSMutableArray *temperatureList;

@property (nonatomic, strong)UIView *textBackView;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation MKBXSFilterTempHistoryDataController

- (void)dealloc {
    NSLog(@"MKBXSFilterTempHistoryDataController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self processDatas];
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

#pragma mark - MKBXSFilterTempHistoryHeaderViewDelegate

- (void)bxs_filterHTHistoryHeaderView_switchButtonPressed:(BOOL)selected {
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

- (void)bxs_filterHTHistoryHeaderView_exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"MESSAGE://"]
                                           options:@{}
                                 completionHandler:nil];
        return;
    }
    NSData *emailData = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
    if (!ValidData(emailData) || emailData.length == 0) {
        [self.view showCentralToast:@"Log file does not exist"];
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
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:@"TemperatureDatas.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - private method

- (void)drawHTCurveView {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [self.curveView updateTemperatureDatas:self.temperatureList
                            temperatureMax:[[self.temperatureList valueForKeyPath:@"@max.floatValue"] floatValue]
                            temperatureMin:[[self.temperatureList valueForKeyPath:@"@min.floatValue"] floatValue]
                             completeBlock:^{
        [[MKHudManager share] hide];
    }];
}

- (void)processDatas {
    if (!ValidArray(self.dataList)) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    NSString *text = @"";
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        NSDictionary *dic = self.dataList[i];
        NSString *temperature = dic[@"temperature"];
        [self.temperatureList addObject:temperature];
        NSString *tempTemperature = [NSString stringWithFormat:@"%@%@",temperature,@"℃"];
        NSString *tempString = [NSString stringWithFormat:@"\n%@\t\t%@",dic[@"date"],tempTemperature];
        text = [text stringByAppendingString:tempString];
    }
    [[MKHudManager share] hide];
    
    self.textView.text = [self.textView.text stringByAppendingString:text];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    [self.topView updateSumRecord:[NSString stringWithFormat:@"%ld",(long)self.dataList.count]];
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

- (MKBXSFilterTempHistoryHeaderView *)topView {
    if (!_topView) {
        _topView = [[MKBXSFilterTempHistoryHeaderView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
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

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    }
    return _dateFormatter;
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
