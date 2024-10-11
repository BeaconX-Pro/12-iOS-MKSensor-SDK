//
//  MKBXSOptionsController.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSOptionsController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKBXSOptionsCell.h"

#import "MKBXSScanController.h"

@interface MKBXSOptionsController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBXSOptionsController

- (void)dealloc {
    NSLog(@"MKBXSOptionsController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //Common Device
        MKBXSScanController *vc = [[MKBXSScanController alloc] init];
        vc.scanType = mk_bxs_scanType_common;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //Temperature&Humidity Sensor
        MKBXSScanController *vc = [[MKBXSScanController alloc] init];
        vc.scanType = mk_bxs_scanType_temperatureAndHumidity;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        //Temperature Sensor
        MKBXSScanController *vc = [[MKBXSScanController alloc] init];
        vc.scanType = mk_bxs_scanType_temperature;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXSOptionsCell *cell = [MKBXSOptionsCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKBXSOptionsCellModel *cellModel1 = [[MKBXSOptionsCellModel alloc] init];
    cellModel1.msg = @"Common Device";
    cellModel1.noteMsg = @"(BXP-S series)";
    cellModel1.iconName = @"bxs_options_commonDevice.png";
    [self.dataList addObject:cellModel1];
    
    MKBXSOptionsCellModel *cellModel2 = [[MKBXSOptionsCellModel alloc] init];
    cellModel2.msg = @"Temperature&Humidity Sensor";
    cellModel2.noteMsg = @"(M4 Sensor | M2 Sensor | L01 | L01A | L02 | L02A)";
    cellModel2.iconName = @"bxs_options_temperatureHumiditySensor.png";
    [self.dataList addObject:cellModel2];
    
    MKBXSOptionsCellModel *cellModel3 = [[MKBXSOptionsCellModel alloc] init];
    cellModel3.msg = @"Temperature Sensor";
    cellModel3.noteMsg = @"(M4 Sensor | M2 Sensor | L01 | L01A | L02 | L02A)";
    cellModel3.iconName = @"bxs_options_temperatureSensor.png";
    [self.dataList addObject:cellModel3];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DEVICE TYPE";
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

@end
