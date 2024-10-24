//
//  MKBXSDFUModule.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/29.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSDFUModule.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKBXSCentralManager.h"

static NSInteger const kBXTOTAByteAlignment = 4;
static unsigned char kBXTOTAByteAlignmentPadding[] = {0xFF, 0xFF, 0xFF, 0xFF};
static char const kBXTInitiateDFUData = 0x00;
static char const kBXTTerminateFimwareUpdateData = 0x03;
static NSInteger const kBXTOTAMaxMtuLen = 100;

typedef NS_ENUM(NSInteger, bxs_ota_process) {
    bxs_ota_process_start,
    bxs_ota_process_reconnect,
    bxs_ota_process_updating,
    bxs_ota_process_complete,
};

@interface MKBXSDFUModule()

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy) void (^sucBlock)(void);
@property (nonatomic, copy) void (^failedBlock)(NSError *error);
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) bxs_ota_process otaProcess;

@end

@implementation MKBXSDFUModule

- (void)dealloc{
    NSLog(@"MKBXSDFUModule销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - note
- (void)deviceConnectTypeChanged {
    if ([MKBXSCentralManager shared].connectStatus != mk_bxs_centralConnectStatusConnected && self.otaProcess != bxs_ota_process_complete) {
        [self operationFailedBlockWithMsg:@"Dfu Failed!" block:self.failedBlock];
        return;
    }
}

#pragma mark - public method

- (void)updateWithFileUrl:(NSString *)url
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!ValidStr(url)) {
        [self operationFailedBlockWithMsg:@"The url is invalid!" block:failedBlock];
        return;
    }
    NSData *zipData = [NSData dataWithContentsOfFile:url];
    if (!ValidData(zipData) || zipData.length == 0) {
        [self operationFailedBlockWithMsg:@"Dfu upgrade failure!" block:failedBlock];
        return;
    }
    if ([MKBXSCentralManager shared].connectStatus != mk_bxs_centralConnectStatusConnected) {
        [self operationFailedBlockWithMsg:@"Device is disconnected!" block:failedBlock];
        return;
    }
    if (![[MKBXSCentralManager shared] otaContralCharacteristic]) {
        //Do not support ota.
        [self operationFailedBlockWithMsg:@"The current device does not support OTA" block:failedBlock];
        return;
    }
    self.fileData = nil;
    self.fileData = zipData;
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    self.peripheral = [MKBXSCentralManager shared].peripheral;
    self.location = 0;
    self.length = kBXTOTAMaxMtuLen;
    [[MKBXSCentralManager shared] addCharacteristicWriteBlock:nil];
    self.otaProcess = bxs_ota_process_reconnect;
    [self writeSingleByteValue:kBXTInitiateDFUData
              toCharacteristic:[[MKBXSCentralManager shared] otaContralCharacteristic]];
    
    [[MKBXSCentralManager shared] addCharacteristicWriteBlock:^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nullable error) {
        if (error) {
            if (self.failedBlock) {
                moko_dispatch_main_safe(^{
                    self.failedBlock(error);
                });
            }
            return;
        }
        [self peripheral:peripheral didWriteValueForCharacteristic:characteristic];
    }];
}

#pragma mark - dfu method
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic {
    if ([characteristic isEqual:[[MKBXSCentralManager shared] otaContralCharacteristic]]) {
        if (self.otaProcess == bxs_ota_process_reconnect) {
            if ([[MKBXSCentralManager shared] otaDataCharacteristic]) {
                //当前设备不需要重连
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(deviceConnectTypeChanged)
                                                             name:mk_bxs_peripheralConnectStateChangedNotification
                                                           object:nil];
                [self writeFileDataToCharacteristic:[[MKBXSCentralManager shared] otaDataCharacteristic]];
                return;
            }
            [self reconnectDevice];
            return;
        }
        //设备刚进入dfu模式，重连接之后的操作。刚发送完00，设备启动dfu
        if (self.otaProcess == bxs_ota_process_updating) {
            [self writeFileDataToCharacteristic:[[MKBXSCentralManager shared] otaDataCharacteristic]];
            return;
        }
        if (self.otaProcess == bxs_ota_process_complete) {
            if (self.sucBlock) {
                moko_dispatch_main_safe(^{
                    self.sucBlock();
                });
            }
            return;
        }
        return;
    }
    if ([characteristic isEqual:[[MKBXSCentralManager shared] otaDataCharacteristic]]) {
        if (self.location < self.fileData.length) {
            NSLog(@"发送中");
            [self writeFileDataToCharacteristic:characteristic];
            return;
        }
        //需要发送结束标志
        NSLog(@"发送最后一帧升级数据");
        self.otaProcess = bxs_ota_process_complete;
        [self writeSingleByteValue:kBXTTerminateFimwareUpdateData
                  toCharacteristic:[[MKBXSCentralManager shared] otaContralCharacteristic]];
        return;
    }
}

- (void)startDFUProcess {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectTypeChanged)
                                                 name:mk_bxs_peripheralConnectStateChangedNotification
                                               object:nil];
    [self writeSingleByteValue:kBXTInitiateDFUData
              toCharacteristic:[[MKBXSCentralManager shared] otaContralCharacteristic]];
}

- (void)reconnectDevice {
    //重连设备
//    [[MKBXSCentralManager shared] disconnect];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MKBXSCentralManager shared] dfuconnectPeripheral:self.peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
            self.otaProcess = bxs_ota_process_updating;
            [self startDFUProcess];
        } failedBlock:^(NSError * _Nonnull error) {
            if (self.failedBlock) {
                self.failedBlock(error);
            }
        }];
    });
}

#pragma mark - Private method

- (void)writeFileDataToCharacteristic:(CBCharacteristic *)characteristic {
    NSData *data;
    if (self.location + self.length > self.fileData.length) {
        NSInteger currentLength = self.fileData.length - self.location;
        NSMutableData *mutableData = [[NSMutableData alloc] initWithData:[self.fileData subdataWithRange:NSMakeRange(self.location, currentLength)]];
        NSInteger lengthPastByteAlignmentBoundary = currentLength % kBXTOTAByteAlignment;
        if (lengthPastByteAlignmentBoundary > 0) {
            NSInteger requiredAdditionalLength = kBXTOTAByteAlignment - lengthPastByteAlignmentBoundary;
            [mutableData appendBytes:kBXTOTAByteAlignmentPadding length:requiredAdditionalLength];
        }
        data = [[NSData alloc] initWithData:mutableData];
        self.location = self.location + currentLength;
    } else {
        data = [self.fileData subdataWithRange:NSMakeRange(self.location, self.length)];
        self.location = self.location + self.length;
    }
    
    [self.peripheral writeValue:data
              forCharacteristic:characteristic
                           type:CBCharacteristicWriteWithResponse];
}

- (void)writeSingleByteValue:(char)value toCharacteristic:(CBCharacteristic *)characteristic {
    NSData *data = [NSData dataWithBytes:&value length:1];
    [[MKBXSCentralManager shared].peripheral writeValue:data
                                      forCharacteristic:characteristic
                                                   type:CBCharacteristicWriteWithResponse];
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.ota"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

@end
