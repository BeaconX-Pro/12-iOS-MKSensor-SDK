//
//  MKBXSInterface.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSInterface : NSObject

#pragma mark ***********************************Custom****************************************

/// Read the mac address of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor
 
 @{
 @"samplingRate":The 3-axis accelerometer sampling rate is 5 levels in total, 00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"gravityReference": The 3-axis accelerometer scale is 4 levels, which are 00--±2g；01--±4g；02--±8g；03--±16g
 @"motionThreshold":
 ±2g----->Unit:3.91mg
 ±4g----->Unit:7.81mg
 ±8g----->Unit:15.63mg
 ±16g----->Unit:31.25mg
 }

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxs_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxs_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/*
 @{
 @"connectable":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the Voltage of the device.
/*
 @{
 @"voltage":@"3330",        //mV
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
















/// Read the broadcast parameters of the channel after triggering.
/*
 @{
     @"slotIndex":@"1",         //Number of the channel.
     @"advInterval":@"10",      //Adv Interval.(Unit:100ms)
     @"advTotalDuration":@"10",      //Adv Total Duration.(Unit:s)
     @"rssi":@"-10",            //Rssi,dBm
     @"txPower":@"0dBm",           //Tx Power
 };
 */
/// @param index 0~2.Number of the channel.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readTriggeredSlotParamsWithIndex:(NSInteger)index
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;





/// Read device type.
/*
 @{
               @"chipType":@"23",       //EFR32BG22C112F352GM32-C
               @"threeAxis":@(threeAxis),   //Whether with three-axis sensor.
               @"tempHumidity":@(tempHumidity),//Whether with Temperature-Humidity sensor
               @"hall":@(hall),//   Whether with hall sensor
               @"infrared":@(infrared), //Whether with Infrared sensor
               @"sixAxis":@(sixAxis),   //Whether with six-axis sensor
               @"flash":@(flash),   ////Whether with flash
               @"pir":@(pir),   //Whether with Pir sensor
               }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;











/// Read the broadcast type of all channels.
/*
 @[@"00",@"10",@"20",@"50",@"70",@"80"],
 @"00":UID
 @"10":URL
 @"20":TLM
 @"50":iBeacon
 @"70":T&HInfo
 @"80":tag
 @"FF":No data
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readSlotAdvTypeWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Hall sensor status data store.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readHallDataStoreStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Hall sensor historical data.
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readHallHistoryDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;




#pragma mark - 新做的

/// Reset Device by button.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readResetDeviceByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Hall Sensor Status.
/*
 @{
 @"isOn":@(YES)    //YES:Turn on the Hall switch function.   NO:Turn off the Hall switch function
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readHallSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Slot Type.
/*
    @{
    @"slotList":@[@"00",@"10",@"ff"],   
 }
 @"00":UID
 @"10":URL
 @"20":TLM
 @"50":iBeacon
 @"70":T&HInfo
 @"80":tag
 @"FF":No data
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readSlotTypeWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Slot Trigger Data
/*
 //No trigger
 @{
     @"slotIndex":@"0",
     @"triggerType":@"00",
 };
 */
/// @param index Slot number,0~2
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readSlotTriggerDataWithIndex:(NSInteger)index
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Pre-trigger broadcasting and related advertising parameters.
/*
 @{
     @"slotIndex":@"1",         //Number of the channel.
     @"slotType":@"ff",
     @"advInterval":@"10",      //Adv Interval.(Unit:100ms)
     @"advDuration":@"10",      //Adv Duration.(Unit:s)
     @"standbyDuration":@"0",   //Standby Duration.(Unit:s)
     @"rssi":@"-10",            //Rssi,dBm
     @"txPower":@"0dBm",           //Tx Power
     @"advContent":@{}          //Broadcast content
 };
 //Broadcast content
 No Data:
 @{
     
 };
 
 UID:
 @{
     @"namespaceID":@"00112233445566778899",
     @"instanceID":@"112233445566"
 };
 
 URL:
 @{
     @"urlType":@"1",       //@"0":http://www.   @"1":https://www.  @"2":http://   @"3":https://
     @"urlContent":@"moko.com"
 };
 
 TLM:
 @{
     
 };
 
 iBeacon:
 @{
     @"major":@"123",
     @"minor":@"456",
     @"uuid":@"111111111111111111111111111111111"
 };
 
 Sensor Info:
 @{
     @"deviceName":@"MK Tag",
     @"tagID":@"0001"
 };
 */
/// @param index 0~5.Number of the channel.(Channels 0~2 are normal broadcast channels, and channels 3~5 are trigger frame broadcast channels.)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readBeforeTriggerSlotDataWithIndex:(NSInteger)index
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Advertising parameters of trigger event occurs.
/*
 @{
     @"slotIndex":@"1",         //Number of the channel.
     @"slotType":@"ff",
     @"advInterval":@"10",      //Adv Interval.(Unit:100ms)
     @"advDuration":@"10",      //Adv Duration.(Unit:s)
     @"standbyDuration":@"0",   //Standby Duration.(Unit:s)
     @"rssi":@"-10",            //Rssi,dBm
     @"txPower":@"0dBm",           //Tx Power
     @"advContent":@{}          //Broadcast content
 };
 //Broadcast content
 No Data:
 @{
     
 };
 
 UID:
 @{
     @"namespaceID":@"00112233445566778899",
     @"instanceID":@"112233445566"
 };
 
 URL:
 @{
     @"urlType":@"1",       //@"0":http://www.   @"1":https://www.  @"2":http://   @"3":https://
     @"urlContent":@"moko.com"
 };
 
 TLM:
 @{
     
 };
 
 iBeacon:
 @{
     @"major":@"123",
     @"minor":@"456",
     @"uuid":@"111111111111111111111111111111111"
 };
 
 Sensor Info:
 @{
     @"deviceName":@"MK Tag",
     @"tagID":@"0001"
 };
 */
