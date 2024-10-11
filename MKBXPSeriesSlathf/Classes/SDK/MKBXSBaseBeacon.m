//
//  MKBXSBaseBeacon.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSBaseBeacon.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXSSDKDataAdopter.h"

@implementation MKBXSBaseBeacon

+ (NSArray <MKBXSBaseBeacon *>*)parseAdvData:(NSDictionary *)advData {
    if (!MKValidDict(advData)) {
        return @[];
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    NSMutableArray *beaconList = [NSMutableArray array];
    NSArray *keys = [advDic allKeys];
    for (id key in keys) {
        if ([key isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
            NSData *feaaData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            if (MKValidData(feaaData)) {
                MKBXSDataFrameType frameType = [self fetchFEAAFrameType:feaaData];
                MKBXSBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"FEAB"]]) {
            NSData *feabData = advDic[[CBUUID UUIDWithString:@"FEAB"]];
            if (MKValidData(feabData)) {
                MKBXSDataFrameType frameType = [self fetchFEABFrameType:feabData];
                MKBXSBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feabData];
                if ([beacon isKindOfClass:[MKBXSiBeacon class]]) {
                    MKBXSiBeacon *tempBeacon = (MKBXSiBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"EA01"]]) {
            NSData *feaData = advDic[[CBUUID UUIDWithString:@"EA01"]];
            if (MKValidData(feaData)) {
                MKBXSDataFrameType frameType = [self fetchEA01FrameType:feaData];
                MKBXSBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"EB01"]]) {
            NSData *febData = advDic[[CBUUID UUIDWithString:@"EB01"]];
            if (MKValidData(febData)) {
                MKBXSDataFrameType frameType = [self fetchEB01FrameType:febData];
                MKBXSBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:febData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }
    }
    return beaconList;
}

+ (MKBXSBaseBeacon *)fetchBaseBeaconWithFrameType:(MKBXSDataFrameType)frameType advData:(NSData *)advData {
    MKBXSBaseBeacon *beacon = nil;
    switch (frameType) {
        case MKBXSUIDFrameType:
            beacon = [[MKBXSUIDBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXSURLFrameType:
            beacon = [[MKBXSURLBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXSTLMFrameType:
            beacon = [[MKBXSTLMBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXSSensorInfoFrameType:
            beacon = [[MKBXSSensorInfoBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXSBeaconFrameType:
            beacon = [[MKBXSiBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXSProductionTestFrameType:
            beacon = [[MKBXSProductionTestBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        default:
            return nil;
    }
    beacon.frameType = frameType;
    return beacon;
}

+ (MKBXSDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData {
    if (slotData.length == 0) {
        return MKBXSUnknownFrameType;
    }
    const unsigned char *cData = [slotData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXSUIDFrameType;
        case 0x10:
            return MKBXSURLFrameType;
        case 0x20:
            return MKBXSTLMFrameType;
        case 0x80:
            return MKBXSSensorInfoFrameType;
        case 0x50:
            return MKBXSBeaconFrameType;
        default:
            return MKBXSUnknownFrameType;
    }
}

+ (MKBXSDataFrameType)fetchFEAAFrameType:(NSData *)stoneData {
    if (!MKValidData(stoneData)) {
        return MKBXSUnknownFrameType;
    }
    //Eddystone信息帧
    if (stoneData.length == 0) {
        return MKBXSUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXSUIDFrameType;
        case 0x10:
            return MKBXSURLFrameType;
        case 0x20:
            return MKBXSTLMFrameType;
        default:
            return MKBXSUnknownFrameType;
    }
}

+ (MKBXSDataFrameType)fetchFEABFrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXSUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x50:
            return MKBXSBeaconFrameType;
        default:
            return MKBXSUnknownFrameType;
    }
}

+ (MKBXSDataFrameType)fetchEA01FrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXSUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x80:
            return MKBXSSensorInfoFrameType;
        default:
            return MKBXSUnknownFrameType;
    }
}

+ (MKBXSDataFrameType)fetchEB01FrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXSUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x90:
            return MKBXSProductionTestFrameType;
        default:
            return MKBXSUnknownFrameType;
    }
}

@end

@implementation MKBXSUIDBeacon

- (MKBXSUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length < 18) {
            return nil;
        }
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXSURLBeacon

- (MKBXSURLBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 3), @"Invalid advertiseData:%@", advData);
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *urlScheme = [MKBXSSDKDataAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advData.length - 3; i++) {
            url = [url stringByAppendingString:[MKBXSSDKDataAdopter getEncodedString:*(data + i + 3)]];
        }
        self.shortUrl = url;
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXSTLMBeacon

- (MKBXSTLMBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 14), @"Invalid advertiseData:%@", advData);
        
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        /* [TDOO] Set TML Beacon Properties */
        self.version = [NSNumber numberWithInt:*(data+1)];
        self.mvPerbit = [NSNumber numberWithInt:((*(data+2) << 8) + *(data+3))];
        unsigned char temperatureInt = *(data+4);
        if (temperatureInt & 0x80) {
            self.temperature = [NSNumber numberWithFloat:(float)(- 0x100 + temperatureInt) + *(data+5) / 256.0];
        }
        else {
            self.temperature = [NSNumber numberWithFloat:(float)temperatureInt + *(data+5) / 256.0];
        }
        float advertiseCount = (*(data+6) * 16777216) + (*(data+7) * 65536) + (*(data+8) * 256) + *(data+9);
        self.advertiseCount = [NSNumber numberWithLong:advertiseCount];
        float deciSecondsSinceBoot = (((int)(*(data+10) * 16777216) + (int)(*(data+11) * 65536) + (int)(*(data+12) * 256) + *(data+13)) / 10.0);
        self.deciSecondsSinceBoot = [NSNumber numberWithFloat:deciSecondsSinceBoot];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXSSensorInfoBeacon

- (MKBXSSensorInfoBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 16), @"Invalid advertiseData:%@", advData);
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        content = [content substringFromIndex:2];
        NSString *state = [content substringWithRange:NSMakeRange(0, 2)];
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:state];
        self.magnetStatus = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        self.moved = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        self.triaxialSensor = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        self.tempSensor = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        self.humiditySensor = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        self.flash = [[binary substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
        
        self.hallSensorCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        self.movedCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSNumber *xData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(10, 4)]];
        self.xData = [NSString stringWithFormat:@"%@",xData];
        NSNumber *yData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(14, 4)]];
        self.yData = [NSString stringWithFormat:@"%@",yData];
        NSNumber *zData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(18, 4)]];
        self.zData = [NSString stringWithFormat:@"%@",zData];
        
        NSNumber *tempNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(22, 4)]];
        self.temperature = [NSString stringWithFormat:@"%.f",([tempNumber integerValue] * 0.1)];
        
        NSNumber *humidityNumber = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(26, 4)]];
        self.humidity = [NSString stringWithFormat:@"%.f",([humidityNumber integerValue] * 0.1)];
        
        self.battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(30, 4)];
        self.tagID = [content substringFromIndex:34];
    }
    return self;
}

