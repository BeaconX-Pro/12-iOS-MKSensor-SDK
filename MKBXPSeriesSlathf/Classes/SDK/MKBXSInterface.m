//
//  MKBXSInterface.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXSCentralManager.h"
#import "MKBXSOperationID.h"
#import "MKBXSOperation.h"
#import "MKBXSSDKDataAdopter.h"
#import "CBPeripheral+MKBXSAdd.h"

#define centralManager [MKBXSCentralManager shared]
#define peripheral ([MKBXSCentralManager shared].peripheral)

@implementation MKBXSInterface

#pragma mark ***********************************Custom****************************************

+ (void)bxs_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadMacAddressOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadThreeAxisDataParamsOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadFirmwareOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadManufacturerOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadProductDateOperation
                     cmdFlag:@"2b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadSoftwareOperation
                     cmdFlag:@"2c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHardwareOperation
                     cmdFlag:@"2d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadDeviceModelOperation
                     cmdFlag:@"2e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadConnectableOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}



















+ (void)bxs_readTriggeredSlotParamsWithIndex:(NSInteger)index
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:(index + 3) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea002401",indexString];
    [centralManager addTaskWithTaskID:mk_bxs_taskReadTriggeredSlotParamsOperation
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}





+ (void)bxs_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadDeviceTypeOperation
                     cmdFlag:@"2f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}















+ (void)bxs_readSlotAdvTypeWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadSlotAdvTypeOperation
                     cmdFlag:@"6c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHallDataStoreStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHallDataStoreStatusOperation
                     cmdFlag:@"6d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHallHistoryDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHallHistoryDataOperation
                     cmdFlag:@"6e"
                    sucBlock:^(id returnData) {
        NSArray *list = [MKBXSSDKDataAdopter parseHallData:returnData[@"result"]];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"list":list
                                    },
                                };
        sucBlock(resultDic);
    } failedBlock:failedBlock];
}


#pragma mark - 新做的
+ (void)bxs_readResetDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadResetDeviceByButtonStatusOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHallSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHallSensorStatusOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readSlotTypeWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadSlotTypeOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readSlotTriggerDataWithIndex:(NSInteger)index
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ea003101" stringByAppendingString:[MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1]];
    [centralManager addTaskWithTaskID:mk_bxs_taskReadSlotTriggerDataOperation
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxs_readBeforeTriggerSlotDataWithIndex:(NSInteger)index
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea003201",indexString];
    [centralManager addTaskWithTaskID:mk_bxs_taskReadBeforeTriggerSlotDataOperation
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxs_readTriggerSlotDataWithIndex:(NSInteger)index
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea003301",indexString];
    [centralManager addTaskWithTaskID:mk_bxs_taskReadTriggerSlotDataOperation
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxs_readSlotDataWithIndex:(NSInteger)index
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea003401",indexString];
    [centralManager addTaskWithTaskID:mk_bxs_taskReadSlotDataOperation
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxs_readADVChannelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadADVChannelOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readDirectionFindingStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadDirectionFindingStatusOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readTagIDAutofillStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskTagIDAutofillStatusOperation
                     cmdFlag:@"3c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readDeviceRuntimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskDeviceRuntimeOperation
                     cmdFlag:@"3e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readDeviceUTCTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadDeviceUTCTimeOperation
                     cmdFlag:@"3f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readTHDataStoreParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadTHDataStoreStatusOperation
                     cmdFlag:@"40"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHTSamplingRateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadTHSamplingRateOperation
                     cmdFlag:@"41"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHTRecordTotalNumbersWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHTRecordTotalNumbersOperation
                     cmdFlag:@"43"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readSensorTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadSensorTypeOperation
                     cmdFlag:@"4a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readRemoteReminderBuzzerFrequencyWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadRemoteReminderBuzzerFrequencyOperation
                     cmdFlag:@"63"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadTriggerLEDIndicatorStatusOperation
                     cmdFlag:@"65"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readHallTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadHallTriggerCountOperation
                     cmdFlag:@"68"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readMotionTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadMotionTriggerCountOperation
                     cmdFlag:@"69"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadBatteryVoltageOperation
                     cmdFlag:@"6a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readBatteryPercentageWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadBatteryPercentageOperation
                     cmdFlag:@"6b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxs_readBatteryADVModeWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxs_taskReadBatteryADVModeOperation
                     cmdFlag:@"6c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}


#pragma mark - AA06 温湿度相关

+ (void)bxs_readTemperatureHumidityDataWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea007000";
    [centralManager addReadTaskWithTaskID:mk_bxs_taskReadTemperatureHumidityDataOperation
                           characteristic:peripheral.bxs_temperatureHumidity
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}


#pragma mark - AA07 密码相关

+ (void)bxs_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readPasswordDataWithTaskID:mk_bxs_taskReadNeedPasswordOperation
                             cmdFlag:@"53"
                            sucBlock:^(id returnData) {
        BOOL isOn = [returnData[@"result"][@"state"] isEqualToString:@"01"];
        NSDictionary *dic = @{
            @"msg":@"success",
            @"code":@"1",
            @"result":@{
                @"isOn":@(isOn)
            },
        };
        if (sucBlock) {
            sucBlock(dic);
        }
    } failedBlock:failedBlock];
}

#pragma mark - AA08 霍尔传感器数据

+ (void)bxs_readMagnetStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxs_taskReadMagnetStatusOperation
                           characteristic:peripheral.bxs_hallSensor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - private method
+ (void)readDataWithTaskID:(mk_bxs_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxs_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readPasswordDataWithTaskID:(mk_bxs_taskOperationID)taskID
                           cmdFlag:(NSString *)flag
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxs_password
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
