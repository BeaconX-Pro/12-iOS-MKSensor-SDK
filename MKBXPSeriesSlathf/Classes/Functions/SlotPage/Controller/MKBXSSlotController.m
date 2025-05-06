//
//  MKBXSSlotController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSlotController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKCustomUIAdopter.h"

#import "MKBXSConnectManager.h"

#import "MKBXSCentralManager.h"
#import "MKBXSInterface.h"

#import "MKBXSSlotModel.h"

#import "MKBXSSlotConfigController.h"
#import "MKBXSTriggerStepOneController.h"

@interface MKBXSSlotController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXSSlotModel *dataModel;

@property (nonatomic, strong)UIButton *startButton;

@end

@implementation MKBXSSlotController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxs_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXSInterface bxs_readSlotTriggerDataWithIndex:indexPath.row sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        BOOL trigger = ![returnData[@"result"][@"triggerType"] isEqualToString:@"00"];
        if (trigger) {
            //开启了触发
            if ([MKBXSConnectManager shared].accStatus == 0 && [MKBXSConnectManager shared].thStatus == 0 && ([MKBXSConnectManager shared].resetByButton || [MKBXSConnectManager shared].hallStatus)) {
                [self.view showCentralToast:@"Current device doesn't has sensor!"];
                return;
            }
            MKBXSTriggerStepOneController *vc = [[MKBXSTriggerStepOneController alloc] init];
            vc.slotIndex = indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        MKBXSSlotConfigController *vc = [[MKBXSSlotConfigController alloc] init];
        vc.slotIndex = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - event method
- (void)startButtonPressed {
    self.startButton.selected = !self.startButton.isSelected;
    NSString *title = (self.startButton.isSelected ? @"Stop" : @"Start");
    [self.startButton setTitle:title forState:UIControlStateNormal];
    [[MKBXSCentralManager shared] notifyRecordTHData:self.startButton.isSelected];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellModels];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellModels {
    MKNormalTextCellModel *cellModel1 = self.dataList[0];
    cellModel1.rightMsg = self.dataModel.slot1;
    
    MKNormalTextCellModel *cellModel2 = self.dataList[1];
    cellModel2.rightMsg = self.dataModel.slot2;
    
    MKNormalTextCellModel *cellModel3 = self.dataList[2];
    cellModel3.rightMsg = self.dataModel.slot3;
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"SLOT1";
    cellModel1.showRightIcon = YES;
    [self.dataList addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"SLOT2";
    cellModel2.showRightIcon = YES;
    [self.dataList addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"SLOT3";
    cellModel3.showRightIcon = YES;
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SLOT";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        _tableView.tableFooterView = [self tableFooterView];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXSSlotModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSSlotModel alloc] init];
    }
    return _dataModel;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [MKCustomUIAdopter customButtonWithTitle:@"Start"
                                                         target:self
                                                         action:@selector(startButtonPressed)];
    }
    return _startButton;
}

- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 80.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    self.startButton.frame = CGRectMake(30.f, 20.f, kViewWidth - 2 * 30.f, 40.f);
    [footerView addSubview:self.startButton];
    
    return footerView;
}

@end
