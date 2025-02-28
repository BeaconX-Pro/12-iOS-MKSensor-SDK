//
//  MKBXSTriggerStepThreeController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerStepThreeController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKTextSwitchCell.h"
#import "MKNormalTextCell.h"
#import "MKCustomUIAdopter.h"

#import "MKBXSTriggerParamManager.h"

#import "MKBXSSlotBeaconCell.h"
#import "MKBXSSlotSensorInfoCell.h"
#import "MKBXSSlotUIDCell.h"
#import "MKBXSSlotURLCell.h"

#import "MKBXSSlotParamCell.h"


static CGFloat const mk_triggerOpenHeight = 280.f;
static CGFloat const mk_triggerCloseHeight = 50.f;

@interface MKBXSTriggerStepThreeController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKBXSSlotBeaconCellDelegate,
MKBXSSlotSensorInfoCellDelegate,
MKBXSSlotUIDCellDelegate,
MKBXSSlotURLCellDelegate,
MKBXSSlotParamCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UIButton *nextButton;

@end

@implementation MKBXSTriggerStepThreeController

- (void)dealloc {
    NSLog(@"MKBXSTriggerStepThreeController销毁");
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
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_uid) {
            return 120.f;
        }
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_url) {
            return 100.f;
        }
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_beacon) {
            return 160.f;
        }
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_sensorInfo) {
            return 120.f;
        }
        return 0.f;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_tlm) {
            return ([MKBXSTriggerParamManager shared].stepThreeModel.powerModeIsOn ? 240.f : 160.f);
        }
        if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_uid || [MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_url
            || [MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_beacon || [MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_sensorInfo) {
            return ([MKBXSTriggerParamManager shared].stepThreeModel.powerModeIsOn ? 300.f : 220.f);
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
        //Advertising before trigger event occurs
        return self.section0List.count;
    }
    if (![MKBXSTriggerParamManager shared].stepThreeModel.trigger) {
        return 0;
    }
    if (section == 1) {
        //Frame type
        return self.section1List.count;
    }
    if (section == 2) {
        return ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_tlm || [MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_null) ? 0 : self.section2List.count;
    }
    if (section == 3) {
        return ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_null ? 0 : self.section3List.count);
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
    if (indexPath.section == 2) {
        return [self loadSection2Cell:indexPath.row];
    }
    return [self loadSection3Cell:indexPath.row];
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Advertising before trigger event occurs
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        [MKBXSTriggerParamManager shared].stepThreeModel.trigger = isOn;
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKBXSSlotBeaconCellDelegate
- (void)bxs_advContent_majorChanged:(NSString *)major {
    [MKBXSTriggerParamManager shared].stepThreeModel.major = major;
}

- (void)bxs_advContent_minorChanged:(NSString *)minor {
    [MKBXSTriggerParamManager shared].stepThreeModel.minor = minor;
}

- (void)bxs_advContent_uuidChanged:(NSString *)uuid {
    [MKBXSTriggerParamManager shared].stepThreeModel.uuid = uuid;
}

#pragma mark - MKBXSSlotSensorInfoCellDelegate
- (void)bxs_advContent_tagInfo_deviceNameChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepThreeModel.deviceName = text;
}

- (void)bxs_advContent_tagInfo_tagIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepThreeModel.tagID = text;
}

#pragma mark - MKBXSSlotUIDCellDelegate
- (void)bxs_advContent_namespaceIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepThreeModel.namespaceID = text;
}

- (void)bxs_advContent_instanceIDChanged:(NSString *)text {
    [MKBXSTriggerParamManager shared].stepThreeModel.instanceID = text;
}

#pragma mark - MKBXSSlotURLCellDelegate
/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxs_advContent_urlTypeChanged:(NSInteger)urlType {
    [MKBXSTriggerParamManager shared].stepThreeModel.urlType = urlType;
}

- (void)bxs_advContent_urlContentChanged:(NSString *)content {
    [MKBXSTriggerParamManager shared].stepThreeModel.urlContent = content;
}

#pragma mark - MKBXSSlotParamCellDelegate
- (void)bxs_slotParam_advIntervalChanged:(NSString *)interval {
    [MKBXSTriggerParamManager shared].stepThreeModel.advInterval = interval;
}

