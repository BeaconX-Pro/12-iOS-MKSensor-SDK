//
//  MKBXSPeripheral.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSPeripheral.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "CBPeripheral+MKBXSAdd.h"
#import "MKBXSSDKNormalDefines.h"

@interface MKBXSPeripheral ()

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, assign)BOOL dfu;

@end

@implementation MKBXSPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral dfuMode:(BOOL)dfu {
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.dfu = dfu;
    }
    return self;
}

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:@"180A"],  //厂商信息
                          [CBUUID UUIDWithString:@"AA00"],
                          [CBUUID UUIDWithString:kBXTOtaServerUUIDString]]; //自定义
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:@"AA01"],[CBUUID UUIDWithString:@"AA02"],
                                         [CBUUID UUIDWithString:@"AA03"],[CBUUID UUIDWithString:@"AA04"],
                                         [CBUUID UUIDWithString:@"AA05"],[CBUUID UUIDWithString:@"AA06"],
                                         [CBUUID UUIDWithString:@"AA07"],[CBUUID UUIDWithString:@"AA08"]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaServerUUIDString]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:kBXTOtaControlUUIDString],
                                         [CBUUID UUIDWithString:kBXTOtaDataUUIDString]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral bxs_updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral bxs_updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral bxs_connectSuccess:self.dfu];
}

- (void)setNil {
    [self.peripheral bxs_setNil];
}

@end
