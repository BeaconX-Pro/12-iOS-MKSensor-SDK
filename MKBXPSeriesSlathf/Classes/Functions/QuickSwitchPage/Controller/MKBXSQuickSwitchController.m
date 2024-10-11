//
//  MKBXSQuickSwitchController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSQuickSwitchController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseCollectionView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertView.h"

#import "MKBXQuickSwitchCell.h"

#import "MKBXSConnectManager.h"

#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBXSQuickSwitchModel.h"

@interface MKBXSQuickSwitchController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MKBXQuickSwitchCellDelegate>

@property (nonatomic, strong)MKBaseCollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXSQuickSwitchModel *dataModel;

@end

@implementation MKBXSQuickSwitchController

- (void)dealloc {
    NSLog(@"MKBXSQuickSwitchController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKBXQuickSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty" forIndexPath:indexPath];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kViewWidth - 3 * 11.f) / 2, 85.f);
}

#pragma mark - MKBXQuickSwitchCellDelegate
- (void)mk_bx_quickSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Connectable status
        [self configConnectEnable:isOn];
        return;
    }
    if (index == 1) {
        //Trigger LED indicator
        [self configTriggerLEDIndicator:isOn];
        return;
    }
    if (index == 2) {
        //Password verification
        [self configPasswordVerification:isOn];
        return;
    }
    if (index == 3) {
        //Tag ID Autofill
        [self configTagIDAutofill:isOn];
        return;
    }
    if (index == 4) {
        //Reset Beacon by button
        [self configResetByButton:isOn];
        return;
    }
    if (index == 5) {
        //Turn off Beacon by button
        [self configTurnOffByButton:isOn];
        return;
    }
    if (index == 6) {
        //Direction finding (CTE)
        [self configDirectionFinding:isOn];
        return;
    }
}

#pragma mark - 设置参数部分

#pragma mark - 设置可连接状态
- (void)configConnectEnable:(BOOL)connect{
    if (connect) {
        [self setConnectStatusToDevice:connect];
        return;
    }
    //设置设备为不可连接状态
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self setConnectStatusToDevice:connect];
    }];
    NSString *msg = @"Are you sure to set the Beacon non-connectable？";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxs_needDismissAlert"];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configConnectable:connect sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.connectable = connect;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = connect;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Trigger LED indicator
- (void)configTriggerLEDIndicator:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configTriggerLEDIndicatorStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.trigger = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 设置设备是否免密码登录
- (void)configPasswordVerification:(BOOL)isOn {
    if (isOn) {
        [self commandForPasswordVerification:isOn];
        return;
    }
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self commandForPasswordVerification:isOn];
    }];
    NSString *msg = @"If Password verification is disabled, it will not need password to connect the Beacon.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:@"Warning!" message:msg notificationName:@"mk_bxs_needDismissAlert"];
}

- (void)commandForPasswordVerification:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXSInterface bxs_configPasswordVerification:isOn sucBlock:^{
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        [MKBXSConnectManager shared].needPassword = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Tag ID Autofill
- (void)configTagIDAutofill:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configTagIDAutofillStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.autoFill = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Reset Beacon by button
- (void)configResetByButton:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configResetDeviceByButtonStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.resetByButton = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Turn off Beacon by button
- (void)configTurnOffByButton:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configHallSensorStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.turnOffByButton = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[5];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - Direction finding (CTE)
- (void)configDirectionFinding:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXSInterface bxs_configDirectionFindingStatus:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.direction = isOn;
        MKBXQuickSwitchCellModel *cellModel = self.dataList[6];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionData
- (void)loadSectionData {
    MKBXQuickSwitchCellModel *cellModel1 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.titleMsg = @"Connectable status";
    cellModel1.isOn = self.dataModel.connectable;
    [self.dataList addObject:cellModel1];
    
    MKBXQuickSwitchCellModel *cellModel2 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.titleMsg = @"Trigger LED indicator";
    cellModel2.isOn = self.dataModel.trigger;
    [self.dataList addObject:cellModel2];
    
    MKBXQuickSwitchCellModel *cellModel3 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.titleMsg = @"Password verification";
    cellModel3.isOn = self.dataModel.passwordVerification;
    [self.dataList addObject:cellModel3];
    
    MKBXQuickSwitchCellModel *cellModel4 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel4.index = 3;
    cellModel4.titleMsg = @"Tag ID Autofill";
    cellModel4.isOn = self.dataModel.autoFill;
    [self.dataList addObject:cellModel4];
    
    MKBXQuickSwitchCellModel *cellModel5 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel5.index = 4;
    cellModel5.titleMsg = @"Reset Beacon by button";
    cellModel5.isOn = self.dataModel.resetByButton;
    [self.dataList addObject:cellModel5];
    
    MKBXQuickSwitchCellModel *cellModel6 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel6.index = 5;
    cellModel6.titleMsg = @"Turn off Beacon by button";
    cellModel6.isOn = self.dataModel.turnOffByButton;
    [self.dataList addObject:cellModel6];
    
    MKBXQuickSwitchCellModel *cellModel7 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel7.index = 6;
    cellModel7.titleMsg = @"Direction finding (CTE)";
    cellModel7.isOn = self.dataModel.direction;
    [self.dataList addObject:cellModel7];
        
    [self.collectionView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Quick switch";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (MKBaseCollectionView *)collectionView {
    if (!_collectionView) {
        MKBXQuickSwitchCellLayout *layout = [[MKBXQuickSwitchCellLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(11.f, 11.f, 0, 11.f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[MKBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = RGBCOLOR(246.f, 247.f, 251.f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:MKBXQuickSwitchCell.class forCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXSQuickSwitchModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXSQuickSwitchModel alloc] init];
    }
    return _dataModel;
}

@end