- (void)bxs_slotParam_advDurationChanged:(NSString *)duration {
    [MKBXSTriggerParamManager shared].stepThreeModel.advDuration = duration;
}

- (void)bxs_slotParam_standbyDurationChanged:(NSString *)duration {
    [MKBXSTriggerParamManager shared].stepThreeModel.standbyDuration = duration;
}

- (void)bxs_slotParam_rssiChanged:(NSInteger)rssi {
    [MKBXSTriggerParamManager shared].stepThreeModel.rssi = rssi;
}

- (void)bxs_slotParam_txPowerChanged:(NSInteger)txPower {
    [MKBXSTriggerParamManager shared].stepThreeModel.txPower = txPower;
}

- (void)bxs_slotParam_lowerPowerDetailPressed {
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
    }];
    NSString *msg = @"If this function is enabled, the device will periodically sleeps for a period of time during broadcast.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Low-power mode" message:msg notificationName:@"mk_bxs_needDismissAlert"];
}

- (void)bxs_slotParam_lowerPowerModeChanged:(BOOL)isOn {
    [MKBXSTriggerParamManager shared].stepThreeModel.powerModeIsOn = isOn;
    [self loadSectionDatas];
}

#pragma mark - event method
- (void)doneButtonPressed {
    if ([MKBXSTriggerParamManager shared].stepOneModel.trigger
        && [MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2
        && [MKBXSTriggerParamManager shared].stepOneModel.motionEvent == 1) {
        //第一步移动触发，并且是Device remains stationary触发方式
        [MKBXSTriggerParamManager shared].stepThreeModel.advDuration = [MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.trigger && ![[MKBXSTriggerParamManager shared].stepThreeModel validParams]) {
        [self.view showCentralToast:@"Params Error"];
        return;
    }
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self saveDataToDevice];
    }];
    NSString *msg = [[MKBXSTriggerParamManager shared] fetchStepThreeAlert];
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"" message:msg notificationName:@"mk_bxs_needDismissAlert"];
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

- (UITableViewCell *)loadSection0Cell:(NSInteger)row {
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section0List[row];
    cell.delegate = self;
    return cell;
}

- (UITableViewCell *)loadSection1Cell:(NSInteger)row {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section1List[row];
    return cell;
}

