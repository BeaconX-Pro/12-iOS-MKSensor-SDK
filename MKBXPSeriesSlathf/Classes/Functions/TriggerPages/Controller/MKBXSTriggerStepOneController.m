//
//  MKBXSTriggerStepOneController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerStepOneController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextButtonCell.h"
#import "MKTextFieldCell.h"
#import "MKNormalSliderCell.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"


#import "MKBXSTriggerParamManager.h"

#import "MKBXSSlotParamCell.h"

#import "MKBXSTriggerStepTwoController.h"

@interface MKBXSTriggerStepOneController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextButtonCellDelegate,
MKTextFieldCellDelegate,
MKNormalSliderCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

/// Trigger
@property (nonatomic, strong)NSMutableArray *section0List;

/// Trigger type
@property (nonatomic, strong)NSMutableArray *section1List;

/// Trigger event
@property (nonatomic, strong)NSMutableArray *section2List;

/// Temperature threshold
@property (nonatomic, strong)NSMutableArray *section3List;

/// Humidity threshold
@property (nonatomic, strong)NSMutableArray *section4List;

/// Static verify period.
@property (nonatomic, strong)NSMutableArray *section5List;

/// Locked ADV function.
@property (nonatomic, strong)NSMutableArray *section6List;

/// Locked ADV duration.
@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)UIButton *nextButton;

@end

@implementation MKBXSTriggerStepOneController

- (void)dealloc {
    NSLog(@"MKBXSTriggerStepOneController销毁");
    [MKBXSTriggerParamManager sharedDealloc];
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
    [MKBXSTriggerParamManager shared].slotIndex = self.slotIndex;
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        //Temperature threshold
        MKNormalSliderCellModel *cellModel = self.section3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 4) {
        //Humidity threshold
        MKNormalSliderCellModel *cellModel = self.section4List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 5) {
        //Static verify period
        MKTextFieldCellModel *cellModel = self.section5List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 7) {
        //Locked ADV duration
        MKTextSwitchCellModel *cellModel = self.section7List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 7) {
        return 0.0f;
    }
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
        //Trigger
        return self.section0List.count;
    }
    if (![MKBXSTriggerParamManager shared].stepOneModel.trigger) {
        //关闭触发
        return 0;
    }
    if (section == 1) {
        //Trigger type
        return self.section1List.count;
    }
    if (section == 2) {
        //Trigger event
        return self.section2List.count;
    }
    if (section == 3) {
        //温度触发
        //Temperature threshold
        return ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 0 ? self.section3List.count : 0);
    }
    if (section == 4) {
        //湿度触发
        //Humidity threshold
        return ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 1 ? self.section4List.count : 0);
    }
    if (section == 5) {
        //移动触发
        //Static verify period
        return ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2 ? self.section5List.count : 0);
    }
    if (section == 6) {
        //Locked ADV function
        return self.section6List.count;
    }
    if (section == 7) {
        //Locked ADV duration
//        return ([MKBXSTriggerParamManager shared].stepOneModel.lockedAdvIsOn ? self.section7List.count : 0);
        return 0;
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
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section7List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Trigger
        [MKBXSTriggerParamManager shared].stepOneModel.trigger = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        
        NSString *nextTitle = ([MKBXSTriggerParamManager shared].stepOneModel.trigger ? @"Next" : @"Done");
        [self.nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //Locked ADV function
        [MKBXSTriggerParamManager shared].stepOneModel.lockedAdvIsOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section6List[0];
        cellModel.isOn = isOn;
        
        [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
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
        //Trigger type
        [MKBXSTriggerParamManager shared].stepOneModel.triggerType = dataListIndex;
        MKTextButtonCellModel *cellModel1 = self.section1List[0];
        cellModel1.dataListIndex = dataListIndex;
        
        MKTextButtonCellModel *cellModel2 = self.section2List[0];
        cellModel2.dataList = [self loadTriggerEventList];
        cellModel2.dataListIndex = 0;
        
        [self.tableView reloadData];
        return;
    }
    if (index == 1) {
        //Trigger event
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
        if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 0) {
            //当前是温度触发
            [MKBXSTriggerParamManager shared].stepOneModel.tempEvent = dataListIndex;
            return;
        }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 1) {
            //当前是湿度触发
            [MKBXSTriggerParamManager shared].stepOneModel.humidityEvent = dataListIndex;
            return;
        }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2) {
            //当前是移动触发
            [MKBXSTriggerParamManager shared].stepOneModel.motionEvent = dataListIndex;
            return;
        }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 3) {
            //当前是霍尔触发
            [MKBXSTriggerParamManager shared].stepOneModel.hallEvent = dataListIndex;
            return;
        }
        return;
    }
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //温度触发
        [MKBXSTriggerParamManager shared].stepOneModel.temperature = value;
        MKNormalSliderCellModel *cellModel = self.section3List[0];
        cellModel.sliderValue = value;
        return;
    }
    if (index == 1) {
        //湿度触发
        [MKBXSTriggerParamManager shared].stepOneModel.humidity = value;
        MKNormalSliderCellModel *cellModel = self.section4List[0];
        cellModel.sliderValue = value;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Static verify period
        [MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod = value;
        MKTextFieldCellModel *cellModel = self.section5List[0];
        cellModel.textFieldValue = value;
        return;
    }
//    if (index == 1) {
//        //Locked ADV duration
//        [MKBXSTriggerParamManager shared].stepOneModel.lockAdvDuration = value;
//        MKTextFieldCellModel *cellModel = self.section7List[0];
//        cellModel.textFieldValue = value;
//        return;
//    }
}

