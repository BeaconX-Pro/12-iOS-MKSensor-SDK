//
//  MKBXSSensorConfigController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSSensorConfigController.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKBXSSensorConfigModel.h"

#import "MKBXSAccelerationController.h"
#import "MKBXSHallSensorConfigController.h"
#import "MKBXSTHSensorController.h"
#import "MKBXSTempSensorController.h"

@interface MKBXSSensorConfigController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXSSensorConfigModel *dataModel;

@end

@implementation MKBXSSensorConfigController

- (void)dealloc {
    NSLog(@"MKBXSSensorConfigController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDatasFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *cellModel = self.dataList[indexPath.row];
    if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
        [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - event method
- (void)pushHallSensor {
    MKBXSHallSensorConfigController *vc = [[MKBXSHallSensorConfigController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushAxisSensor {
    MKBXSAccelerationController *vc = [[MKBXSAccelerationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTHSensor {
    MKBXSTHSensorController *vc = [[MKBXSTHSensorController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTemperatureSensor {
    MKBXSTempSensorController *vc = [[MKBXSTempSensorController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    if (self.dataModel.asix > 0) {
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.leftMsg = @"3-axis accelerometer";
        cellModel1.showRightIcon = YES;
        cellModel1.methodName = @"pushAxisSensor";
        [self.dataList addObject:cellModel1];
    }
    
    if (!self.dataModel.hallStatus && !self.dataModel.resetByButton) {
        MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
        cellModel2.leftMsg = @"Hall sensor";
        cellModel2.showRightIcon = YES;
        cellModel2.methodName = @"pushHallSensor";
        [self.dataList addObject:cellModel2];
    }
    
    
    if (self.dataModel.th == 1 || self.dataModel.th == 2) {
        //温湿度
        MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
        cellModel3.leftMsg = @"Temperature & Humidity";
        cellModel3.showRightIcon = YES;
        cellModel3.methodName = @"pushTHSensor";
        [self.dataList addObject:cellModel3];
    }
    
    if (self.dataModel.th == 3) {
        //温度
        MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
        cellModel3.leftMsg = @"Temperature";
        cellModel3.showRightIcon = YES;
        cellModel3.methodName = @"pushTemperatureSensor";
        [self.dataList addObject:cellModel3];
    }
    
    
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.defaultTitle = @"Sensor configurations";
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
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXSSensorConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSSensorConfigModel alloc] init];
    }
    return _dataModel;
}

@end
