//
//  MKBXSQuickSwitchModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSQuickSwitchModel.h"

#import "MKMacroDefines.h"

#import "MKBXSConnectManager.h"

#import "MKBXSInterface.h"

@interface MKBXSQuickSwitchModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSQuickSwitchModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readConnectable]) {
            [self operationFailedBlockWithMsg:@"Read Connectable Error" block:failedBlock];
            return;
        }
        if (![self readTriggerLEDIndicator]) {
            [self operationFailedBlockWithMsg:@"Read Trigger LED indicator Error" block:failedBlock];
            return;
        }
        if (![self readPasswordVerification]) {
            [self operationFailedBlockWithMsg:@"Read Password verification Error" block:failedBlock];
            return;
        }
        if (![self readTagIDFill]) {
            [self operationFailedBlockWithMsg:@"Read Tag ID Autofill Error" block:failedBlock];
            return;
        }
        if (![self readResetByButton]) {
            [self operationFailedBlockWithMsg:@"Read Reset Beacon by button Error" block:failedBlock];
            return;
        }
        if (![self readPowerOffByButton]) {
            [self operationFailedBlockWithMsg:@"Read Turn off Beacon by button Error" block:failedBlock];
            return;
        }
        if (![self readDirectionFinding]) {
            [self operationFailedBlockWithMsg:@"Read Direction finding Error" block:failedBlock];
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
- (BOOL)readConnectable {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readConnectableWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connectable = [returnData[@"result"][@"connectable"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerLEDIndicator {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readTriggerLEDIndicatorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.trigger = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPasswordVerification {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readPasswordVerificationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.passwordVerification = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTagIDFill {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readTagIDAutofillStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.autoFill = [returnData[@"result"][@"isOn"] boolValue];
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

- (BOOL)readPowerOffByButton {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readHallSensorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.turnOffByButton = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDirectionFinding {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readDirectionFindingStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.direction = [returnData[@"result"][@"isOn"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"quickSwitchParams"
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
        _readQueue = dispatch_queue_create("quickSwitchQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
