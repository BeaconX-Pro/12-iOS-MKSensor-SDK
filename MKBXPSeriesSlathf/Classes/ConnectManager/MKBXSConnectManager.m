//
//  MKBXSConnectManager.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSConnectManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKBXSSDK.h"

@interface MKBXSConnectManager ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXSConnectManager

+ (MKBXSConnectManager *)shared {
    static MKBXSConnectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXSConnectManager new];
        }
    });
    return manager;
}

- (void)connectDevice:(CBPeripheral *)peripheral
             password:(NSString *)password
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.connectQueue, ^{
        NSDictionary *dic = @{};
        if (ValidStr(password) && password.length <= 16) {
            //有密码登录
            dic = [self connectDevice:peripheral password:password];
            self.needPassword = YES;
            self.password = password;
        }else {
            //免密登录
            dic = [self connectDevice:peripheral];
            self.needPassword = NO;
            self.password = @"";
        }
         
        if (![dic[@"success"] boolValue]) {
            [self operationFailedMsg:dic[@"msg"] completeBlock:failedBlock];
            return ;
        }
        
        if (![self readHallSensorStatus]) {
            [self operationFailedMsg:@"Read Hall Sensor Error" completeBlock:failedBlock];
            return;
        }
        
        if (![self readResetByButton]) {
            [self operationFailedMsg:@"Read Reset By Button Error" completeBlock:failedBlock];
            return;
        }
        
        if (![self readSensorType]) {
            [self operationFailedMsg:@"Read sensor type Error" completeBlock:failedBlock];
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
- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral password:(NSString *)password {
    __block NSDictionary *connectResult = @{};
    [[MKBXSCentralManager shared] connectPeripheral:peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral {
    __block NSDictionary *connectResult = @{};
    [[MKBXSCentralManager shared] connectPeripheral:peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (BOOL)configDate {
    return YES;
//    __block BOOL success = NO;
//    NSDate *zoneDate = [NSDate dateWithTimeIntervalSinceNow:-8*60*60];
//    NSTimeInterval interval = [zoneDate timeIntervalSince1970];
//    [MKBXSInterface bxs_configDeviceTime:(interval * 1000) sucBlock:^{
//        success = YES;
//        dispatch_semaphore_signal(self.semaphore);
//    } failedBlock:^(NSError * _Nonnull error) {
//        dispatch_semaphore_signal(self.semaphore);
//    }];
//    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//    return success;
}

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
        self.accStatus = [returnData[@"result"][@"axis"] integerValue];
        self.thStatus = [returnData[@"result"][@"tempHumidity"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedMsg:(NSString *)msg completeBlock:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        [[MKBXSCentralManager shared] disconnect];
        if (block) {
            NSError *error = [[NSError alloc] initWithDomain:@"connectDevice"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            block(error);
        }
    });
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

@end
