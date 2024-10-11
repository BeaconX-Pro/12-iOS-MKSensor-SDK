//
//  MKBXSAccelerationParamsCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSAccelerationParamsCellModel : NSObject

/// 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
@property (nonatomic, assign)NSInteger samplingRate;

/// 0:±2g,1:±4g,2:±8g,3:±16g
@property (nonatomic, assign)NSInteger scale;

@property (nonatomic, copy)NSString *threshold;

@end

@protocol MKBXSAccelerationParamsCellDelegate <NSObject>

/// 用户改变了scale.
/// @param scale 0:±2g,1:±4g,2:±8g,3:±16g
- (void)bxs_accelerationParamsScaleChanged:(NSInteger)scale;

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxs_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate;

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxs_accelerationMotionThresholdChanged:(NSString *)threshold;

@end

@interface MKBXSAccelerationParamsCell : MKBaseCell

@property (nonatomic, weak)id <MKBXSAccelerationParamsCellDelegate>delegate;

@property (nonatomic, strong)MKBXSAccelerationParamsCellModel *dataModel;

+ (MKBXSAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
