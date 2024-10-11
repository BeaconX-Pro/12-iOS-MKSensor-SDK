//
//  MKBXSSettingModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2023/6/2.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSettingModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"

@interface MKBXSSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSSettingModel

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
        if (![self readBatteryADVMode]) {
            [self operationFailedBlockWithMsg:@"Read Battery ADV mode Error" block:failedBlock];
            return;
        }
        if (![self readAdvChannel]) {
            [self operationFailedBlockWithMsg:@"Read ADV Channel Error" block:failedBlock];
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
        self.supportThreeAcc = ([returnData[@"result"][@"axis"] integerValue] > 0);
        self.supportTH = ([returnData[@"result"][@"tempHumidity"] integerValue] > 0);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBatteryADVMode {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readBatteryADVModeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.batteryAdvMode = [returnData[@"result"][@"mode"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvChannel {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readADVChannelWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger channel = [returnData[@"result"][@"channel"] integerValue];
        if (channel == 7) {
            //CH37&38&39
            self.advChannel = 0;
        }else if (channel == 1) {
            //CH37
            self.advChannel = 1;
        }else if (channel == 2) {
            //CH38
            self.advChannel = 2;
        }else if (channel == 4) {
            //CH39
            self.advChannel = 3;
        }
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
        NSError *error = [[NSError alloc] initWithDomain:@"settingPage"
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
        _readQueue = dispatch_queue_create("settingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
