//
//  MKBXSTriggerStepTwoController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerStepTwoController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKTextButtonCell.h"
#import "MKCustomUIAdopter.h"

#import "MKBXSTriggerParamManager.h"

#import "MKBXSSlotBeaconCell.h"
#import "MKBXSSlotSensorInfoCell.h"
#import "MKBXSSlotUIDCell.h"
#import "MKBXSSlotURLCell.h"

#import "MKBXSTriggerSlotParamCell.h"

#import "MKBXSTriggerStepThreeController.h"

static CGFloat const mk_triggerOpenHeight = 280.f;
static CGFloat const mk_triggerCloseHeight = 50.f;

@interface MKBXSTriggerStepTwoController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKBXSSlotBeaconCellDelegate,
MKBXSSlotSensorInfoCellDelegate,
MKBXSSlotUIDCellDelegate,
MKBXSSlotURLCellDelegate,
MKBXSTriggerSlotParamCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UIButton *nextButton;

@end

@implementation MKBXSTriggerStepTwoController

- (void)dealloc {
    NSLog(@"MKBXSTriggerStepTwoController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_uid) {
            return 120.f;
        }
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_url) {
            return 100.f;
        }
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_beacon) {
            return 160.f;
        }
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_sensorInfo) {
            return 120.f;
        }
        return 0.f;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_tlm) {
            return 200.f;
        }
        if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_uid || [MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_url
            || [MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_beacon || [MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_sensorInfo) {
            return 260.f;
        }
        return 0.f;
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //Frame type
        return self.section0List.count;
    }
    if (section == 1) {
        return ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_tlm || [MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_null) ? 0 : self.section1List.count;
    }
    if (section == 2) {
        return ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_null ? 0 : self.section2List.count);
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self loadSection0Cell:indexPath.row];
    }
    if (indexPath.section == 1) {
        return [self loadSection1Cell:indexPath.row];
    }
    return [self loadSection2Cell:indexPath.row];
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Frame type
        [MKBXSTriggerParamManager shared].stepTwoModel.slotType = [self fetchSlotType:dataListIndex];
        [self loadSectionDatas];
        return;
    }
}

#pragma mark - MKBXSSlotBeaconCellDelegate
- (void)bxs_advContent_majorChanged:(NSString *)major {
    [MKBXSTriggerParamManager shared].stepTwoModel.major = major;
}

- (void)bxs_advContent_minorChanged:(NSString *)minor {
    [MKBXSTriggerParamManager shared].stepTwoModel.minor = minor;
}

- (void)bxs_advContent_uuidChanged:(NSString *)uuid {
    [MKBXSTriggerParamManager shared].stepTwoModel.uuid = uuid;
}

#pragma mark - MKBXSSlotSensorInfoCellDelegate
- (void)bxs_advContent_tagInfo_deviceNameChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepTwoModel.deviceName = text;
}

- (void)bxs_advContent_tagInfo_tagIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepTwoModel.tagID = text;
}

#pragma mark - MKBXSSlotUIDCellDelegate
- (void)bxs_advContent_namespaceIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepTwoModel.namespaceID = text;
}

- (void)bxs_advContent_instanceIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepTwoModel.instanceID = text;
}

#pragma mark - MKBXSSlotURLCellDelegate
/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxs_advContent_urlTypeChanged:(NSInteger)urlType {
    [MKBXSTriggerParamManager shared].stepTwoModel.urlType = urlType;
}

- (void)bxs_advContent_urlContentChanged:(NSString *)content {
    [MKBXSTriggerParamManager shared].stepTwoModel.urlContent = content;
}

#pragma mark - MKBXSTriggerSlotParamCellDelegate
- (void)bxs_triggerSlotParam_advIntervalChanged:(NSString *)interval {
    [MKBXSTriggerParamManager shared].stepTwoModel.advInterval = interval;
}

- (void)bxs_triggerSlotParam_advDurationChanged:(NSString *)duration {
    [MKBXSTriggerParamManager shared].stepTwoModel.advDuration = duration;
}

- (void)bxs_triggerSlotParam_rssiChanged:(NSInteger)rssi {
    [MKBXSTriggerParamManager shared].stepTwoModel.rssi = rssi;
}

- (void)bxs_triggerSlotParam_txPowerChanged:(NSInteger)txPower {
    [MKBXSTriggerParamManager shared].stepTwoModel.txPower = txPower;
}

