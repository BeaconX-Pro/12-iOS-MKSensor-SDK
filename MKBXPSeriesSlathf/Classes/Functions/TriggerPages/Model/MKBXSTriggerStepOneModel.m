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

#import "MKBXSConnectManager.h"

@implementation MKBXSTriggerTypeModel
@end

@interface MKBXSTriggerStepOneModel ()

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, strong)NSMutableArray <MKBXSTriggerTypeModel *>*triggerTypeList;

/// 0:温度触发  1:湿度触发  2:移动触发  3:霍尔触发
@property (nonatomic, assign)NSInteger currentTriggerType;

@end

@implementation MKBXSTriggerStepOneModel

- (instancetype)initWithSlotIndex:(NSInteger)index {
    if (self = [self init]) {
        self.index = index;
        [self loadTriggerTypeList];
    }
    return self;
}

#pragma mark - public method
- (NSArray *)fetchTriggerTypeList {
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 0; i < self.triggerTypeList.count; i ++) {
        MKBXSTriggerTypeModel *model = self.triggerTypeList[i];
        [list addObject:model.triggerMsg];
    }
    return list;
}

- (NSInteger)fetchTriggerType {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.triggerTypeList.count; i ++) {
        MKBXSTriggerTypeModel *model = self.triggerTypeList[i];
        if (model.triggerIndex == self.triggerIndex) {
            index = model.triggerType;
            break;
        }
    }
    return index;
}

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
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
        if ([self fetchTriggerType] == 0) {
            //温度触发
            if (![self configTemperatureTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Temperature Params Error" block:failedBlock];
                return;
            }
        }else if ([self fetchTriggerType] == 1) {
            //湿度触发
            if (![self configHumidityTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Humidity Params Error" block:failedBlock];
                return;
            }
        }else if ([self fetchTriggerType] == 2) {
            //移动触发
            if (![self configMotionDetectionTriggerParams]) {
                [self operationFailedBlockWithMsg:@"Config Trigger Motion Detection Params Error" block:failedBlock];
                return;
            }
        }else if ([self fetchTriggerType] == 3) {
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

- (BOOL)readTriggerDatas {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSlotTriggerDataWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateParams:returnData];
        [self updateTriggerIndex];
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
        if ([MKBXSConnectManager shared].accStatus > 0) {
            //存在移动触发
            self.currentTriggerType = 2;
            self.motionEvent = 0;
            self.motionVerificationPeriod = @"30";
            return;
        }
        //不存在三轴传感器
        if ([MKBXSConnectManager shared].thStatus > 0) {
            //存在温湿度传感器
            //显示温度触发
            self.currentTriggerType = 0;
            self.temperature = 0;
            self.tempEvent = 0;
            return;
        }
        //不存在移动和温度
        if (![MKBXSConnectManager shared].hallStatus && ![MKBXSConnectManager shared].resetByButton) {
            //显示门磁
            self.currentTriggerType = 3;
            self.hallEvent = 0;
            return;
        }
        return;;
    }
    self.currentTriggerType = ([returnData[@"result"][@"triggerType"] integerValue] - 1);
    self.lockedAdvIsOn = [returnData[@"result"][@"lockedAdv"] boolValue];
    if (self.currentTriggerType == 0) {
        //温度触发
        self.temperature = [returnData[@"result"][@"temperature"] integerValue];
        self.tempEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
    if (self.currentTriggerType == 1) {
        //湿度触发
        self.humidity = [returnData[@"result"][@"humidity"] integerValue];
        self.humidityEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
    if (self.currentTriggerType == 2) {
        //移动触发
        self.motionEvent = [returnData[@"result"][@"event"] integerValue];
        self.motionVerificationPeriod = returnData[@"result"][@"period"];
        return;
    }
    if (self.currentTriggerType == 3) {
        //霍尔触发
        self.hallEvent = [returnData[@"result"][@"event"] integerValue];
        return;
    }
}

- (void)updateTriggerIndex {
    for (NSInteger i = 0; i < self.triggerTypeList.count; i ++) {
        MKBXSTriggerTypeModel *model = self.triggerTypeList[i];
        if (model.triggerType == self.currentTriggerType) {
            self.triggerIndex = model.triggerIndex;
            break;
        }
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
    [MKBXSInterface bxs_configTemperatureTriggerParams:self.index triggerEvent:self.tempEvent temperature:self.temperature lockedADV:self.lockedAdvIsOn sucBlock:^{
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
    [MKBXSInterface bxs_configHumidityTriggerParams:self.index triggerEvent:self.humidityEvent humidity:self.humidity lockedADV:self.lockedAdvIsOn sucBlock:^{
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
    [MKBXSInterface bxs_configMotionDetectionTriggerParams:self.index triggerEvent:self.motionEvent period:[self.motionVerificationPeriod integerValue] lockedADV:self.lockedAdvIsOn sucBlock:^{
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
    [MKBXSInterface bxs_configHallTriggerParams:self.index triggerEvent:self.hallEvent lockedADV:self.lockedAdvIsOn sucBlock:^{
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
    
    if ([self fetchTriggerType] == 2) {
        //移动触发
        if (self.motionEvent < 0 || self.motionEvent > 1 || !ValidStr(self.motionVerificationPeriod) || [self.motionVerificationPeriod integerValue] < 1 || [self.motionVerificationPeriod integerValue] > 65535) {
            return NO;
        }
    }
    
    return YES;
}

- (void)loadTriggerTypeList {
    if ([MKBXSConnectManager shared].thStatus > 0) {
        MKBXSTriggerTypeModel *temperatureModel = [[MKBXSTriggerTypeModel alloc] init];
        temperatureModel.triggerMsg = @"Temperature detect";
        temperatureModel.triggerType = 0;
        [self.triggerTypeList addObject:temperatureModel];
        
        if ([MKBXSConnectManager shared].thStatus != 3) {
            //thStatus == 3:温度传感器，1/2/4为温湿度
            MKBXSTriggerTypeModel *humidityModel = [[MKBXSTriggerTypeModel alloc] init];
            humidityModel.triggerMsg = @"Humidity detect";
            humidityModel.triggerType = 1;
            [self.triggerTypeList addObject:humidityModel];
        }
    }
    
    if ([MKBXSConnectManager shared].accStatus > 0) {
        MKBXSTriggerTypeModel *motionModel = [[MKBXSTriggerTypeModel alloc] init];
        motionModel.triggerMsg = @"Motion detect";
        motionModel.triggerType = 2;
        [self.triggerTypeList addObject:motionModel];
    }
    
    if (![MKBXSConnectManager shared].hallStatus && ![MKBXSConnectManager shared].resetByButton) {
        MKBXSTriggerTypeModel *magneticModel = [[MKBXSTriggerTypeModel alloc] init];
        magneticModel.triggerMsg = @"magnetic detect";
        magneticModel.triggerType = 3;
        [self.triggerTypeList addObject:magneticModel];
    }
    for (NSInteger i = 0; i < self.triggerTypeList.count; i ++) {
        MKBXSTriggerTypeModel *model = self.triggerTypeList[i];
        model.triggerIndex = i;
    }
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

- (NSMutableArray<MKBXSTriggerTypeModel *> *)triggerTypeList {
    if (!_triggerTypeList) {
        _triggerTypeList = [NSMutableArray array];
    }
    return _triggerTypeList;
}

@end
