//
//  MKBXSSlotParamCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotParamCellModel : NSObject

@property (nonatomic, assign)bxs_slotType cellType;

@property (nonatomic, copy)NSString *interval;

/// YES表示standbyDuration=0
@property (nonatomic, assign)BOOL powerModeIsOn;

@property (nonatomic, copy)NSString *advDuration;

@property (nonatomic, copy)NSString *standbyDuration;

@property (nonatomic, assign)NSInteger rssi;

/*
 0:-20dBm
 1:-16dBm
 2:-12dBm
 3:-8dBm
 4:-4dBm
 5:0dBm
 6:3dBm
 7:4dBm
 8:6dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@end

@protocol MKBXSSlotParamCellDelegate <NSObject>

- (void)bxs_slotParam_advIntervalChanged:(NSString *)interval;

- (void)bxs_slotParam_advDurationChanged:(NSString *)duration;

- (void)bxs_slotParam_standbyDurationChanged:(NSString *)duration;

- (void)bxs_slotParam_rssiChanged:(NSInteger)rssi;

- (void)bxs_slotParam_txPowerChanged:(NSInteger)txPower;

- (void)bxs_slotParam_lowerPowerDetailPressed;

- (void)bxs_slotParam_lowerPowerModeChanged:(BOOL)isOn;

@end

@interface MKBXSSlotParamCell : MKBaseCell

@property (nonatomic, strong)MKBXSSlotParamCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSlotParamCellDelegate>delegate;

+ (MKBXSSlotParamCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
