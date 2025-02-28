//
//  MKBXSSlotConfigDataModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSlotDataBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotConfigDataModel : MKBXSSlotDataBaseModel

/// 霍尔开关机状态
@property (nonatomic, assign)BOOL hallStatus;

@property (nonatomic, assign)BOOL resetByButton;

/// 是否支持三轴0:No three-axis sensor    1:Lis2DH/Lis3DH 2:STK8328
@property (nonatomic, assign)NSInteger asix;

/// 是否支持温湿度0:No temperature and humidity sensor   1:SHT30/SHT31   2:SHT40  3:STS40
@property (nonatomic, assign)NSInteger th;

@end

NS_ASSUME_NONNULL_END
