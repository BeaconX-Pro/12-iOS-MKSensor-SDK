//
//  MKBXSSlotDataBaseModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKBXSSlotDataBaseModel.h"

#import "MKMacroDefines.h"

#import "MKBXSSDKDataAdopter.h"

@implementation MKBXSSlotParamsDataModel
@end

@implementation MKBXSSlotTriggerParamsDataModel
@end

@interface MKBXSSlotDataBaseModel ()

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKBXSSlotDataBaseModel

- (instancetype)initWithSlotIndex:(NSInteger)index {
    if (self = [super init]) {
        self.index = index;
    }
    return self;
}

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
}

- (void)updateSlotDatas:(NSDictionary *)dic {
    if (!ValidDict(dic)) {
        return;
    }
    self.advInterval = [NSString stringWithFormat:@"%ld",(long)([dic[@"advInterval"] integerValue] * 0.01)];
    self.advDuration = dic[@"advDuration"];
    self.standbyDuration = ([dic[@"standbyDuration"] integerValue] == 0 ? @"" : dic[@"standbyDuration"]);
    self.powerModeIsOn = ([dic[@"standbyDuration"] integerValue] > 0);
    self.rssi = [dic[@"rssi"] integerValue];
    self.txPower = [self getTxPowerValue:dic[@"txPower"]];
    NSString *slotType = dic[@"slotType"];
    if ([slotType isEqualToString:@"ff"]) {
        //No Data
        self.slotType = bxs_slotType_null;
        return;
    }
    if ([slotType isEqualToString:@"00"]) {
        //UID
        self.slotType = bxs_slotType_uid;
        self.namespaceID = dic[@"advContent"][@"namespaceID"];
        self.instanceID = dic[@"advContent"][@"instanceID"];
        return;
    }
    if ([slotType isEqualToString:@"10"]) {
        //URL
        self.slotType = bxs_slotType_url;
        self.urlType = [dic[@"advContent"][@"urlType"] integerValue];
        self.urlContent = dic[@"advContent"][@"urlContent"];
        return;
    }
    if ([slotType isEqualToString:@"20"]) {
        //TLM
        self.slotType = bxs_slotType_tlm;
        return;
    }
    if ([slotType isEqualToString:@"50"]) {
        //iBeacon
        self.slotType = bxs_slotType_beacon;
        self.major = dic[@"advContent"][@"major"];
        self.minor = dic[@"advContent"][@"minor"];
        self.uuid = dic[@"advContent"][@"uuid"];
        return;
    }
    if ([slotType isEqualToString:@"80"]) {
        //Tag Info
        self.slotType = bxs_slotType_sensorInfo;
        self.deviceName = dic[@"advContent"][@"deviceName"];
        self.tagID = dic[@"advContent"][@"tagID"];
        return;
    }
}

- (NSInteger)getTxPowerValue:(NSString *)power {
    if ([power isEqualToString:@"-20dBm"]) {
        return 0;
    }
    if ([power isEqualToString:@"-16dBm"]) {
        return 1;
    }
    if ([power isEqualToString:@"-12dBm"]) {
        return 2;
    }
    if ([power isEqualToString:@"-8dBm"]) {
        return 3;
    }
    if ([power isEqualToString:@"-4dBm"]) {
        return 4;
    }
    if ([power isEqualToString:@"0dBm"]) {
        return 5;
    }
    if ([power isEqualToString:@"3dBm"]) {
        return 6;
    }
    if ([power isEqualToString:@"4dBm"]) {
        return 7;
    }
    if ([power isEqualToString:@"6dBm"]) {
        return 8;
    }
    return 0;
}

- (BOOL)validParams {
    if (self.slotType == bxs_slotType_null) {
        //No Data
        return YES;
    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.advDuration) || [self.advDuration integerValue] < 1 || [self.advDuration integerValue] > 65535) {
        return NO;
    }
    if (self.powerModeIsOn) {
        if (!ValidStr(self.standbyDuration) || [self.standbyDuration integerValue] < 1 || [self.standbyDuration integerValue] > 65535) {
            return NO;
        }
    }
    
    if (self.slotType != bxs_slotType_tlm) {
        if (self.rssi < -127 || self.rssi > 0) {
            return NO;
        }
    }
    if (self.slotType == bxs_slotType_uid) {
        if (!ValidStr(self.namespaceID) || self.namespaceID.length != 20 || !ValidStr(self.instanceID) || self.instanceID.length != 12) {
            return NO;
        }
    }else if (self.slotType == bxs_slotType_url) {
        NSString *result = [MKBXSSDKDataAdopter fetchUrlString:self.urlType urlContent:self.urlContent];
        if (!ValidStr(result)) {
            return NO;
        }
    }else if (self.slotType == bxs_slotType_beacon) {
        if (!ValidStr(self.major) || ![self.major integerValue] < 0 || [self.major integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.minor) || ![self.minor integerValue] < 0 || [self.minor integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.uuid) || self.uuid.length != 32) {
            return NO;
        }
    }else if (self.slotType == bxs_slotType_sensorInfo) {
        if (!ValidStr(self.deviceName) || self.deviceName.length > 20) {
            return NO;
        }
        if (!ValidStr(self.tagID) || self.tagID.length > 12 || (self.tagID.length % 2 != 0)) {
            return NO;
        }
    }
    
    return YES;
}

- (MKBXSSlotParamsDataModel *)currentContentParam {
    MKBXSSlotParamsDataModel *param = [[MKBXSSlotParamsDataModel alloc] init];
    param.advInterval = [self.advInterval integerValue] * 100;
    param.advDuration = [self.advDuration integerValue];
    NSInteger standbyDuration = (self.powerModeIsOn ? [self.standbyDuration integerValue] : 0);
    param.standbyDuration = standbyDuration;
    param.rssi = self.rssi;
    param.txPower = self.txPower;
    return param;
}

- (MKBXSSlotTriggerParamsDataModel *)currentTriggerContentParam {
    MKBXSSlotTriggerParamsDataModel *param = [[MKBXSSlotTriggerParamsDataModel alloc] init];
    param.advInterval = [self.advInterval integerValue] * 100;
    param.advDuration = [self.advDuration integerValue];
    param.rssi = self.rssi;
    param.txPower = self.txPower;
    return param;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"slotParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

@end
