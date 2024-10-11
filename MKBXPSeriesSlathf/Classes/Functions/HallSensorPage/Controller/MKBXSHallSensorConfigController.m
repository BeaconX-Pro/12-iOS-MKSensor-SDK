//
//  MKBXSHallSensorConfigController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSHallSensorConfigController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBXSHallSensorConfigModel.h"

#import "MKBXSHallSensorHeaderView.h"

@interface MKBXSHallSensorConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXSHallSensorHeaderViewDelegate>

@property (nonatomic, strong)MKBXSHallSensorHeaderViewModel *headerViewModel;

@property (nonatomic, strong)MKBXSHallSensorHeaderView *headerView;

@property (nonatomic, strong)MKBXSHallSensorConfigModel *dataModel;

@end

@implementation MKBXSHallSensorConfigController

- (void)dealloc {
    NSLog(@"MKBXSHallSensorConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - MKBXSHallSensorHeaderViewDelegate
- (void)bxs_hallSensorHeaderView_clearPressed {
    [self clearTriggerCount];
}

#pragma mark - Interface
- (void)clearTriggerCount {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXSInterface bxs_clearHallTriggerCountWithSucBlock:^{
        [[MKHudManager share] hide];
        [self readDataFromDevice];
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
        self.headerViewModel.count = self.dataModel.count;
        [self.headerView setDataModel:self.headerViewModel];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Hall sensor";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.headerView];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(60.f);
    }];
}

#pragma mark - getter

- (MKBXSHallSensorHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[MKBXSHallSensorHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}

- (MKBXSHallSensorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXSHallSensorHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKBXSHallSensorConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSHallSensorConfigModel alloc] init];
    }
    return _dataModel;
}

@end
