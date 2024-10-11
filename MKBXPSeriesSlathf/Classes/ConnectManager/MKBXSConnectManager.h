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
