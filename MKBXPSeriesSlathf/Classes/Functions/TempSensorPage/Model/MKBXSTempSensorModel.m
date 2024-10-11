//
//  MKBXSTempSensorModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTempSensorModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"
#import "MKBXSInterface+MKBXSConfig.h"

@interface MKBXSTempSensorModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSTempSensorModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if (![self readSamplingInterval]) {
            [self operationFailedBlockWithMsg:@"Read Sampling Interval Error" block:failedBlock];
            return;
        }
        
        if (![self readStoreParams]) {
            [self operationFailedBlockWithMsg:@"Read T&H Data Store Error" block:failedBlock];
            return;
        }
        
        if (![self readDeviceTime]) {
            [self operationFailedBlockWithMsg:@"Read Device Time Error" block:failedBlock];
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
        
        if (![self configSamplingInterval]) {
            [self operationFailedBlockWithMsg:@"Config Sampling Interval Error" block:failedBlock];
            return;
        }
        
        if (![self configStoreParams]) {
            [self operationFailedBlockWithMsg:@"Config T&H Data Store Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readSamplingInterval {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readHTSamplingRateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.samplingInterval = returnData[@"result"][@"samplingRate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSamplingInterval {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configTHSamplingRate:[self.samplingInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readStoreParams {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readTHDataStoreParamsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.dataStore = [returnData[@"result"][@"isOn"] boolValue];
        self.interval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStoreParams {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configTHDataStoreStatus:self.dataStore interval:[self.interval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceTime {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readDeviceUTCTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[returnData[@"result"][@"timestamp"] longLongValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        self.deviceTime = [dateFormatter stringFromDate:date];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"THSensor"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
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
        _readQueue = dispatch_queue_create("THSensorQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
