//
//  MKBXSRemoteReminderModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSRemoteReminderModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface+MKBXSConfig.h"

@interface MKBXSRemoteReminderModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSRemoteReminderModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readRingingFre]) {
            [self operationFailedBlockWithMsg:@"Read Data Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configBuzzerDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if (![self configRemoteReminderBuzzer]) {
            [self operationFailedBlockWithMsg:@"Config Remote Reminder Buzzer Error" block:failedBlock];
            return;
        }
        
        if (![self configRingingFre]) {
            [self operationFailedBlockWithMsg:@"Config Data Error" block:failedBlock];
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
- (BOOL)readRingingFre {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readRemoteReminderBuzzerFrequencyWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.ringingFre = [returnData[@"result"][@"frequency"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];

    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRingingFre {
    __block BOOL success = NO;
    [MKBXSInterface bxs_configRemoteReminderBuzzerFrequency:self.ringingFre sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];

    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRemoteReminderBuzzer {
    __block BOOL success = NO;
    
    [MKBXSInterface bxs_configRemoteReminderBuzzerNotiParams:[self.buzzerRingingTime integerValue]
                                            blinkingInterval:[self.buzzerRingingInterval integerValue]
                                                    sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                                                 failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];

    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"remoteReminder"
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
        _readQueue = dispatch_queue_create("remoteReminderQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
