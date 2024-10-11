//
//  MKBXSTriggerStepTwoModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerStepTwoModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"
#import "MKBXSInterface+MKBXSConfig.h"

@interface MKBXSTriggerStepTwoModel ()

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSTriggerStepTwoModel

#pragma mark - public method
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
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

- (BOOL)readSlotDatas {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readTriggerSlotDataWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateSlotDatas:returnData[@"result"]];
        if (self.slotType == bxs_slotType_null) {
            //无触发默认显示Sensor Info
            self.slotType = bxs_slotType_sensorInfo;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTLM {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configSlotTriggeredTLMWithIndex:self.index advParams:[self currentTriggerContentParam] sucBlock:^{
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
    [MKBXSInterface bxs_configSlotTriggeredUIDWithIndex:self.index advParams:[self currentTriggerContentParam] namespaceID:self.namespaceID instanceID:self.instanceID sucBlock:^{
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
    [MKBXSInterface bxs_configSlotTriggeredURLWithIndex:self.index advParams:[self currentTriggerContentParam] urlType:self.urlType urlContent:self.urlContent sucBlock:^{
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
    [MKBXSInterface bxs_configSlotTriggeredBeaconWithIndex:self.index advParams:[self currentTriggerContentParam] major:[self.major integerValue] minor:[self.minor integerValue] uuid:self.uuid sucBlock:^{
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
    [MKBXSInterface bxs_configSlotTriggeredSensorInfoWithIndex:self.index advParams:[self currentTriggerContentParam] deviceName:self.deviceName tagID:self.tagID sucBlock:^{
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
    [MKBXSInterface bxs_configSlotTriggeredNoDataWithIndex:self.index advParams:[self currentTriggerContentParam] sucBlock:^{
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