@end

@implementation MKBXSiBeacon

- (MKBXSiBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 7), @"Invalid advertiseData:%@", advData);

        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi1M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi1M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(2, 8)],
                                 [temp substringWithRange:NSMakeRange(10, 4)],
                                 [temp substringWithRange:NSMakeRange(14, 4)],
                                 [temp substringWithRange:NSMakeRange(18,4)],
                                 [temp substringWithRange:NSMakeRange(22, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        self.uuid = [uuid uppercaseString];
        self.major = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(34, 4)] UTF8String],0,16)];
        self.minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(38, 4)] UTF8String],0,16)];
        free(data);
    }
    return self;
}

@end


@implementation MKBXSProductionTestBeacon

- (MKBXSProductionTestBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 8), @"Invalid advertiseData:%@", advData);

        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        self.battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *tempMac = [[content substringWithRange:NSMakeRange(6, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
        [tempMac substringWithRange:NSMakeRange(0, 2)],
        [tempMac substringWithRange:NSMakeRange(2, 2)],
        [tempMac substringWithRange:NSMakeRange(4, 2)],
        [tempMac substringWithRange:NSMakeRange(6, 2)],
        [tempMac substringWithRange:NSMakeRange(8, 2)],
        [tempMac substringWithRange:NSMakeRange(10, 2)]];
        self.macAddress = macAddress;
    }
    return self;
}

@end
