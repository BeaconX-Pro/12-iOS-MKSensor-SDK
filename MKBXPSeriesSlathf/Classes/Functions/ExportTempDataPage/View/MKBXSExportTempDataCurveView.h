//
//  MKBXSExportTempDataCurveView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSExportTempDataCurveView : UIView

/// 绘制温度曲线图
/// @param temperatureList 温度数据列表
/// @param temperatureMax 温度列表里面的最大值
/// @param temperatureMin 温度列表里面的最小值
/// @param completeBlock 绘制曲线图完成回调
- (void)updateTemperatureDatas:(NSArray <NSString *>*)temperatureList
                temperatureMax:(CGFloat)temperatureMax
                temperatureMin:(CGFloat)temperatureMin
                 completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
