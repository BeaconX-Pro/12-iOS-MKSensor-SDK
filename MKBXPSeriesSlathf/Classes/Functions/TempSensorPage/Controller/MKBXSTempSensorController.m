//
//  MKBXSTempSensorController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTempSensorController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKSettingTextCell.h"
#import "MKTextFieldCell.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXSCentralManager.h"
#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBXSTempSensorModel.h"

#import "MKBXSTempSensorHeaderView.h"
#import "MKBXSSyncTimeCell.h"

#import "MKBXSExportTempDataController.h"

@interface MKBXSTempSensorController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKBXSTempSensorHeaderViewDelegate,
MKBXSSyncTimeCellDelegate>

@property (nonatomic, strong)MKBXSTempSensorHeaderViewModel *headerViewModel;

@property (nonatomic, strong)MKBXSTempSensorHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXSTempSensorModel *dataModel;

@end

@implementation MKBXSTempSensorController

- (void)dealloc {
    NSLog(@"MKBXSTempSensorController销毁");
    [[MKBXSCentralManager shared] notifyTHSensorData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 80.f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        //Export T&H data
        MKBXSExportTempDataController *vc = [[MKBXSExportTempDataController alloc] init];
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
        return self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.dataStore ? self.section1List.count : 0);
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKBXSSyncTimeCell *cell = [MKBXSSyncTimeCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //T&H Data Store
        self.dataModel.dataStore = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Storage interval
        self.dataModel.interval = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXSTempSensorHeaderViewDelegate
- (void)bxs_thSensorHeaderView_samplingIntervalChanged:(NSString *)interval {
    self.dataModel.samplingInterval = interval;
    self.headerViewModel.interval = interval;
}

#pragma mark - MKBXSSyncTimeCellDelegate
- (void)bxs_syncTimeCell_syncTimePressed {
    [self syncTime];
}

#pragma mark - Notes
- (void)receiveHTData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    self.headerViewModel.temperature = dic[@"temperature"];
    [self.headerView setDataModel:self.headerViewModel];
}

#pragma mark - Interface
- (void)syncTime {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    [MKBXSInterface bxs_configDeviceTime:[date timeIntervalSince1970] sucBlock:^{
        [[MKHudManager share] hide];
        MKBXSSyncTimeCellModel *cellModel = self.section2List[0];
        cellModel.date = timestamp;
        self.dataModel.deviceTime = timestamp;
        
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        self.headerViewModel.interval = self.dataModel.samplingInterval;
        [self loadSectionDatas];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveHTData:)
                                                     name:mk_bxs_receiveHTDataNotification
                                                   object:nil];
        [[MKBXSCentralManager shared] notifyTHSensorData:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
        
    for (NSInteger i = 0; i < 4; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
        
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.msg = @"Temperature Data Store";
    cellModel.index = 0;
    cellModel.isOn = self.dataModel.dataStore;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.msg = @"Storage interval";
    cellModel.index = 0;
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textPlaceholder = @"1~65535";
    cellModel.maxLength = 5;
    cellModel.textFieldValue = self.dataModel.interval;
    cellModel.unit = @"min";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKBXSSyncTimeCellModel *cellModel = [[MKBXSSyncTimeCellModel alloc] init];
    cellModel.date = self.dataModel.deviceTime;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"Export Temperature data";
    [self.section3List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.titleLabel.font = MKFont(15.f);
    self.defaultTitle = @"Temperature";
    [self.rightButton setImage:LOADICON(@"MKBXPSeriesSlathf", @"MKBXSTempSensorController", @"bxs_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
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

- (MKBXSTempSensorHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[MKBXSTempSensorHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}

- (MKBXSTempSensorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXSTempSensorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 170.f)];
        _headerView.delegate = self;
    }
    return _headerView;
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

- (MKBXSTempSensorModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSTempSensorModel alloc] init];
    }
    return _dataModel;
}

@end
