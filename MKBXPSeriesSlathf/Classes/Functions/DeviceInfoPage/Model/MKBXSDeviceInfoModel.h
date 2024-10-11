//
//  MKBXSDeviceInfoModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSDeviceInfoModel : NSObject

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/// 电压
@property (nonatomic, copy)NSString *voltage;

/// 电压百分比
@property (nonatomic, copy)NSString *batteryPercent;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *productMode;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

/**
 生产日期
 */
@property (nonatomic, copy)NSString *manuDate;

/// 开始读取设备信息
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
