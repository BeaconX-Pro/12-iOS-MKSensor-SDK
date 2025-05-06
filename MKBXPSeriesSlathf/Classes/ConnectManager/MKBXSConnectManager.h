//
//  MKBXSConnectManager.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXSConnectManager : NSObject

/// 当前连接密码
@property (nonatomic, copy)NSString *password;

/// 是否需要密码连接
@property (nonatomic, assign)BOOL needPassword;

/// YES:打开了霍尔开关机   NO:关闭了霍尔开关机
@property (nonatomic, assign)BOOL hallStatus;

/// 按键关机状态
@property (nonatomic, assign)BOOL resetByButton;

/// 0:No three-axis sensor 1:Lis2DH/Lis3DH 2:STK8328
@property (nonatomic, assign)NSInteger accStatus;

/// @"0":No temperature and humidity sensor   @"1":SHT30/SHT31(温湿度)    @"2":SHT40(温湿度)   @"3":STS40(温度)  @"4":SHT43(温湿度) 
@property (nonatomic, assign)NSInteger thStatus;

+ (MKBXSConnectManager *)shared;

/// 连接设备
/// @param peripheral 设备
/// @param password 密码
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
