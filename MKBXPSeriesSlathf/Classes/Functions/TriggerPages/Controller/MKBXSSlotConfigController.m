//
//  MKBXSSlotConfigController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSlotConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKAlertView.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKNormalTextCell.h"

#import "MKBXSConnectManager.h"

#import "MKBXSSlotFrameTypePickView.h"

#import "MKBXSSlotBeaconCell.h"
#import "MKBXSSlotSensorInfoCell.h"
#import "MKBXSSlotUIDCell.h"
#import "MKBXSSlotURLCell.h"

#import "MKBXSSlotConfigDataModel.h"

#import "MKBXSSlotParamCell.h"

#import "MKBXSTriggerStepOneController.h"

@interface MKBXSSlotConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXSSlotFrameTypePickViewDelegate,
MKBXSSlotBeaconCellDelegate,
MKBXSSlotSensorInfoCellDelegate,
MKBXSSlotUIDCellDelegate,
MKBXSSlotURLCellDelegate,
MKBXSSlotParamCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKBXSSlotFrameTypePickView *headerView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXSSlotConfigDataModel *dataModel;

@end

@implementation MKBXSSlotConfigController

- (void)dealloc {
    NSLog(@"MKBXSSlotConfigController销毁");
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
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxs_slotType_uid) {
            return 120.f;
        }
        if (self.dataModel.slotType == bxs_slotType_url) {
            return 100.f;
        }
        if (self.dataModel.slotType == bxs_slotType_beacon) {
            return 160.f;
        }
        if (self.dataModel.slotType == bxs_slotType_sensorInfo) {
            return 120.f;
        }
        return 0.f;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxs_slotType_tlm) {
            return (self.dataModel.powerModeIsOn ? 240.f : 160.f);
        }
        if (self.dataModel.slotType == bxs_slotType_uid || self.dataModel.slotType == bxs_slotType_url
            || self.dataModel.slotType == bxs_slotType_beacon || self.dataModel.slotType == bxs_slotType_sensorInfo) {
            return (self.dataModel.powerModeIsOn ? 300.f : 220.f);
        }
        return 0.f;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([MKBXSConnectManager shared].thStatus == 0 && [MKBXSConnectManager shared].accStatus == 0 && ([MKBXSConnectManager shared].hallStatus || [MKBXSConnectManager shared].resetByButton)) {
            return 0.f;
        }
        return 44.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        //Trigger
        MKBXSTriggerStepOneController *vc = [[MKBXSTriggerStepOneController alloc] init];
        vc.slotIndex = self.slotIndex;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.dataModel.slotType == bxs_slotType_tlm || self.dataModel.slotType == bxs_slotType_null) ? 0 : self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.slotType == bxs_slotType_null ? 0 : self.section1List.count);
    }
    if (section == 2) {
        if ([MKBXSConnectManager shared].thStatus == 0 && [MKBXSConnectManager shared].accStatus == 0 && ([MKBXSConnectManager shared].hallStatus || [MKBXSConnectManager shared].resetByButton)) {
            return 0;
        }
        return self.section2List.count;
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

#pragma mark - MKBXSSlotFrameTypePickViewDelegate
- (void)bxs_slotFrameTypeChanged:(bxs_slotType)frameType {
    self.dataModel.slotType = frameType;
    [self loadSectionDatas];
}

#pragma mark - MKBXSSlotBeaconCellDelegate
- (void)bxs_advContent_majorChanged:(NSString *)major {
    self.dataModel.major = major;
}

- (void)bxs_advContent_minorChanged:(NSString *)minor {
    self.dataModel.minor = minor;
}

- (void)bxs_advContent_uuidChanged:(NSString *)uuid {
    self.dataModel.uuid = uuid;
}

#pragma mark - MKBXSSlotSensorInfoCellDelegate
- (void)bxs_advContent_tagInfo_deviceNameChanged:(NSString *)text {
    self.dataModel.deviceName = text;
}

- (void)bxs_advContent_tagInfo_tagIDChanged:(NSString *)text {
    self.dataModel.tagID = text;
}

#pragma mark - MKBXSSlotUIDCellDelegate
- (void)bxs_advContent_namespaceIDChanged:(NSString *)text {
    self.dataModel.namespaceID = text;
}

- (void)bxs_advContent_instanceIDChanged:(NSString *)text {
    self.dataModel.instanceID = text;
}

#pragma mark - MKBXSSlotURLCellDelegate
/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxs_advContent_urlTypeChanged:(NSInteger)urlType {
    self.dataModel.urlType = urlType;
}

- (void)bxs_advContent_urlContentChanged:(NSString *)content {
    self.dataModel.urlContent = content;
}

#pragma mark - MKBXSSlotParamCellDelegate
- (void)bxs_slotParam_advIntervalChanged:(NSString *)interval {
    self.dataModel.advInterval = interval;
}

- (void)bxs_slotParam_advDurationChanged:(NSString *)duration {
    self.dataModel.advDuration = duration;
}

- (void)bxs_slotParam_standbyDurationChanged:(NSString *)duration {
    self.dataModel.standbyDuration = duration;
}

- (void)bxs_slotParam_rssiChanged:(NSInteger)rssi {
    self.dataModel.rssi = rssi;
}

- (void)bxs_slotParam_txPowerChanged:(NSInteger)txPower {
    self.dataModel.txPower = txPower;
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
    self.dataModel.powerModeIsOn = isOn;
    [self loadSectionDatas];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.headerView updateFrameType:self.dataModel.slotType];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (UITableViewCell *)loadSection0Cell:(NSInteger)row {
    if (self.dataModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCell *cell = [MKBXSSlotUIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCell *cell = [MKBXSSlotURLCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCell *cell = [MKBXSSlotBeaconCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCell *cell = [MKBXSSlotSensorInfoCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSSlotConfigControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection1Cell:(NSInteger)row {
    if (self.dataModel.slotType != bxs_slotType_null) {
        MKBXSSlotParamCell *cell = [MKBXSSlotParamCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSSlotConfigControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection2Cell:(NSInteger)row {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section2List[row];
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
    
    if (self.dataModel.slotType == bxs_slotType_uid) {
        MKBXSSlotUIDCellModel *cellModel = [[MKBXSSlotUIDCellModel alloc] init];
        cellModel.namespaceID = self.dataModel.namespaceID;
        cellModel.instanceID = self.dataModel.instanceID;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxs_slotType_url) {
        MKBXSSlotURLCellModel *cellModel = [[MKBXSSlotURLCellModel alloc] init];
        cellModel.urlType = self.dataModel.urlType;
        cellModel.urlContent = self.dataModel.urlContent;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxs_slotType_beacon) {
        MKBXSSlotBeaconCellModel *cellModel = [[MKBXSSlotBeaconCellModel alloc] init];
        cellModel.major = self.dataModel.major;
        cellModel.minor = self.dataModel.minor;
        cellModel.uuid = self.dataModel.uuid;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxs_slotType_sensorInfo) {
        MKBXSSlotSensorInfoCellModel *cell = [[MKBXSSlotSensorInfoCellModel alloc] init];
        cell.deviceName = self.dataModel.deviceName;
        cell.tagID = self.dataModel.tagID;
        [self.section0List addObject:cell];
        return;
    }
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    if (self.dataModel.slotType == bxs_slotType_null) {
        return;
    }
    MKBXSSlotParamCellModel *cellModel = [[MKBXSSlotParamCellModel alloc] init];
    cellModel.cellType = self.dataModel.slotType;
    cellModel.interval = self.dataModel.advInterval;
    cellModel.advDuration = self.dataModel.advDuration;
    cellModel.standbyDuration = self.dataModel.standbyDuration;
    cellModel.rssi = self.dataModel.rssi;
    cellModel.txPower = self.dataModel.txPower;
    cellModel.powerModeIsOn = self.dataModel.powerModeIsOn;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    MKNormalTextCellModel *cellModel = [[MKNormalTextCellModel alloc] init];
    cellModel.leftMsg = @"Trigger";
    cellModel.leftIcon = LOADICON(@"MKBXPSeriesSlathf", @"MKBXSSlotConfigController", @"bxs_slotParamsTriggerIcon.png");
    cellModel.showRightIcon = YES;
    cellModel.rightMsg = @"OFF";
    
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [NSString stringWithFormat:@"SLOT%@",@(self.slotIndex + 1)];
    [self.rightButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSSlotConfigController", @"bxs_slotSaveIcon.png") forState:UIControlStateNormal];
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
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
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

- (MKBXSSlotFrameTypePickView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXSSlotFrameTypePickView alloc] initWithFrame:CGRectMake(0.f, 20.f, kViewWidth , 130.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKBXSSlotConfigDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSSlotConfigDataModel alloc] initWithSlotIndex:self.slotIndex];
    }
    return _dataModel;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