- (UITableViewCell *)loadSection2Cell:(NSInteger)row {
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCell *cell = [MKBXSSlotUIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCell *cell = [MKBXSSlotURLCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCell *cell = [MKBXSSlotBeaconCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCell *cell = [MKBXSSlotSensorInfoCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section2List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSTriggerStepThreeControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection3Cell:(NSInteger)row {
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType != bxs_slotType_null) {
        MKBXSSlotParamCell *cell = [MKBXSSlotParamCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section3List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSTriggerStepThreeControllerCell"];
    return cell;
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    
    [self.headerList removeAllObjects];
    
    for (NSInteger i = 0; i < 4; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Advertising before trigger event occurs";
    cellModel.isOn = [MKBXSTriggerParamManager shared].stepThreeModel.trigger;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Frame type";
    cellModel.rightMsg = [self fetchFrameTypeMsg];
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCellModel *cellModel = [[MKBXSSlotUIDCellModel alloc] init];
        cellModel.namespaceID = [MKBXSTriggerParamManager shared].stepThreeModel.namespaceID;
        cellModel.instanceID = [MKBXSTriggerParamManager shared].stepThreeModel.instanceID;
        [self.section2List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCellModel *cellModel = [[MKBXSSlotURLCellModel alloc] init];
        cellModel.urlType = [MKBXSTriggerParamManager shared].stepThreeModel.urlType;
        cellModel.urlContent = [MKBXSTriggerParamManager shared].stepThreeModel.urlContent;
        [self.section2List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCellModel *cellModel = [[MKBXSSlotBeaconCellModel alloc] init];
        cellModel.major = [MKBXSTriggerParamManager shared].stepThreeModel.major;
        cellModel.minor = [MKBXSTriggerParamManager shared].stepThreeModel.minor;
        cellModel.uuid = [MKBXSTriggerParamManager shared].stepThreeModel.uuid;
        [self.section2List addObject:cellModel];
        return;
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCellModel *cell = [[MKBXSSlotSensorInfoCellModel alloc] init];
        cell.deviceName = [MKBXSTriggerParamManager shared].stepThreeModel.deviceName;
        cell.tagID = [MKBXSTriggerParamManager shared].stepThreeModel.tagID;
        [self.section2List addObject:cell];
        return;
    }
}

- (void)loadSection3Datas {
    [self.section3List removeAllObjects];
    
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_null) {
        return;
    }
    MKBXSSlotParamCellModel *cellModel = [[MKBXSSlotParamCellModel alloc] init];
    cellModel.cellType = [MKBXSTriggerParamManager shared].stepThreeModel.slotType;
    cellModel.interval = [MKBXSTriggerParamManager shared].stepThreeModel.advInterval;
    cellModel.advDuration = [MKBXSTriggerParamManager shared].stepThreeModel.advDuration;
    cellModel.standbyDuration = [MKBXSTriggerParamManager shared].stepThreeModel.standbyDuration;
    cellModel.rssi = [MKBXSTriggerParamManager shared].stepThreeModel.rssi;
    cellModel.txPower = [MKBXSTriggerParamManager shared].stepThreeModel.txPower;
    cellModel.powerModeIsOn = [MKBXSTriggerParamManager shared].stepThreeModel.powerModeIsOn;
    
    if ([MKBXSTriggerParamManager shared].stepOneModel.trigger
        && [MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2
        && [MKBXSTriggerParamManager shared].stepOneModel.motionEvent == 1) {
        //第一步移动触发，并且是Device remains stationary触发方式
        cellModel.powerModeButtonEnabled = NO;
    }else {
        cellModel.powerModeButtonEnabled = YES;
    }
    
    [self.section3List addObject:cellModel];
}

- (NSString *)fetchFrameTypeMsg {
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_tlm) {
        return @"TLM";
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_uid) {
        return @"UID";
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == bxs_slotType_url) {
        return @"URL";
    }
    if ([MKBXSTriggerParamManager shared].stepThreeModel.slotType == mk_bxs_slotAdvType_iBeacon) {
        return @"iBeacon";
    }
    return @"Sensor info";
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
        _nextButton = [MKCustomUIAdopter customButtonWithTitle:@"Done"
                                                        target:self
                                                        action:@selector(doneButtonPressed)];
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

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
    headerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, kViewWidth - 2 * 15.f, 20.f)];
    stepLabel.textAlignment = NSTextAlignmentLeft;
    stepLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"3",@"/3",@":",@"Before event occurs setting"] fonts:@[MKFont(15.f),MKFont(13.f),MKFont(13.f),MKFont(18.f)] colors:@[NAVBAR_COLOR_MACROS,RGBCOLOR(137, 137, 137),NAVBAR_COLOR_MACROS,DEFAULT_TEXT_COLOR]];
    [headerView addSubview:stepLabel];
    
    UILabel *noteMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 40.f, kViewWidth - 2 * 15.f, 60.f)];
    noteMsgLabel.textAlignment = NSTextAlignmentLeft;
    noteMsgLabel.textColor = RGBCOLOR(204, 102, 72);
    noteMsgLabel.font = MKFont(13.f);
    noteMsgLabel.numberOfLines = 0;
    noteMsgLabel.text = @"*In this step, you can configure whether to enable pre-trigger broadcasting and related advertising parameters.";
    [headerView addSubview:noteMsgLabel];
    
    return headerView;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    CGFloat btnWidth = (kViewWidth - 3 * 30.f) / 2;
    
    UIButton *backBtn = [MKCustomUIAdopter customButtonWithTitle:@"Back"
                                                          target:self
                                                          action:@selector(leftButtonMethod)];
    backBtn.frame = CGRectMake(30.f, 20.f, btnWidth, 40.f);
    [footerView addSubview:backBtn];
    
    
    self.nextButton.frame = CGRectMake(2 * 30.f + btnWidth, 20.f, btnWidth, 40.f);
    [footerView addSubview:self.nextButton];
    
    return footerView;
}

@end
