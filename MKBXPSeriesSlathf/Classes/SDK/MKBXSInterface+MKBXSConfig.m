//
//  MKBXSInterface+MKBXSConfig.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSInterface+MKBXSConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXSCentralManager.h"
#import "MKBXSOperationID.h"
#import "MKBXSOperation.h"
#import "CBPeripheral+MKBXSAdd.h"
#import "MKBXSSDKDataAdopter.h"

#define centralManager [MKBXSCentralManager shared]
#define peripheral ([MKBXSCentralManager shared].peripheral)

@implementation MKBXSInterface (MKBXSConfig)

#pragma mark - AA01 自定义

+ (void)bxs_configThreeAxisDataParams:(mk_bxs_threeAxisDataRate)dataRate
                         acceleration:(mk_bxs_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (motionThreshold < 1 || motionThreshold > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [MKBXSSDKDataAdopter fetchThreeAxisDataRate:dataRate];
    NSString *ag = [MKBXSSDKDataAdopter fetchThreeAxisDataAG:acceleration];
    NSString *threshold = [MKBLEBaseSDKAdopter fetchHexValue:motionThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea012103",rate,ag,threshold];
    [self configDataWithTaskID:mk_bxs_taskConfigThreeAxisDataParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configADVChannel:(mk_bxs_advChannel)channel
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *rateString = [MKBXSSDKDataAdopter fetchAdvChannelCmd:channel];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea013501",rateString];
    [self configDataWithTaskID:mk_bxs_taskConfigADVChannelOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}











+ (void)bxs_configTriggeredSlotParamWithIndex:(NSInteger)index
                                  advInterval:(NSInteger)advInterval
                                  advDuration:(NSInteger)advDuration
                                         rssi:(NSInteger)rssi
                                      txPower:(mk_bxs_txPower)txPower
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || advInterval < 1 || advInterval > 100
        || advDuration < 1 || advDuration > 65535 || rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:(index + 3) byteLen:1];
    NSString *advIntervalValue = [MKBLEBaseSDKAdopter fetchHexValue:(advInterval * 100) byteLen:2];
    NSString *advDurationValue = [MKBLEBaseSDKAdopter fetchHexValue:advDuration byteLen:2];
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *txPowerValue = [MKBXSSDKDataAdopter fetchTxPower:txPower];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea012407",indexValue,advIntervalValue,advDurationValue,rssiValue,txPowerValue];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggeredSlotParamOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012600";
    [self configDataWithTaskID:mk_bxs_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}



+ (void)bxs_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012800";
    [self configDataWithTaskID:mk_bxs_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}







+ (void)bxs_configHallDataStoreStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea016d0101" : @"ea016d0100");
    [self configDataWithTaskID:mk_bxs_taskConfigHallDataStoreStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_clearHallHistoryDataWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea016f0100";
    [self configDataWithTaskID:mk_bxs_taskClearHallHistoryDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_batteryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea016b0101";
    [self configDataWithTaskID:mk_bxs_taskConfigBatteryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}






#pragma mark - 新做
+ (void)bxs_configResetDeviceByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01230101" : @"ea01230100");
    [self configDataWithTaskID:mk_bxs_taskConfigResetDeviceByButtonStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configHallSensorStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01250101" : @"ea01250100");
    [self configDataWithTaskID:mk_bxs_taskConfigHallSensorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_closeSlotTriggerWithIndex:(NSInteger)index
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea013108",indexValue,@"00000000000000"];
    [self configDataWithTaskID:mk_bxs_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configTemperatureTriggerParams:(NSInteger)slotIndex
                              triggerEvent:(NSInteger)event
                               temperature:(NSInteger)temperature
                                 lockedADV:(BOOL)lockedADV
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (slotIndex < 0 || slotIndex > 2 || temperature < -40 || temperature > 150 || event < 0 || event > 1) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:slotIndex byteLen:1];
    NSString *eventHex = (event == 0 ? @"10" : @"11");
    NSString *tempHex = [MKBXSSDKDataAdopter temperatureToHexString:temperature];
    NSString *lockState = (lockedADV ? @"01" : @"00");
    NSString *staticPeriod = [MKBLEBaseSDKAdopter fetchHexValue:0 byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea013108",indexValue,@"01",eventHex,tempHex,lockState,staticPeriod];
    [self configDataWithTaskID:mk_bxs_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configHumidityTriggerParams:(NSInteger)slotIndex
                           triggerEvent:(NSInteger)event
                               humidity:(NSInteger)humidity
                              lockedADV:(BOOL)lockedADV
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (slotIndex < 0 || slotIndex > 2 || humidity < 0 || humidity > 100 || event < 0 || event > 1) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:slotIndex byteLen:1];
    NSString *eventHex = (event == 0 ? @"20" : @"21");
    NSString *humidityValue = [MKBLEBaseSDKAdopter fetchHexValue:humidity byteLen:2];
    NSString *lockState = (lockedADV ? @"01" : @"00");
    NSString *staticPeriod = [MKBLEBaseSDKAdopter fetchHexValue:0 byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea013108",indexValue,@"02",eventHex,humidityValue,lockState,staticPeriod];
    [self configDataWithTaskID:mk_bxs_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configMotionDetectionTriggerParams:(NSInteger)slotIndex
                                  triggerEvent:(NSInteger)event
                                        period:(NSInteger)period
                                     lockedADV:(BOOL)lockedADV
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (slotIndex < 0 || slotIndex > 2 || period < 1 || period > 65535 || event < 0 || event > 1) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:slotIndex byteLen:1];
    NSString *eventHex = (event == 0 ? @"30" : @"31");
    NSString *lockState = (lockedADV ? @"01" : @"00");
    NSString *staticPeriod = [MKBLEBaseSDKAdopter fetchHexValue:period byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea013108",indexValue,@"03",eventHex,@"0000",lockState,staticPeriod];
    [self configDataWithTaskID:mk_bxs_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configHallTriggerParams:(NSInteger)slotIndex
                       triggerEvent:(NSInteger)event
                          lockedADV:(BOOL)lockedADV
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (slotIndex < 0 || slotIndex > 2 || event < 0 || event > 1) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:slotIndex byteLen:1];
    NSString *eventHex = (event == 0 ? @"40" : @"41");
    NSString *lockState = (lockedADV ? @"01" : @"00");
    NSString *staticPeriod = [MKBLEBaseSDKAdopter fetchHexValue:0 byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea013108",indexValue,@"04",eventHex,@"0000",lockState,staticPeriod];
    [self configDataWithTaskID:mk_bxs_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotNoDataWithIndex:(NSInteger)index
                                 type:(mk_bxs_slotDataType)type
                            advParams:(id <mk_bxs_slotAdvContentParam>)param
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"ff"];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotUIDWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                       namespaceID:(NSString *)namespaceID
                        instanceID:(NSString *)instanceID
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || namespaceID.length != 20 || ![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID]
        || instanceID.length != 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:instanceID]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + 10 + 6;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"00",namespaceID,instanceID];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotURLWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                           urlType:(mk_bxs_urlHeaderType)urlType
                        urlContent:(NSString *)urlContent
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *urlString = [MKBXSSDKDataAdopter fetchUrlString:urlType urlContent:urlContent];
    if (!MKValidStr(urlString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + (urlString.length / 2);
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"10",urlString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTLMWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"20"];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotBeaconWithIndex:(NSInteger)index
                                 type:(mk_bxs_slotDataType)type
                            advParams:(id <mk_bxs_slotAdvContentParam>)param
                                major:(NSInteger)major
                                minor:(NSInteger)minor
                                 uuid:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || major < 0 || major > 65535
        || minor < 0 || minor > 65535 || !MKValidStr(uuid) || uuid.length != 32
        || ![MKBLEBaseSDKAdopter checkHexCharacter:uuid]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + 20;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    
    NSString *majorValue = [MKBLEBaseSDKAdopter fetchHexValue:major byteLen:2];
    NSString *minorValue = [MKBLEBaseSDKAdopter fetchHexValue:minor byteLen:2];
    
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"50",uuid,majorValue,minorValue];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotSensorInfoWithIndex:(NSInteger)index
                                     type:(mk_bxs_slotDataType)type
                                advParams:(id <mk_bxs_slotAdvContentParam>)param
                               deviceName:(NSString *)deviceName
                                    tagID:(NSString *)tagID
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || !MKValidStr(deviceName) || deviceName.length > 20 || !MKValidStr(tagID) || tagID.length > 12 || (tagID.length % 2 != 0)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    NSString *typeString = @"34";
    if (type == mk_bxs_slotDataType_beforeTriggerData) {
        typeString = @"32";
        taskID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *nameLen = [MKBLEBaseSDKAdopter fetchHexValue:(deviceName.length) byteLen:1];
    NSString *tagIDLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagID.length / 2) byteLen:1];
    
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //2Byte standbyDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + deviceName.length + (tagID.length / 2) + 2;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"ea01",typeString,lenString,indexValue,paramsCmd,@"80",nameLen,tempString,tagIDLen,tagID];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredNoDataWithIndex:(NSInteger)index
                                     advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    mk_bxs_taskOperationID taskID = mk_bxs_taskConfigSlotDataOperation;
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration + 1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"ff"];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredUIDWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                namespaceID:(NSString *)namespaceID
                                 instanceID:(NSString *)instanceID
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || namespaceID.length != 20 || ![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID]
        || instanceID.length != 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:instanceID]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + 10 + 6;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"00",namespaceID,instanceID];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredURLWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                    urlType:(mk_bxs_urlHeaderType)urlType
                                 urlContent:(NSString *)urlContent
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *urlString = [MKBXSSDKDataAdopter fetchUrlString:urlType urlContent:urlContent];
    if (!MKValidStr(urlString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + (urlString.length / 2);
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"10",urlString];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredTLMWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +f
    //1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"20"];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredBeaconWithIndex:(NSInteger)index
                                     advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                         major:(NSInteger)major
                                         minor:(NSInteger)minor
                                          uuid:(NSString *)uuid
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || major < 0 || major > 65535
        || minor < 0 || minor > 65535 || !MKValidStr(uuid) || uuid.length != 32
        || ![MKBLEBaseSDKAdopter checkHexCharacter:uuid]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + 20;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    
    NSString *majorValue = [MKBLEBaseSDKAdopter fetchHexValue:major byteLen:2];
    NSString *minorValue = [MKBLEBaseSDKAdopter fetchHexValue:minor byteLen:2];
    
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"50",uuid,majorValue,minorValue];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configSlotTriggeredSensorInfoWithIndex:(NSInteger)index
                                         advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                        deviceName:(NSString *)deviceName
                                             tagID:(NSString *)tagID
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 2 || !MKValidStr(deviceName) || deviceName.length > 20 || !MKValidStr(tagID) || tagID.length > 12 || (tagID.length % 2 != 0)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *paramsCmd = [MKBXSSDKDataAdopter fetchSlotTriggerdAdvParamsCmd:param];
    if (paramsCmd.length == 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *nameLen = [MKBLEBaseSDKAdopter fetchHexValue:(deviceName.length) byteLen:1];
    NSString *tagIDLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagID.length / 2) byteLen:1];
    
    //1Byte SlotIndex + 2Byte AdvInterval + 2Byte AdvDuration +
    //1Byte Rssi + 1Byte TxPower + 1Byte SlotType + 通道内容
    NSInteger len = 1 + (paramsCmd.length) / 2 + 1 + deviceName.length + (tagID.length / 2) + 2;
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:len byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"ea0133",lenString,indexValue,paramsCmd,@"80",nameLen,tempString,tagIDLen,tagID];
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configDirectionFindingStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01360101" : @"ea01360100");
    [self configDataWithTaskID:mk_bxs_taskConfigDirectionFindingStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (connectable ? @"ea01370101" : @"ea01370100");
    [self configDataWithTaskID:mk_bxs_taskConfigConnectableOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configTagIDAutofillStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea013c0101" : @"ea013c0100");
    [self configDataWithTaskID:mk_bxs_taskConfigTagIDAutofillStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configDeviceTime:(unsigned long)timestamp
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)timestamp];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea013f04",value];
    [self configDataWithTaskID:mk_bxs_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configTHDataStoreStatus:(BOOL)isOn
                           interval:(NSInteger)interval
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea014003",status,intervalString];
    [self configDataWithTaskID:mk_bxs_taskConfigTHDataStoreStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configTHSamplingRate:(NSInteger)rate
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rate < 1 || rate > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rateString = [MKBLEBaseSDKAdopter fetchHexValue:rate byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea014102",rateString];
    [self configDataWithTaskID:mk_bxs_taskConfigTHSamplingRateOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_deleteBXPRecordHTDatasWithSucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014200";
    [self configDataWithTaskID:mk_bxs_taskDeleteBXPRecordHTDatasOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configRemoteReminderLEDNotiParams:(NSInteger)blinkingTime
                             blinkingInterval:(NSInteger)blinkingInterval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (blinkingTime < 1 || blinkingTime > 600 || blinkingInterval < 1 || blinkingInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:(blinkingTime * 10) byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:(blinkingInterval * 100) byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea01610503",interval,time];
    [self configDataWithTaskID:mk_bxs_taskConfigRemoteReminderLEDNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configRemoteReminderBuzzerNotiParams:(NSInteger)ringTime
                                blinkingInterval:(NSInteger)ringInterval
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (ringTime < 1 || ringTime > 600 || ringInterval < 1 || ringInterval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:(ringTime * 10) byteLen:2];
    NSString *interval = [MKBLEBaseSDKAdopter fetchHexValue:(ringInterval * 100) byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0162050e",interval,time];
    [self configDataWithTaskID:mk_bxs_taskConfigRemoteReminderBuzzerNotiParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configRemoteReminderBuzzerFrequency:(mk_bxs_buzzerRingingFrequencyType)frequency
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (frequency == mk_bxs_buzzerRingingFrequencyType_higher ? @"ea0163021194" : @"ea0163020fa0");
    [self configDataWithTaskID:mk_bxs_taskConfigRemoteReminderBuzzerFrequencyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01650101" : @"ea01650100");
    [self configDataWithTaskID:mk_bxs_taskConfigTriggerLEDIndicatorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_clearHallTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea016800";
    [self configDataWithTaskID:mk_bxs_taskClearHallTriggerCountOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_clearMotionTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea016900";
    [self configDataWithTaskID:mk_bxs_taskClearMotionTriggerCountOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxs_configBatteryADVMode:(mk_bxs_batteryADVMode)mode
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:(mode + 1) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea016c01",valueString];
    [self configDataWithTaskID:mk_bxs_taskConfigBatteryADVModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}



#pragma mark - AA07 密码相关

+ (void)bxs_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0152",lenString,commandData];
    [self configPasswordDataWithTaskID:mk_bxs_taskConfigConnectPasswordOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

+ (void)bxs_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01530101" : @"ea01530100");
    [self configPasswordDataWithTaskID:mk_bxs_taskConfigPasswordVerificationOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_bxs_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxs_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)configPasswordDataWithTaskID:(mk_bxs_taskOperationID)taskID
                                data:(NSString *)data
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxs_password commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)configHTDataWithTaskID:(mk_bxs_taskOperationID)taskID
                          data:(NSString *)data
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxs_temperatureHumidity commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
