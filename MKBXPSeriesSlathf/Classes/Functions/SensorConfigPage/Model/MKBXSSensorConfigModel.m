//
//  MKBXSSensorConfigModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSSensorConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"

@interface MKBXSSensorConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSSensorConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readHallSensorState]) {
            [self operationFailedBlockWithMsg:@"Read Hall Error" block:failedBlock];
            return;
        }
        if (![self readSensorType]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Type Error" block:failedBlock];
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


#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"sensorConfigPage"
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
        _readQueue = dispatch_queue_create("sensorConfigQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
