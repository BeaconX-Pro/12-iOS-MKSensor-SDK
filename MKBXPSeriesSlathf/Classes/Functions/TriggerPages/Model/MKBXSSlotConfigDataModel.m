//
//  MKBXSSlotConfigDataModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSlotConfigDataModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"
#import "MKBXSInterface+MKBXSConfig.h"

@interface MKBXSSlotConfigDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSSlotConfigDataModel

#pragma mark - public method
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readHallSensorState]) {
            [self operationFailedBlockWithMsg:@"Read Hall Error" block:failedBlock];
            return;
        }
        if (![self readResetByButton]) {
            [self operationFailedBlockWithMsg:@"Read Reset By Button Error" block:failedBlock];
            return;
        }
        if (![self readSensorType]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Type Error" block:failedBlock];
            return;
        }
        if (![self readSlotDatas]) {
            [self operationFailedBlockWithMsg:@"Read Slot Datas Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        
        if (self.slotType == bxs_slotType_tlm) {
            //TLM
            if (![self configTLM]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxs_slotType_uid) {
            if (![self configUID]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxs_slotType_url) {
            if (![self configURL]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxs_slotType_beacon) {
            if (![self configBeacon]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxs_slotType_sensorInfo) {
            if (![self configSensorInfo]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxs_slotType_null) {
            if (![self configNoData]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readHallSensorState {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readHallSensorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hallStatus = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readResetByButton {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readResetDeviceByButtonStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.resetByButton = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSensorType {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSensorTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.asix = [returnData[@"result"][@"axis"] integerValue];
        self.th = [returnData[@"result"][@"tempHumidity"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSlotDatas {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSlotDataWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateSlotDatas:returnData[@"result"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTLM {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotTLMWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUID {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotUIDWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] namespaceID:self.namespaceID instanceID:self.instanceID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configURL {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotURLWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] urlType:self.urlType urlContent:self.urlContent sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeacon {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotBeaconWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] major:[self.major integerValue] minor:[self.minor integerValue] uuid:self.uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSensorInfo {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotSensorInfoWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] deviceName:self.deviceName tagID:self.tagID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNoData {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotNoDataWithIndex:self.index type:mk_bxs_slotDataType_slotData advParams:[self currentContentParam] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("slotParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
