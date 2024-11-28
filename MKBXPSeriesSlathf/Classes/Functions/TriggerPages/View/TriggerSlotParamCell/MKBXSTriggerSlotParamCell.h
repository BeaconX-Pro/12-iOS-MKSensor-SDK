//
//  MKBXSTriggerSlotParamCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTriggerSlotParamCellModel : NSObject

@property (nonatomic, assign)bxs_slotType cellType;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, assign)BOOL needChangeAdvDurationRange;

@property (nonatomic, assign)NSInteger advDurationMaxValue;

@property (nonatomic, copy)NSString *advDuration;

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

@protocol MKBXSTriggerSlotParamCellDelegate <NSObject>

- (void)bxs_triggerSlotParam_advIntervalChanged:(NSString *)interval;

- (void)bxs_triggerSlotParam_advDurationChanged:(NSString *)duration;

- (void)bxs_triggerSlotParam_rssiChanged:(NSInteger)rssi;

- (void)bxs_triggerSlotParam_txPowerChanged:(NSInteger)txPower;

@end

@interface MKBXSTriggerSlotParamCell : MKBaseCell

@property (nonatomic, strong)MKBXSTriggerSlotParamCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSTriggerSlotParamCellDelegate>delegate;

+ (MKBXSTriggerSlotParamCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
