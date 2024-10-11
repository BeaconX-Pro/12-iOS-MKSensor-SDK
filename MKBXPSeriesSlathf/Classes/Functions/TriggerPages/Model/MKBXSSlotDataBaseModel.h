//
//  MKBXSSlotDataBaseModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXSSDKNormalDefines.h"

#import "MKBXSSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotParamsDataModel : NSObject<mk_bxs_slotAdvContentParam>

/// 20ms~65535ms
@property (nonatomic, assign)NSInteger advInterval;

/// 1s~65535s
@property (nonatomic, assign)NSInteger advDuration;

/// 0s~65535s
@property (nonatomic, assign)NSInteger standbyDuration;

/// -100dBm~0dBm
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

@interface MKBXSSlotTriggerParamsDataModel : NSObject<mk_bxs_slotTriggeredAdvContentParam>

/// 20ms~65535ms
@property (nonatomic, assign)NSInteger advInterval;

/// 0s~65535s
@property (nonatomic, assign)NSInteger advDuration;

/// -100dBm~0dBm
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

@interface MKBXSSlotDataBaseModel : NSObject

@property (nonatomic, assign, readonly)NSInteger index;

@property (nonatomic, assign)bxs_slotType slotType;

#pragma mark - advContent Param
@property (nonatomic, copy)NSString *advInterval;

/// YES表示standbyDuration=0
@property (nonatomic, assign)BOOL powerModeIsOn;

@property (nonatomic, copy)NSString *advDuration;

@property (nonatomic, copy)NSString *standbyDuration;

@property (nonatomic, assign)NSInteger rssi;

/*
 对于deviceType=23的C112设备，最高支持到0dBm，其余可以支持到+6dBm
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

#pragma mark - UID
@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

#pragma mark - iBeacon
@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

#pragma mark - Sensor Info
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *tagID;

#pragma mark - URL
/// 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
@property (nonatomic, assign)NSInteger urlType;

@property (nonatomic, copy)NSString *urlContent;


- (instancetype)initWithSlotIndex:(NSInteger)index;

- (BOOL)validParams;

/// 读取回来的数据更新当前属性
/// - Parameter dic: dic
- (void)updateSlotDatas:(NSDictionary *)dic;

/// 读取回来的txPower转换
/// - Parameter power: @"-20dBm" -->0
- (NSInteger)getTxPowerValue:(NSString *)power;

- (MKBXSSlotParamsDataModel *)currentContentParam;

- (MKBXSSlotTriggerParamsDataModel *)currentTriggerContentParam;

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
