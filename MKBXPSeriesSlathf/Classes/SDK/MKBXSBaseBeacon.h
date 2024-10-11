//
//  MKBXSBaseBeacon.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Advertising data frame type
 
 - MKBXSUIDFrameType: UID
 - MKBXSURLFrameType: URL
 - MKBXSTLMFrameType: TLM
 - MKBXSSensorInfoFrameType: Sensor information
 - MKBXSBeaconFrameType: iBeacon
 - MKBXSProductionTestFrameType Production Test iBeacon
 - MKBXSUnkonwFrameType: Unknown
 */
typedef NS_ENUM(NSInteger, MKBXSDataFrameType) {
    MKBXSUIDFrameType,
    MKBXSURLFrameType,
    MKBXSTLMFrameType,
    MKBXSSensorInfoFrameType,
    MKBXSBeaconFrameType,
    MKBXSProductionTestFrameType,
    MKBXSUnknownFrameType,
};

@class CBPeripheral;
@interface MKBXSBaseBeacon : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKBXSDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;

@property (nonatomic, assign) BOOL connectEnable;

/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

@property (nonatomic, copy)NSString *deviceName;

+ (NSArray <MKBXSBaseBeacon *>*)parseAdvData:(NSDictionary *)advData;

+ (MKBXSDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData;

@end

@interface MKBXSUIDBeacon : MKBXSBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
@property (nonatomic, copy) NSString *namespaceId;
@property (nonatomic, copy) NSString *instanceId;

- (MKBXSUIDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXSURLBeacon : MKBXSBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
//URL Content
@property (nonatomic, copy) NSString *shortUrl;

- (MKBXSURLBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXSTLMBeacon : MKBXSBaseBeacon

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *mvPerbit;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *advertiseCount;
@property (nonatomic, strong) NSNumber *deciSecondsSinceBoot;

- (MKBXSTLMBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXSSensorInfoBeacon : MKBXSBaseBeacon

/// Hall sensor status. 1: The magnet is away (absent); 0: The magnet is close (present).
@property (nonatomic, assign)BOOL magnetStatus;

/// Triaxial sensor status. 1: In progress; 0: Still (No mvt)
@property (nonatomic, assign)BOOL moved;

/// Whether the device has a triaxial sensor.
@property (nonatomic, assign)BOOL triaxialSensor;

/// Whether the device has a temperature sensor.
@property (nonatomic, assign)BOOL tempSensor;

/// Whether the device has a humidity sensor.
@property (nonatomic, assign)BOOL humiditySensor;

/// Whether the device has a flash.
@property (nonatomic, assign)BOOL flash;

/// In the power-on state, the state of the Hall sensor changes every cycle, that is, when the magnet is close, if the magnet is far away, the count will be triggered once, and the count will not be counted when the magnet approaches again. Only the number of times after the Hall trigger is turned on is recorded. If the Hall trigger is set for multiple channels, it will only be counted according to the actual switching times of the Hall switch.
@property (nonatomic, copy)NSString *hallSensorCount;

/// The number of motion triggers, each time the three-axis sensor wakes up from an interrupt, the trigger counts once. Only the number of times after the motion trigger is turned on is recorded. If the motion trigger is set for multiple channels, it will only be counted according to the actual number of sensor interrupts and wake-ups.
@property (nonatomic, copy)NSString *movedCount;

/// X-axis data.(mg)
@property (nonatomic, copy)NSString *xData;

/// Y-axis data.(mg)
@property (nonatomic, copy)NSString *yData;

/// Z-axis data.(mg)
@property (nonatomic, copy)NSString *zData;

@property (nonatomic, copy)NSString *temperature;

@property (nonatomic, copy)NSString *humidity;

/// mV
@property (nonatomic, copy)NSString *battery;

@property (nonatomic, copy)NSString *tagID;

- (MKBXSSensorInfoBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXSiBeacon : MKBXSBaseBeacon

//RSSI@1m
@property (nonatomic, copy)NSNumber *rssi1M;
@property (nonatomic, copy)NSNumber *txPower;
//Advetising Interval
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

- (MKBXSiBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXSProductionTestBeacon : MKBXSBaseBeacon

/// mV
@property (nonatomic, copy)NSString *battery;
@property (nonatomic, copy)NSString *macAddress;

- (MKBXSProductionTestBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
