//
//  MKBXSScanDeviceInfoCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@class MKBXSScanInfoCellModel;

@protocol MKBXSScanDeviceInfoCellDelegate <NSObject>

- (void)mk_bxs_connectPeripheral:(CBPeripheral *)peripheral;

@end

@interface MKBXSScanDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXSScanInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSScanDeviceInfoCellDelegate>delegate;

+ (MKBXSScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
