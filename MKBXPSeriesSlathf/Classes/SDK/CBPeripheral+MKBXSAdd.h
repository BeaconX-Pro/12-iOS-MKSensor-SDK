//
//  CBPeripheral+MKBXSAdd.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBXSAdd)

#pragma mark - 自定义

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_threeSensor;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_password;

/// R/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_hallSensor;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_temperatureHumidity;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_recordTH;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxs_recordVoltage;

#pragma mark - OTA

@property (nonatomic, strong, readonly)CBCharacteristic *bxs_otaData;

@property (nonatomic, strong, readonly)CBCharacteristic *bxs_otaControl;

- (void)bxs_updateCharacterWithService:(CBService *)service;

- (void)bxs_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxs_connectSuccess:(BOOL)dfu;

- (void)bxs_setNil;

@end

NS_ASSUME_NONNULL_END