#pragma mark - event method
- (void)nextButtonPressed {
    if ([self.nextButton.titleLabel.text isEqualToString:@"Done"]) {
        //关闭触发
        [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
        @weakify(self);
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
        return;
    }
//    if ([MKBXSTriggerParamManager shared].stepOneModel.lockedAdvIsOn) {
//        if (!ValidStr([MKBXSTriggerParamManager shared].stepOneModel.lockAdvDuration) || [[MKBXSTriggerParamManager shared].stepOneModel.lockAdvDuration integerValue] < 1 || [[MKBXSTriggerParamManager shared].stepOneModel.lockAdvDuration integerValue] > 65535) {
//            [self.view showCentralToast:@"Params Error"];
//            return;
//        }
//    }
    if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2) {
        //移动触发
        if ([MKBXSTriggerParamManager shared].stepOneModel.motionEvent < 0 || [MKBXSTriggerParamManager shared].stepOneModel.motionEvent > 1 || !ValidStr([MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod) || [[MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod integerValue] < 1 || [[MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod integerValue] > 65535) {
            [self.view showCentralToast:@"Params Error"];
            return;
        }
    }
    MKBXSTriggerStepTwoController *vc = [[MKBXSTriggerStepTwoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface method
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    //第一个页面读取全部数据，包含了第二个和第三个页面的数据
    [[MKBXSTriggerParamManager shared] readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
        NSString *nextTitle = ([MKBXSTriggerParamManager shared].stepOneModel.trigger ? @"Next" : @"Done");
        [self.nextButton setTitle:nextTitle forState:UIControlStateNormal];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private mehtod
- (void)goback {
    [self popToViewControllerWithClassName:@"MKBXSSlotController"];
}

- (NSArray *)loadTriggerTypeList {
    if ([MKBXSTriggerParamManager shared].stepOneModel.hallStatus) {
        //打开了霍尔开关机不显示霍尔触发
        return @[@"Temperature detect",@"Humidity detect",@"Motion detect"];
    }
    //霍尔开关机关闭则显示霍尔触发
    return @[@"Temperature detect",@"Humidity detect",@"Motion detect",@"magnetic detect"];
}

- (NSArray *)loadTriggerEventList {
    if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 0) {
        //当前是温度触发
        return @[@"Temperature above",@"Temperature below"];
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 1) {
        //当前是湿度触发
        return @[@"Humidity above",@"Humidiby below"];
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2) {
        //当前是移动触发
        return @[@"Device start moving",@"Device keep static"];
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 3) {
        //当前是霍尔触发
        return @[@"Door open",@"Door close"];
    }
    return @[];
}

- (NSInteger)loadTriggerEventIndex {
    if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 0) {
        //当前是温度触发
        return [MKBXSTriggerParamManager shared].stepOneModel.tempEvent;
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 1) {
        //当前是湿度触发
        return [MKBXSTriggerParamManager shared].stepOneModel.humidityEvent;
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 2) {
        //当前是移动触发
        return [MKBXSTriggerParamManager shared].stepOneModel.motionEvent;
    }else if ([MKBXSTriggerParamManager shared].stepOneModel.triggerType == 3) {
        //当前是霍尔触发
        return [MKBXSTriggerParamManager shared].stepOneModel.hallEvent;
    }
    return 0;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
        
    for (NSInteger i = 0; i < 8; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Trigger";
    cellModel.isOn = [MKBXSTriggerParamManager shared].stepOneModel.trigger;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Trigger type";
    cellModel.dataList = [self loadTriggerTypeList];
    cellModel.dataListIndex = [MKBXSTriggerParamManager shared].stepOneModel.triggerType;
    cellModel.buttonLabelFont = MKFont(12.f);
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Trigger event";
    cellModel.dataList = [self loadTriggerEventList];
    cellModel.dataListIndex = [self loadTriggerEventIndex];
    cellModel.buttonLabelFont = MKFont(12.f);
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Temperature threshold",@"   (-40℃~150℃)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.sliderMinValue = -40;
    cellModel.sliderMaxValue = 150;
    cellModel.unit = @"℃";
    cellModel.sliderValue = [MKBXSTriggerParamManager shared].stepOneModel.temperature;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Humidity threshold",@"   (0%~95%)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    cellModel.sliderMinValue = 0;
    cellModel.sliderMaxValue = 95;
    cellModel.unit = @"%";
    cellModel.sliderValue = [MKBXSTriggerParamManager shared].stepOneModel.humidity;
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Static verify period";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textPlaceholder = @"1~65535";
    cellModel.unit = @"s";
    cellModel.maxLength = 5;
    cellModel.textFieldValue = [MKBXSTriggerParamManager shared].stepOneModel.motionVerificationPeriod;
    cellModel.noteMsg = @"*Static verify period: the parameter that determines when a stationary event occurs on the device.";
    cellModel.noteMsgColor = RGBCOLOR(201, 90, 49);
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Locked ADV function";
    cellModel.isOn = [MKBXSTriggerParamManager shared].stepOneModel.lockedAdvIsOn;
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Locked ADV duration";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textPlaceholder = @"1~65535";
    cellModel.unit = @"s";
    cellModel.maxLength = 5;
//    cellModel.textFieldValue = [MKBXSTriggerParamManager shared].stepOneModel.lockAdvDuration;
    cellModel.noteMsg = @"*Lock ADV duration: If the device quickly returns to a state that does not meet the trigger conditions after initially satisfying them, it may only broadcast for a short period. The lock broadcast duration feature ensures that, in such cases, the device broadcasts for the set lock broadcast duration. This feature's parameter must be set to a value less than the post-trigger broadcast duration.";
    cellModel.noteMsgColor = RGBCOLOR(201, 90, 49);
    [self.section7List addObject:cellModel];
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

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 110.f)];
    headerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 10.f, kViewWidth - 2 * 15.f, 20.f)];
    stepLabel.textAlignment = NSTextAlignmentLeft;
    stepLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"1",@"/3",@":",@"Initail Setting"] fonts:@[MKFont(15.f),MKFont(13.f),MKFont(13.f),MKFont(18.f)] colors:@[NAVBAR_COLOR_MACROS,RGBCOLOR(137, 137, 137),NAVBAR_COLOR_MACROS,DEFAULT_TEXT_COLOR]];
    [headerView addSubview:stepLabel];
    
    UILabel *noteMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 40.f, kViewWidth - 2 * 15.f, 65.f)];
    noteMsgLabel.textAlignment = NSTextAlignmentLeft;
    noteMsgLabel.textColor = RGBCOLOR(204, 102, 72);
    noteMsgLabel.font = MKFont(13.f);
    noteMsgLabel.numberOfLines = 0;
    noteMsgLabel.text = @"*In this step1, you can enable or diable the trigger feature , You can also configure the trigger type and define the event criteria that meet the trigger conditions (Trigger event).";
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
