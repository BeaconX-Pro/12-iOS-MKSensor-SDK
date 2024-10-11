//
//  MKBXSTriggerParamManager.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSTriggerParamManager.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"
#import "MKBXSInterface+MKBXSConfig.h"
#import "MKBXSSDKDataAdopter.h"

static MKBXSTriggerParamManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKBXSTriggerParamManager ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSTriggerParamManager

+ (MKBXSTriggerParamManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXSTriggerParamManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    manager = nil;
    onceToken = 0;
}

- (NSString *)fetchStepThreeAlert {
    if (self.stepOneModel.triggerType == 0) {
        //温度触发
        return [self fetchTemperatureTriggerMsg];
    }
    if (self.stepOneModel.triggerType == 1) {
        //湿度触发
        return [self fetchHumidityTriggerMsg];
    }
    if (self.stepOneModel.triggerType == 2) {
        //移动触发
        return [self fetchMotionTriggerMsg];
    }
    if (self.stepOneModel.triggerType == 3) {
        //霍尔触发
        return [self fetchHallTriggerMsg];
    }
    
    return @"";
}

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if (![self readStepOneModel]) {
            [self operationFailedBlockWithMsg:@"Read Step One Data Error" block:failedBlock];
            return;
        }
        
        if (![self readStepTwoModel]) {
            [self operationFailedBlockWithMsg:@"Read Step Two Data Error" block:failedBlock];
            return;
        }
        
        if (![self readStepThreeModel]) {
            [self operationFailedBlockWithMsg:@"Read Step Three Data Error" block:failedBlock];
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
        
        if (![self configStepOneModel]) {
            [self operationFailedBlockWithMsg:@"Config Step One Data Error" block:failedBlock];
            return;
        }
        
        if (!self.stepOneModel.trigger) {
            //关闭触发
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        
        if (![self configStepTwoModel]) {
            [self operationFailedBlockWithMsg:@"Config Step Two Data Error" block:failedBlock];
            return;
        }
        
        if (![self configStepThreeModel]) {
            [self operationFailedBlockWithMsg:@"Config Step Three Data Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - Interface
- (BOOL)readStepOneModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepOneModel readWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStepOneModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepOneModel configWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readStepTwoModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepTwoModel readWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStepTwoModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepTwoModel configWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readStepThreeModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepThreeModel readWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStepThreeModel {
    __block BOOL success = NO;
    @weakify(self);
    [self.stepThreeModel configWithSucBlock:^{
        @strongify(self);
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - Private method
- (NSString *)fetchTemperatureTriggerMsg {
    if (self.stepOneModel.tempEvent == 0) {
        //Above
        if (!self.stepThreeModel.trigger) {
            //不开启触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device temperature is more than or equal to %@℃, and stop advertising immediately after device temperature is less than %@℃",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),@(self.stepOneModel.temperature)];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising  at the interval of %@ms after device temperature is more than or equal to %@℃, and stop advertising immediately after device temperature is less than %@℃",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),@(self.stepOneModel.temperature)];
            }
            return @"";
        }
        //开启触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device temperature is more than or equal to %@℃, and advertising for %@s every %@s at the interval of %@ms when device temperature is less than %@℃",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),self.stepTwoModel.advDuration,self.stepTwoModel.standbyDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepTwoModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@" *The Beacon will advertising for %@s at the interval of %@ms when device temperature is more than or equal to %@℃, and  keep advertising at the interval of  %@ms when device temperature is less than %@℃",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device temperature is more than or equal to %@℃, and advertising for %@s every %@s at the interval of %@ms when device temperature is less than %@℃",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device temperature is more than or equal to %@℃, and  keep advertising at the interval of  %@ms when device temperature is less than %@℃",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        
        return @"";
    }
    if (self.stepOneModel.tempEvent == 1) {
        //Below
        if (!self.stepThreeModel.trigger) {
            //不开启触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device temperature is less than %@℃, and stop advertising immediately when device temperature is more than or equal to %@℃.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),@(self.stepOneModel.temperature)];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms after device temperature is less than %@℃, and stop advertising immediately when device temperature is more than or equal to %@℃. ",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),@(self.stepOneModel.temperature)];
            }
            return @"";
        }
        //开启触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device temperature is less than %@℃, and advertising for %@s every %@s at the interval of %@ms when device temperature is more than or equal to %@℃",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device temperature is less than %@℃, and  keep advertising at the interval of  %@ms when device temperature is more than or equal to %@℃",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device temperature is less than %@℃, and advertising for %@s every %@s at the interval of %@ms when device temperature is more than or equal to %@℃",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device temperature is less than %@℃, and  keep advertising at the interval of  %@ms when device temperatureis more than or equal to %@℃",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.temperature),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.temperature)];
        }
        
        return @"";
    }
    return @"";
}

- (NSString *)fetchHumidityTriggerMsg {
    if (self.stepOneModel.humidityEvent == 0) {
        //Above
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device humidity is more than or equal to  %@%, and stop advertising immediately after device humidity is less than %@%",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.humidity),@(self.stepOneModel.humidity)];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising after at the interval of %@ms device humidity is more than or equal to  %@%, and stop advertising immediately after device humidity is less than %@%",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.humidity),@(self.stepOneModel.humidity)];
            }
            
            return @"";
        }
        //开启触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device humidity is more than or equal to  %@%, and advertising for %@s every %@s at the interval of %@ms when device humidity is less than  %@%",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.humidity),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device humidity is more than or equal to  %@%, and  keep advertising at the interval of  %@ms when device humidity is less than  %@%",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device humidity is more than or equal to  %@%, and advertising for %@s every %@s at the interval of %@ms when device humidity is less than  %@%",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device humidity is more than or equal to  %@%, and  keep advertising at the interval of  %@ms when device humidity is less than  %@%",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        
        return @"";
    }
    if (self.stepOneModel.humidityEvent == 1) {
        //Below
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device humidity is less than  %@%, and stop advertising immediately when device humidity is more than or equal to %@%.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.stepOneModel.humidity),@(self.self.stepOneModel.humidity)];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms after device humidity is less than  %@%, and stop advertising immediately when device humidity is more than or equal to %@%.",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),@(self.self.stepOneModel.humidity)];
            }
            
            return @"";
        }
        //开启触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device humidity is less than  %@%, and advertising for %@s every %@s at the interval of %@ms when device humidity is more than or equal to  %@%",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device humidity is less than  %@%, and  keep advertising at the interval of  %@ms when device humidity is more than or equal to  %@%",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device humidity is less than  %@%, and advertising for %@s every %@s at the interval of %@ms when device humidity is more than or equal to  %@%",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device humidity is less than  %@%, and  keep advertising at the interval of  %@ms when device humidity more than or equal to  %@%",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],@(self.self.stepOneModel.humidity),[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],@(self.self.stepOneModel.humidity)];
        }
        
        return @"";
    }
    return @"";
}

