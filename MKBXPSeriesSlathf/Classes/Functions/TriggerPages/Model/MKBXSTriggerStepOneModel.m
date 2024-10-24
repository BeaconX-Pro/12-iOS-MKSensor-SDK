//
//  MKBXSTriggerStepOneModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerStepOneModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"
#import "MKBXSInterface+MKBXSConfig.h"
#import "MKBXSSDKDataAdopter.h"

@interface MKBXSTriggerStepOneModel ()

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSTriggerStepOneModel

- (instancetype)initWithSlotIndex:(NSInteger)index {
    if (self = [self init]) {
        self.index = index;
        
    }
    return self;
}

#pragma mark - public method
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if (![self readHallSensorStatus]) {
            [self operationFailedBlockWithMsg:@"Read Hall Sensor Error" block:failedBlock];
            return;
        }
        
        if (![self readTriggerDatas]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Datas Error" block:failedBlock];
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
        if (!self.trigger) {
            if (![self closeTrigger]) {
                [self operationFailedBlockWithMsg:@"Close Trigger Error" block:failedBlock];
                return;
            }
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (self.triggerType == 0) {
            //温度触发
            if (![self configTemperatureTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Temperature Params Error" block:failedBlock];
                return;
            }
        }else if (self.triggerType == 1) {
            //湿度触发
            if (![self configHumidityTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Humidity Params Error" block:failedBlock];
                return;
            }
        }else if (self.triggerType == 2) {
            //移动触发
            if (![self configMotionDetectionTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Motion Detection Params Error" block:failedBlock];
                return;
            }
        }else if (self.triggerType == 3) {
            //霍尔触发
            if (![self configHallTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Hall Params Error" block:failedBlock];
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
- (BOOL)readHallSensorStatus {
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

- (BOOL)readTriggerDatas {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSlotTriggerDataWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateParams:returnData];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)updateParams:(NSDictionary *)returnData {
    if (!ValidDict(returnData)) {
        return;
    }
    self.trigger = ([returnData[@"result"][@"triggerType"] integerValue] > 0);
    if (!self.trigger) {
        self.triggerType = 2;
        self.motionEvent = 0;
        self.motionVerificationPeriod = @"30";
        return;
    }
    self.triggerType = ([returnData[@"result"][@"triggerType"] integerValue] - 1);
    self.lockedAdvIsOn = [returnData[@"result"][@"lockedAdvDuration"] integerValue] > 0;
    self.lockAdvDuration = returnData[@"result"][@"lockedAdvDuration"];
    if (self.triggerType == 0) {
        //温度触发
        self.temperature = [returnData[@"result"][@"temperature"] integerValue];
        self.tempEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
    if (self.triggerType == 1) {
        //湿度触发
        self.humidity = [returnData[@"result"][@"temperature"] integerValue];
        self.humidityEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
    if (self.triggerType == 2) {
        //移动触发
        self.motionEvent = [returnData[@"result"][@"event"] integerValue];
        self.motionVerificationPeriod = returnData[@"result"][@"period"];
        return;
    }
    if (self.triggerType == 3) {
        //霍尔触发
        self.hallEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
}

#pragma mark - 关闭触发
- (BOOL)closeTrigger {
    __block BOOL success = NO;
    [MKBXSInterface bxs_closeSlotTriggerWithIndex:self.index sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 温度参数
- (BOOL)configTemperatureTriggerParams {
    __block BOOL success = NO;
    NSInteger lockAdvDuration = 0;
    if (self.lockedAdvIsOn) {
        lockAdvDuration = [self.lockAdvDuration integerValue];
    }
    [MKBXSInterface bxs_configTemperatureTriggerParams:self.index triggerEvent:self.tempEvent temperature:self.temperature lockedADVDuration:lockAdvDuration sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 湿度参数
- (BOOL)configHumidityTriggerParams {
    __block BOOL success = NO;
    NSInteger lockAdvDuration = 0;
    if (self.lockedAdvIsOn) {
        lockAdvDuration = [self.lockAdvDuration integerValue];
    }
    [MKBXSInterface bxs_configHumidityTriggerParams:self.index triggerEvent:self.humidityEvent humidity:self.humidity lockedADVDuration:lockAdvDuration sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 移动参数
- (BOOL)configMotionDetectionTriggerParams {
    __block BOOL success = NO;
    NSInteger lockAdvDuration = 0;
    if (self.lockedAdvIsOn) {
        lockAdvDuration = [self.lockAdvDuration integerValue];
    }
    [MKBXSInterface bxs_configMotionDetectionTriggerParams:self.index triggerEvent:self.motionEvent period:[self.motionVerificationPeriod integerValue] lockedADVDuration:lockAdvDuration sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 霍尔参数
- (BOOL)configHallTriggerParams {
    __block BOOL success = NO;
    NSInteger lockAdvDuration = 0;
    if (self.lockedAdvIsOn) {
        lockAdvDuration = [self.lockAdvDuration integerValue];
    }
    [MKBXSInterface bxs_configHallTriggerParams:self.index triggerEvent:self.motionEvent lockedADVDuration:lockAdvDuration sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method

- (BOOL)validParams {
    if (self.lockedAdvIsOn && (!ValidStr(self.lockAdvDuration) || [self.lockAdvDuration integerValue] < 1 || [self.lockAdvDuration integerValue] > 65535)) {
        return NO;
    }
    
    if (self.triggerType == 2) {
        //移动触发
        if (self.motionEvent < 0 || self.motionEvent > 1 || !ValidStr(self.motionVerificationPeriod) || [self.motionVerificationPeriod integerValue] < 1 || [self.motionVerificationPeriod integerValue] > 65535) {
            return NO;
        }
    }
    
    return YES;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"triggrtParams"
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
        _readQueue = dispatch_queue_create("triggerParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
