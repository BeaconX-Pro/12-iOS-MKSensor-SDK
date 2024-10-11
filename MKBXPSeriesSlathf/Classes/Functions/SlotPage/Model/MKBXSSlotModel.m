//
//  MKBXSSlotModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSSlotModel.h"

#import "MKMacroDefines.h"

#import "MKBXSInterface.h"

@interface MKBXSSlotModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, assign)BOOL slot0Trigger;

@property (nonatomic, assign)BOOL slot1Trigger;

@property (nonatomic, assign)BOOL slot2Trigger;

@end

@implementation MKBXSSlotModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSlotType]) {
            [self operationFailedBlockWithMsg:@"Read Slot Type Error" block:failedBlock];
            return;
        }
        
//        if (![self readSlotTriggerTypeList]) {
//            [self operationFailedBlockWithMsg:@"Read Slot Trigger Type List Error" block:failedBlock];
//            return;
//        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readSlotType {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSlotTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *slotList = returnData[@"result"][@"slotList"];
        if (slotList.count == 3) {
            self.slot1 = [self fetchSlotType:slotList[0]];
            self.slot2 = [self fetchSlotType:slotList[1]];
            self.slot3 = [self fetchSlotType:slotList[2]];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];

    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}


- (BOOL)readSlotTriggerTypeList {
    __block BOOL success = NO;
    [MKBXSInterface bxs_readSlotAdvTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *typeList = returnData[@"result"][@"typeList"];
        if (ValidArray(typeList) && typeList.count == 6) {
            if (self.slot0Trigger) {
                //Slot0有触发
                self.slot1 = [NSString stringWithFormat:@"%@/%@",[self fetchSlotType:typeList[0]],[self fetchSlotType:typeList[3]]];
            }else {
                self.slot1 = [self fetchSlotType:typeList[0]];
            }
            if (self.slot1Trigger) {
                //Slot1有触发
                self.slot2 = [NSString stringWithFormat:@"%@/%@",[self fetchSlotType:typeList[1]],[self fetchSlotType:typeList[4]]];
            }else {
                self.slot2 = [self fetchSlotType:typeList[1]];
            }
            if (self.slot2Trigger) {
                //Slot2有触发
                self.slot3 = [NSString stringWithFormat:@"%@/%@",[self fetchSlotType:typeList[2]],[self fetchSlotType:typeList[5]]];
            }else {
                self.slot3 = [self fetchSlotType:typeList[2]];
            }
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
        NSError *error = [[NSError alloc] initWithDomain:@"slotType"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (NSString *)fetchSlotType:(NSString *)type {
    if ([type isEqualToString:@"00"]) {
        return @"UID";
    }
    if ([type isEqualToString:@"10"]) {
        return @"URL";
    }
    if ([type isEqualToString:@"20"]) {
        return @"TLM";
    }
    if ([type isEqualToString:@"50"]) {
        return @"iBeacon";
    }
    if ([type isEqualToString:@"70"]) {
        return @"T&H_INFOR";
    }
    if ([type isEqualToString:@"80"]) {
        return @"Sensor info";
    }
    if ([type isEqualToString:@"ff"]) {
        return @"No data";
    }
    return @"";
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
        _readQueue = dispatch_queue_create("slotTypeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