- (NSString *)fetchMotionTriggerMsg {
    if (self.stepOneModel.motionEvent == 0) {
        //Device start moving
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device moves, and stop advertising immediately after device keep stationary for %@s",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms after device moves, and stop advertising immediately after device keep stationary for %@s",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
            }
            
            return @"";
        }
        //打开触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after device moves, and advertising for %@s every %@s at the interval of %@ms when device keep stationary for %@s",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after device moves, and  keep advertising at the interval of  %@ms when device keep stationary for %@s",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after device moves, and advertising for %@s every %@s at the interval of %@ms when device keep stationary for %@s",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after device moves, and  keep advertising at the interval of  %@ms when device keep stationary for %@s",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:self.stepThreeModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
        }
        
        return @"";
    }
    if (self.stepOneModel.motionEvent == 1) {
        //Device remains stationary
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after device keep stationary for %@s, and stop advertising immediately when device moves.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms after device keep stationary for %@s, and stop advertising immediately when device moves. ",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod];
            }
            
            return @"";
        }
        //打开触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device keep stationary for %@s, and advertising for %@s every %@s at the interval of %@ms after device moves",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod,self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms when device keep stationary for %@s, and  keep advertising at the interval of  %@ms after device moves",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device keep stationary for %@s, and advertising for %@s every %@s at the interval of %@ms after device moves",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod,self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms when device keep stationary for %@s, and  keep advertising at the interval of  %@ms after device moves",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.self.stepOneModel.motionVerificationPeriod,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        
        return @"";
    }
    return @"";
}