/// @param index 0~5.Number of the channel.(Channels 0~2 are normal broadcast channels, and channels 3~5 are trigger frame broadcast channels.)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readTriggerSlotDataWithIndex:(NSInteger)index
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read channel broadcast content.
/*
 @{
     @"slotIndex":@"1",         //Number of the channel.
     @"slotType":@"ff",
     @"advInterval":@"10",      //Adv Interval.(Unit:100ms)
     @"advDuration":@"10",      //Adv Duration.(Unit:s)
     @"standbyDuration":@"0",   //Standby Duration.(Unit:s)
     @"rssi":@"-10",            //Rssi,dBm
     @"txPower":@"0dBm",           //Tx Power
     @"advContent":@{}          //Broadcast content
 };
 //Broadcast content
 No Data:
 @{
     
 };
 
 UID:
 @{
     @"namespaceID":@"00112233445566778899",
     @"instanceID":@"112233445566"
 };
 
 URL:
 @{
     @"urlType":@"1",       //@"0":http://www.   @"1":https://www.  @"2":http://   @"3":https://
     @"urlContent":@"moko.com"
 };
 
 TLM:
 @{
     
 };
 
 iBeacon:
 @{
     @"major":@"123",
     @"minor":@"456",
     @"uuid":@"111111111111111111111111111111111"
 };
 
 Sensor Info:
 @{
     @"deviceName":@"MK Tag",
     @"tagID":@"0001"
 };
 */
/// @param index 0~5.Number of the channel.(Channels 0~2 are normal broadcast channels, and channels 3~5 are trigger frame broadcast channels.)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readSlotDataWithIndex:(NSInteger)index
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read ADV Channel.
/*
    @{
    @"channel":@"1"    //    1:CH37  2:CH38 3:CH37&38 4:CH39    5:CH37&39   6:CH38&39   7:CH37&38&39
 }
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readADVChannelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Direction finding(CTE).
/*
 @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readDirectionFindingStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Tag ID Autofill status.
/*
 @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readTagIDAutofillStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Device's operating time.
/*
 @{
    @"time":@"11111" //Unit:s
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readDeviceRuntimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the UTC time of the device.
/*
 @{
    @"timestamp":@"1706148753"
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readDeviceUTCTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// T&H Data Store Params.
/*
 @{
 @"isOn":@(YES),    //Whether to store temperature and humidity data.
 @"interval":@"50", //Temperature and humidity data storage time interval,Unit:S
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readTHDataStoreParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read temperature and humidity sampling rate
 @{
    @"samplingRate":@"5",       //Unit:s
 }
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxs_readHTSamplingRateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read temperature and humidity recorded datas numbers.
 @{
    @"count":@"150",       //
 }
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxs_readHTRecordTotalNumbersWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read sensor type.
/*
    @{
    @"axis":@"0",  //@"0":No three-axis sensor    @"1":Lis2DH/Lis3DH @"2":STK8328
    @"tempHumidity":@"0",   //@"0":No temperature and humidity sensor   @"1":SHT30/SHT31    @"2":SHT40  @"3":STS40 @"4":SHT43
    @"lightSensor":@"0",    //@"0":No light sensor  @"1":SMD0805-20
    @"pir":@"0",            //@"0":No PIR sensor    @"1":BL612
    @"tof":@"0",            //@"0":No TOF sensor    @"1":VL53K3CXV0DH
 }
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readSensorTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Buzzer reminder ringing frequency.
/*
 @{
    @"frequency":@"0",      //@"0":4000Hz   @"1":4500Hz
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readRemoteReminderBuzzerFrequencyWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the trigger LED indicator light reminder status.
/*
 @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Magnetic trigger count.
/*
 @{
 @"count":@"100",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readHallTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion trigger count.
/*
 @{
 @"count":@"100",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readMotionTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read ADV Channel.
/*
    @{
    @"percentage":@"100"
 }
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readBatteryPercentageWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Battery ADV Mode.
/*
    @{
    @"mode":@"0"    //@"0":Voltage  @"1":Percentage
 }
 */
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_readBatteryADVModeWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;



#pragma mark - AA06 温湿度相关

/// Read Temperature Humidity Datas.
/*
    @{
    @"temperature":@"23.2", //℃
    @"humidity":@"1.0",     //%RH
 }
 */
/// - Parameters:
///   - sucBlock: success callback
///   - failedBlock: failed callback
+ (void)bxs_readTemperatureHumidityDataWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - AA07 密码相关
/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - AA08 霍尔传感器数据
/// Read Hall Sensor Status.
/*
 @{
 @"moved":@(YES)    //YES:Absent   NO:Present
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_readMagnetStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