#pragma mark - event method
- (void)nextButtonPressed {
    if (![[MKBXSTriggerParamManager shared].stepTwoModel validParams]) {
        [self.view showCentralToast:@"Params Error"];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepOneModel.trigger
        && [MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2
        && [MKBXSTriggerParamManager shared].stepOneModel.motionEvent == 0) {
        //第一步移动触发，并且是Device start moving触发方式
        if ([[MKBXSTriggerParamManager shared].stepTwoModel.advDuration integerValue] > [[MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod integerValue]) {
            [self.view showCentralToast:@"Params Error"];
            return;
        }
    }
    [MKBXSTriggerParamManager shared].stepThreeModel.slotType = [MKBXSTriggerParamManager shared].stepTwoModel.slotType;
    
    MKBXSTriggerStepThreeController *vc = [[MKBXSTriggerStepThreeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface
- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    //第一个页面读取全部数据，包含了第二个和第三个页面的数据
    [[MKBXSTriggerParamManager shared] configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        [self performSelector:@selector(goback) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)goback {
    [self popToViewControllerWithClassName:@"MKBXSSlotController"];
}

- (bxs_slotType)fetchSlotType:(NSInteger)index {
    if (index == 0) {
        //TLM
        return bxs_slotType_tlm;
    }
    if (index == 1) {
        //UID
        return bxs_slotType_uid;
    }
    if (index == 2) {
        //URL
        return bxs_slotType_url;
    }
    if (index == 3) {
        //iBeacon
        return bxs_slotType_beacon;
    }
    return bxs_slotType_sensorInfo;
}

- (UITableViewCell *)loadSection0Cell:(NSInteger)row {
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section0List[row];
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *)loadSection1Cell:(NSInteger)row {
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCell *cell = [MKBXSSlotUIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCell *cell = [MKBXSSlotURLCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCell *cell = [MKBXSSlotBeaconCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCell *cell = [MKBXSSlotSensorInfoCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSTriggerStepTwoControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection2Cell:(NSInteger)row {
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType != bxs_slotType_null) {
        MKBXSTriggerSlotParamCell *cell = [MKBXSTriggerSlotParamCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSTriggerStepTwoControllerCell"];
    return cell;
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.headerList removeAllObjects];
    
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Frame type";
    cellModel.dataList = @[@"TLM",@"UID",@"URL",@"iBeacon",@"Sensor info"];
    cellModel.dataListIndex = [MKBXSTriggerParamManager shared].stepTwoModel.slotType;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCellModel *cellModel = [[MKBXSSlotUIDCellModel alloc] init];
        cellModel.namespaceID = [MKBXSTriggerParamManager shared].stepTwoModel.namespaceID;
        cellModel.instanceID = [MKBXSTriggerParamManager shared].stepTwoModel.instanceID;
        [self.section1List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCellModel *cellModel = [[MKBXSSlotURLCellModel alloc] init];
        cellModel.urlType = [MKBXSTriggerParamManager shared].stepTwoModel.urlType;
        cellModel.urlContent = [MKBXSTriggerParamManager shared].stepTwoModel.urlContent;
        [self.section1List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCellModel *cellModel = [[MKBXSSlotBeaconCellModel alloc] init];
        cellModel.major = [MKBXSTriggerParamManager shared].stepTwoModel.major;
        cellModel.minor = [MKBXSTriggerParamManager shared].stepTwoModel.minor;
        cellModel.uuid = [MKBXSTriggerParamManager shared].stepTwoModel.uuid;
        [self.section1List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCellModel *cell = [[MKBXSSlotSensorInfoCellModel alloc] init];
        cell.deviceName = [MKBXSTriggerParamManager shared].stepTwoModel.deviceName;
        cell.tagID = [MKBXSTriggerParamManager shared].stepTwoModel.tagID;
        [self.section1List addObject:cell];
        return;
    }
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    if ([MKBXSTriggerParamManager shared].stepTwoModel.slotType == bxs_slotType_null) {
        return;
    }
    MKBXSTriggerSlotParamCellModel *cellModel = [[MKBXSTriggerSlotParamCellModel alloc] init];
    cellModel.cellType = [MKBXSTriggerParamManager shared].stepTwoModel.slotType;
    cellModel.interval = [MKBXSTriggerParamManager shared].stepTwoModel.advInterval;
    cellModel.advDuration = [MKBXSTriggerParamManager shared].stepTwoModel.advDuration;
    if ([MKBXSTriggerParamManager shared].stepOneModel.trigger
        && [MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2
        && [MKBXSTriggerParamManager shared].stepOneModel.motionEvent == 0) {
        //第一步移动触发，并且是Device start moving触发方式
        cellModel.needChangeAdvDurationRange = YES;
        cellModel.advDurationMaxValue = [[MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod integerValue];
    }else {
        cellModel.needChangeAdvDurationRange = NO;
        cellModel.advDurationMaxValue = 0;
    }
    cellModel.rssi = [MKBXSTriggerParamManager shared].stepTwoModel.rssi;
    cellModel.txPower = [MKBXSTriggerParamManager shared].stepTwoModel.txPower;
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [NSString stringWithFormat:@"SLOT%@",@([MKBXSTriggerParamManager shared].slotIndex + 1)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableHeaderView];
        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [MKCustomUIAdopter customButtonWithTitle:@"Next"
                                                        target:self
                                                        action:@selector(nextButtonPressed)];
    }
    return _nextButton;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 90.f)];
    headerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, kViewWidth - 2 * 15.f, 20.f)];
    stepLabel.textAlignment = NSTextAlignmentLeft;
    stepLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"2",@"/3",@":",@"Event occurs setting"] fonts:@[MKFont(15.f),MKFont(13.f),MKFont(13.f),MKFont(18.f)] colors:@[NAVBAR_COLOR_MACROS,RGBCOLOR(137, 137, 137),NAVBAR_COLOR_MACROS,DEFAULT_TEXT_COLOR]];
    [headerView addSubview:stepLabel];
    
    UILabel *noteMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 40.f, kViewWidth - 2 * 15.f, 45.f)];
    noteMsgLabel.textAlignment = NSTextAlignmentLeft;
    noteMsgLabel.textColor = RGBCOLOR(204, 102, 72);
    noteMsgLabel.font = MKFont(13.f);
    noteMsgLabel.numberOfLines = 0;
    noteMsgLabel.text = @"*In this step, you can configure the advertising parameters of trigger event occurs.";
    [headerView addSubview:noteMsgLabel];
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    self.nextButton.frame = CGRectMake(30.f, 20.f, kViewWidth - 2 * 30.f, 40.f);
    [footerView addSubview:self.nextButton];
    
    return footerView;
}

@end