- (NSString *)fetchHallTriggerMsg {
    if (self.stepOneModel.hallEvent == 0) {
        //Door open
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms after door open, and stop advertising immediately when door is closed.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval]];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms after device moves, and stop advertising immediately when door is closed.",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval]];
            }
            
            return @"";
        }
        //打开触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after door open, and advertising for %@s every %@s at the interval of %@ms when door is closed",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after door open, and  keep advertising at the interval of  %@ms when door is closed",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after door open, and advertising for %@s every %@s at the interval of %@ms when door is closed",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after door open, and  keep advertising at the interval of  %@ms when door is closed",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        
        return @"";
    }
    if (self.stepOneModel.hallEvent == 1) {
        //Door close
        if (!self.stepThreeModel.trigger) {
            //关闭触发前广播
            if ([self.stepTwoModel.advDuration integerValue] > 0) {
                return [NSString stringWithFormat:@"*The Beacon will start advertising for %@s at the interval of %@ms  after door is closed, and stop advertising immediately when door is opened.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval]];
            }
            if ([self.stepTwoModel.advDuration integerValue] == 0) {
                return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of %@ms  after door is closed, and stop advertising immediately when door is opened. ",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval]];
            }
            
            return @"";
        }
        //打开触发前广播
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after door is closed, and advertising for %@s every %@s at the interval of %@ms when door is opened.",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] > 0) {
            return [NSString stringWithFormat:@"*The Beacon will advertising for %@s at the interval of %@ms after door is closed, and  keep advertising at the interval of  %@ms when door is opened. ",self.stepTwoModel.advDuration,[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] > 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after door is closed, and advertising for %@s every %@s at the interval of %@ms when door is opened. ",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],self.stepThreeModel.advDuration,self.stepThreeModel.standbyDuration,[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]];
        }
        if ([self.stepThreeModel.standbyDuration integerValue] == 0 && [self.stepTwoModel.advDuration integerValue] == 0) {
            return [NSString stringWithFormat:@"*The Beacon will keep advertising at the interval of  %@ms after door is closed, and  keep advertising at the interval of  %@ms when door is opened. ",[self fetchIntervalMsgValue:self.stepTwoModel.advInterval],[self fetchIntervalMsgValue:[self fetchIntervalMsgValue:self.stepThreeModel.advInterval]]];
        }
        
        return @"";
    }
    return @"";
}

- (NSString *)fetchIntervalMsgValue:(NSString *)interval {
    return [NSString stringWithFormat:@"%ld",(long)[interval integerValue] * 100];
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"triggerParams"
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

- (MKBXSTriggerStepOneModel *)stepOneModel {
    if (!_stepOneModel) {
        _stepOneModel = [[MKBXSTriggerStepOneModel alloc] initWithSlotIndex:self.slotIndex];
    }
    return _stepOneModel;
}

- (MKBXSTriggerStepTwoModel *)stepTwoModel {
    if (!_stepTwoModel) {
        _stepTwoModel = [[MKBXSTriggerStepTwoModel alloc] initWithSlotIndex:self.slotIndex];
    }
    return _stepTwoModel;
}

- (MKBXSTriggerStepThreeModel *)stepThreeModel {
    if (!_stepThreeModel) {
        _stepThreeModel = [[MKBXSTriggerStepThreeModel alloc] initWithSlotIndex:self.slotIndex];
    }
    return _stepThreeModel;
}

@end
