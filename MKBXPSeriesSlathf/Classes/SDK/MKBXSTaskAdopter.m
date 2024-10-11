//
//  MKBXSTaskAdopter.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBXSOperationID.h"
#import "MKBXSSDKDataAdopter.h"

NSString *const mk_bxs_totalNumKey = @"mk_bxs_totalNumKey";
NSString *const mk_bxs_totalIndexKey = @"mk_bxs_totalIndexKey";
NSString *const mk_bxs_contentKey = @"mk_bxs_contentKey";

@implementation MKBXSTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        return [self parseCustomData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        //密码相关
        return [self parsePasswordData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
        //温湿度相关
        return [self parseHTData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
        //霍尔传感器相关
        return [self parseHallSensorData:readData];
    }
    
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseHTData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseHTReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseHTConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseHTReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"70"]) {
        //读取温湿度实时数据
        operationID = mk_bxs_taskReadTemperatureHumidityDataOperation;
        NSInteger tempTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(0, 4)]] integerValue];
        NSInteger tempHui = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(4, 4)];
        NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
        NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];

        resultDic = @{
            @"temperature":temperature,
            @"humidity":humidity,
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseHTConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"51"]) {
        //验证密码
        operationID = mk_bxs_connectPasswordOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //修改密码
        operationID = mk_bxs_taskConfigConnectPasswordOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //是否需要密码验证
        operationID = mk_bxs_taskConfigPasswordVerificationOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parsePasswordData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parsePasswordReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parsePasswordConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePasswordReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"53"]) {
        //读取设备连接是否需要密码
        operationID = mk_bxs_taskReadNeedPasswordOperation;
        resultDic = @{
            @"state":content
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parsePasswordConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"51"]) {
        //验证密码
        operationID = mk_bxs_connectPasswordOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //修改密码
        operationID = mk_bxs_taskConfigConnectPasswordOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //是否需要密码验证
        operationID = mk_bxs_taskConfigPasswordVerificationOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    if ([headerString isEqualToString:@"ec"]) {
        //多包数据
        return [self parseMultiPacketData:readString];
    }
    if (![headerString isEqualToString:@"eb"]) {
        return @{};
    }
    
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"20"]) {
        //读取MAC地址
        operationID = mk_bxs_taskReadMacAddressOperation;
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
    }else if ([cmd isEqualToString:@"21"]){
        //读取三轴传感器参数
        operationID = mk_bxs_taskReadThreeAxisDataParamsOperation;
        resultDic = @{
                      @"samplingRate":[content substringWithRange:NSMakeRange(0, 2)],
                      @"gravityReference":[content substringWithRange:NSMakeRange(2, 2)],
                      @"motionThreshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)],
                      };
    }else if ([cmd isEqualToString:@"23"]){
        //读取按键复位功能
        operationID = mk_bxs_taskReadResetDeviceByButtonStatusOperation;
        resultDic = @{
                      @"isOn":@([content isEqualToString:@"01"]),
                      };
    }else if ([cmd isEqualToString:@"25"]){
        //读取霍尔开关机功能
        operationID = mk_bxs_taskReadHallSensorStatusOperation;
        resultDic = @{
                      @"isOn":@([content isEqualToString:@"01"]),
                      };
    }else if ([cmd isEqualToString:@"29"]){
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        
        operationID = mk_bxs_taskReadFirmwareOperation;
        resultDic = @{
                      @"firmware":tempString,
                      };
    }else if ([cmd isEqualToString:@"2a"]){
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        
        operationID = mk_bxs_taskReadManufacturerOperation;
        resultDic = @{
                      @"manufacturer":tempString,
                      };
    }else if ([cmd isEqualToString:@"2b"]){
        //生产日期
        NSString *year = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *month = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        if (month.length == 1) {
            month = [@"0" stringByAppendingString:month];
        }
        NSString *day = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        if (day.length == 1) {
            day = [@"0" stringByAppendingString:day];
        }
        
        operationID = mk_bxs_taskReadProductDateOperation;
        resultDic = @{
                      @"productionDate":[NSString stringWithFormat:@"%@/%@/%@",year,month,day],
                      };
    }else if ([cmd isEqualToString:@"2c"]){
        //software
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        
        operationID = mk_bxs_taskReadSoftwareOperation;
        resultDic = @{
                      @"software":tempString,
                      };
    }else if ([cmd isEqualToString:@"2d"]){
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        
        operationID = mk_bxs_taskReadHardwareOperation;
        resultDic = @{
                      @"hardware":tempString,
                      };
    }else if ([cmd isEqualToString:@"2e"]){
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        
        operationID = mk_bxs_taskReadDeviceModelOperation;
        resultDic = @{
                      @"modeID":tempString,
                      };
    }else if ([cmd isEqualToString:@"30"]){
        //读取广播通道类型
        operationID = mk_bxs_taskReadSlotTypeOperation;
        
        resultDic = @{
                      @"slotList":@[[content substringWithRange:NSMakeRange(0, 2)],
                                    [content substringWithRange:NSMakeRange(2, 2)],
                                    [content substringWithRange:NSMakeRange(4, 2)]],
                      };
    }else if ([cmd isEqualToString:@"31"]){
        //读取通道触发类型
        operationID = mk_bxs_taskReadSlotTriggerDataOperation;
        
        resultDic = [MKBXSSDKDataAdopter parseSlotTriggerParam:content];
    }else if ([cmd isEqualToString:@"32"]){
        //读取通道触发前广播参数
        operationID = mk_bxs_taskReadBeforeTriggerSlotDataOperation;
        
        resultDic = [MKBXSSDKDataAdopter parseSlotData:content advData:data hasStandbyDuration:YES];
    }else if ([cmd isEqualToString:@"33"]){
        //读取通道触发前广播参数
        operationID = mk_bxs_taskReadTriggerSlotDataOperation;
        
        resultDic = [MKBXSSDKDataAdopter parseSlotData:content advData:data hasStandbyDuration:NO];
    }else if ([cmd isEqualToString:@"34"]) {
        //读取通道广播内容
        operationID = mk_bxs_taskReadSlotDataOperation;
        resultDic = [MKBXSSDKDataAdopter parseSlotData:content advData:data hasStandbyDuration:YES];
    }else if ([cmd isEqualToString:@"35"]) {
        //读取低电量百分比提醒功能和报警阈值
        operationID = mk_bxs_taskReadADVChannelOperation;
        NSString *channel = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"channel":channel
        };
    }else if ([cmd isEqualToString:@"36"]) {
        //读取AOA CTE 广播帧状态
        operationID = mk_bxs_taskReadDirectionFindingStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"37"]) {
        //读取可连接状态
        operationID = mk_bxs_taskReadConnectableOperation;
        BOOL connectable = [content isEqualToString:@"01"];
        resultDic = @{
            @"connectable":@(connectable)
        };
    }else if ([cmd isEqualToString:@"3c"]) {
        //读取Tag ID自动填充状态
        operationID = mk_bxs_taskTagIDAutofillStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"3e"]) {
        //读取系统运行时间
        operationID = mk_bxs_taskDeviceRuntimeOperation;
        NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"time":time,
        };
    }else if ([cmd isEqualToString:@"3f"]) {
        //读取设备当前UTC时间戳
        operationID = mk_bxs_taskReadDeviceUTCTimeOperation;
        NSString *timestamp = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"timestamp":timestamp,
        };
    }else if ([cmd isEqualToString:@"40"]) {
        //读取温湿度数据存储开关状态
        operationID = mk_bxs_taskReadTHDataStoreStatusOperation;
        BOOL isOn = [[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"interval":interval
        };
    }else if ([cmd isEqualToString:@"41"]) {
        //读取温湿度采样率
        operationID = mk_bxs_taskReadTHSamplingRateOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"samplingRate":count,
        };
    }else if ([cmd isEqualToString:@"43"]) {
        //读取温湿度历史数据总条数
        operationID = mk_bxs_taskReadHTRecordTotalNumbersOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"count":count,
        };
    }else if ([cmd isEqualToString:@"68"]) {
        //读取霍尔传感器触发次数
        operationID = mk_bxs_taskReadHallTriggerCountOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"count":count,
        };
    }else if ([cmd isEqualToString:@"69"]) {
        //读取移动触发次数
        operationID = mk_bxs_taskReadMotionTriggerCountOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"count":count,
        };
    }else if ([cmd isEqualToString:@"6a"]) {
        //读取电池电压
        operationID = mk_bxs_taskReadBatteryVoltageOperation;
        NSString *voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"voltage":voltage,
        };
    }else if ([cmd isEqualToString:@"6b"]){
        //读取电池剩余电量百分比
        operationID = mk_bxs_taskReadBatteryPercentageOperation;
        NSString *percentage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
                      @"percentage":percentage,
                      };
    }else if ([cmd isEqualToString:@"4a"]){
        //读取传感器型号
        operationID = mk_bxs_taskReadSensorTypeOperation;
        NSString *axis = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *tempHumidity = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *lightSensor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        NSString *pir = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        NSString *tof = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
        resultDic = @{
                      @"axis":axis,
                      @"tempHumidity":tempHumidity,
                      @"lightSensor":lightSensor,
                      @"pir":pir,
                      @"tof":tof,
                      };
    }else if ([cmd isEqualToString:@"65"]) {
        //读取触发led提醒状态
        operationID = mk_bxs_taskReadTriggerLEDIndicatorStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"6c"]){
        //读取电量百分比/电压值
        operationID = mk_bxs_taskReadBatteryADVModeOperation;
        NSInteger mode = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
                      @"mode":[NSString stringWithFormat:@"%ld",(long)(mode - 1)],
                      };
    }else if ([cmd isEqualToString:@"24"]){
        //读取触发后通道广播参数
        operationID = mk_bxs_taskReadTriggeredSlotParamsOperation;
        NSString *slotIndex = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *advInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *advDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(10, 2)]];
        NSString *txPower = [MKBXSSDKDataAdopter fetchTxPowerValueString:[content substringWithRange:NSMakeRange(12, 2)]];
        resultDic = @{
            @"slotIndex":slotIndex,
            @"advInterval":advInterval,
            @"advDuration":advDuration,
            @"rssi":[NSString stringWithFormat:@"%@",rssi],
            @"txPower":txPower,
        };
    }else if ([cmd isEqualToString:@"2f"]){
        //读取设备类型
        operationID = mk_bxs_taskReadDeviceTypeOperation;
        NSString *chipType = [content substringWithRange:NSMakeRange(0, 2)];
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:[content substringWithRange:NSMakeRange(2, 2)]];
        BOOL threeAxis = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL tempHumidity = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL hall = [[binary substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        BOOL infrared = [[binary substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        BOOL sixAxis = [[binary substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        BOOL flash = [[binary substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
        BOOL pir = [[binary substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"];
        resultDic = @{
                      @"chipType":chipType,
                      @"threeAxis":@(threeAxis),
                      @"tempHumidity":@(tempHumidity),
                      @"hall":@(hall),
                      @"infrared":@(infrared),
                      @"sixAxis":@(sixAxis),
                      @"flash":@(flash),
                      @"pir":@(pir),
                      };
    }else if ([cmd isEqualToString:@"6c"]){
        //读取所有通道的广播类型
        operationID = mk_bxs_taskReadSlotAdvTypeOperation;
        NSMutableArray *typeList = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i ++) {
            NSString *type = [content substringWithRange:NSMakeRange(i * 2, 2)];
            [typeList addObject:type];
        }
        resultDic = @{
                      @"typeList":typeList,
                      };
    }else if ([cmd isEqualToString:@"6d"]) {
        //读取霍尔记录开关
        operationID = mk_bxs_taskReadHallDataStoreStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"01"]) {
        //
    }else if ([cmd isEqualToString:@"21"]) {
        //配置三轴传感器参数
        operationID = mk_bxs_taskConfigThreeAxisDataParamsOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //配置按键复位功能
        operationID = mk_bxs_taskConfigResetDeviceByButtonStatusOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //配置霍尔开关机状态
        operationID = mk_bxs_taskConfigHallSensorStatusOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //配置触发参数
        operationID = mk_bxs_taskConfigSlotTriggerParamsOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置触发前广播参数
        operationID = mk_bxs_taskConfigBeforeTriggerSlotDataOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //配置触发广播参数
        operationID = mk_bxs_taskConfigTriggerSlotDataOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //配置触发前通道广播内容
        operationID = mk_bxs_taskConfigSlotDataOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //配置广播信道开启
        operationID = mk_bxs_taskConfigADVChannelOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //配置AOA CTE 广播帧
        operationID = mk_bxs_taskConfigDirectionFindingStatusOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //配置可连接状态
        operationID = mk_bxs_taskConfigConnectableOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //配置Tag ID自动填充状态
        operationID = mk_bxs_taskConfigTagIDAutofillStatusOperation;
    }else if ([cmd isEqualToString:@"3f"]) {
        //配置设备UTC时间
        operationID = mk_bxs_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //配置温湿度存储参数
        operationID = mk_bxs_taskConfigTHDataStoreStatusOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //配置温湿度采样率
        operationID = mk_bxs_taskConfigTHSamplingRateOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //清除温湿度历史数据
        operationID = mk_bxs_taskDeleteBXPRecordHTDatasOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //远程提醒
        operationID = mk_bxs_taskConfigRemoteReminderLEDNotiParamsOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //配置远程蜂鸣器
        operationID = mk_bxs_taskConfigRemoteReminderBuzzerNotiParamsOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //配置触发led提醒状态
        operationID = mk_bxs_taskConfigTriggerLEDIndicatorStatusOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //清除霍尔传感器触发次数
        operationID = mk_bxs_taskClearHallTriggerCountOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //清除移动触发次数
        operationID = mk_bxs_taskClearMotionTriggerCountOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //配置电池容量
        operationID = mk_bxs_taskConfigBatteryResetOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //配置电量百分比/电压值
        operationID = mk_bxs_taskConfigBatteryADVModeOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置触发后通道广播参数
        operationID = mk_bxs_taskConfigTriggeredSlotParamOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //关机
        operationID = mk_bxs_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //恢复出厂设置
        operationID = mk_bxs_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //配置霍尔记录开关状态
        operationID = mk_bxs_taskConfigHallDataStoreStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //清除霍尔传感器历史数据
        operationID = mk_bxs_taskClearHallHistoryDataOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseHallSensorData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    
    if (![headerString isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if (![flag isEqualToString:@"00"]) {
        //读取
        return @{};
    }
    mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"90"]) {
        //读取霍尔传感器状态
        operationID = mk_bxs_taskReadMagnetStatusOperation;
        BOOL moved = [content isEqualToString:@"01"];
        resultDic = @{
            @"moved":@(moved)
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseMultiPacketData:(NSString *)content {
    
    NSString *flag = [content substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [content substringWithRange:NSMakeRange(4, 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(14, 2)];
//        if ([index integerValue] >= [totalNum integerValue]) {
//            return @{};
//        }
        mk_bxs_taskOperationID operationID = mk_bxs_defaultTaskOperationID;
        
        NSDictionary *resultDic= @{
            mk_bxs_totalNumKey:totalNum,
            mk_bxs_totalIndexKey:index,
            mk_bxs_contentKey:[content substringFromIndex:16],
        };
        if ([cmd isEqualToString:@"6e"]) {
            //读取霍尔传感器历史数据
            operationID = mk_bxs_taskReadHallHistoryDataOperation;
        }
        return [self dataParserGetDataSuccess:resultDic operationID:operationID];
    }
    return @{};
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_bxs_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
