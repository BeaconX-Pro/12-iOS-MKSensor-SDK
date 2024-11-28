//
//  CBPeripheral+MKBXSAdd.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKBXSAdd.h"

#import <objc/runtime.h>

#import "MKBXSSDKNormalDefines.h"

static const char *bxs_customKey = "bxs_customKey";
static const char *bxs_disconnectTypeKey = "bxs_disconnectTypeKey";
static const char *bxs_threeSensorKey = "bxs_threeSensorKey";
static const char *bxs_passwordKey = "bxs_passwordKey";
static const char *bxs_hallSensorKey = "bxs_hallSensorKey";
static const char *bxs_temperatureHumidityKey = "bxs_temperatureHumidityKey";
static const char *bxs_recordTHKey = "bxs_recordTHKey";
static const char *bxs_recordVoltageKey = "bxs_recordVoltageKey";

static const char *bxs_otaControlKey = "bxs_otaControlKey";
static const char *bxs_otaDataKey = "bxs_otaDataKey";

static const char *bxs_passwordNotifySuccessKey = "bxs_passwordNotifySuccessKey";
static const char *bxs_disconnectTypeNotifySuccessKey = "bxs_disconnectTypeNotifySuccessKey";
static const char *bxs_customNotifySuccessKey = "bxs_customNotifySuccessKey";

@implementation CBPeripheral (MKMTAdd)

- (void)bxs_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &bxs_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &bxs_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
                objc_setAssociatedObject(self, &bxs_threeSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                [self setNotifyValue:YES forCharacteristic:characteristic];
                objc_setAssociatedObject(self, &bxs_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
                objc_setAssociatedObject(self, &bxs_hallSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
                [self setNotifyValue:YES forCharacteristic:characteristic];
                objc_setAssociatedObject(self, &bxs_temperatureHumidityKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA09"]]) {
                objc_setAssociatedObject(self, &bxs_recordTHKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
                objc_setAssociatedObject(self, &bxs_recordVoltageKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaServerUUIDString]]) {
        //OTA
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaControlUUIDString]]) {
                objc_setAssociatedObject(self, &bxs_otaControlKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaDataUUIDString]]) {
                objc_setAssociatedObject(self, &bxs_otaDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)bxs_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &bxs_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &bxs_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        objc_setAssociatedObject(self, &bxs_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bxs_connectSuccess:(BOOL)dfu {
    if (dfu) {
        if (!self.bxs_otaData || !self.bxs_otaControl) {
            return NO;
        }
        return YES;
    }
    if (![objc_getAssociatedObject(self, &bxs_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxs_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxs_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.bxs_password || !self.bxs_disconnectType || !self.bxs_custom || !self.bxs_hallSensor || !self.bxs_threeSensor || !self.bxs_temperatureHumidity || !self.bxs_recordTH || !self.bxs_recordVoltage) {
        return NO;
    }
    
    return YES;
}

- (void)bxs_setNil {
    objc_setAssociatedObject(self, &bxs_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_threeSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_hallSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_temperatureHumidityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_recordTHKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_recordVoltageKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxs_otaControlKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_otaDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxs_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxs_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)bxs_password {
    return objc_getAssociatedObject(self, &bxs_passwordKey);
}

- (CBCharacteristic *)bxs_disconnectType {
    return objc_getAssociatedObject(self, &bxs_disconnectTypeKey);
}

- (CBCharacteristic *)bxs_custom {
    return objc_getAssociatedObject(self, &bxs_customKey);
}

- (CBCharacteristic *)bxs_threeSensor {
    return objc_getAssociatedObject(self, &bxs_threeSensorKey);
}

- (CBCharacteristic *)bxs_hallSensor {
    return objc_getAssociatedObject(self, &bxs_hallSensorKey);
}

- (CBCharacteristic *)bxs_temperatureHumidity {
    return objc_getAssociatedObject(self, &bxs_temperatureHumidityKey);
}

- (CBCharacteristic *)bxs_recordTH {
    return objc_getAssociatedObject(self, &bxs_recordTHKey);
}

- (CBCharacteristic *)bxs_recordVoltage {
    return objc_getAssociatedObject(self, &bxs_recordVoltageKey);
}

- (CBCharacteristic *)bxs_otaData {
    return objc_getAssociatedObject(self, &bxs_otaDataKey);
}

- (CBCharacteristic *)bxs_otaControl {
    return objc_getAssociatedObject(self, &bxs_otaControlKey);
}

@end
