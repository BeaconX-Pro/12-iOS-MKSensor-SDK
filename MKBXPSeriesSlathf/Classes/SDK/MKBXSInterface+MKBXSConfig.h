//
//  MKBXSInterface+MKBXSConfig.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSInterface.h"

#import "MKBXSSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSInterface (MKBXSConfig)

#pragma mark - AA01 自定义

/**
 Setting the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor

 @param dataRate sampling rate
 @param acceleration acceleration
 @param motionThreshold  1~255.
 mk_bxs_threeAxisDataAG0(±2g)----->Unit:3.91mg
 mk_bxs_threeAxisDataAG1(±4g)------>Unit:7.81mg
 mk_bxs_threeAxisDataAG2(±8g)------>Unit:15.63mg
 mk_bxs_threeAxisDataAG3(±16g)------>Unit:31.25mg
 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxs_configThreeAxisDataParams:(mk_bxs_threeAxisDataRate)dataRate
                         acceleration:(mk_bxs_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure ADV Channel.
/// @param channel channel
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configADVChannel:(mk_bxs_advChannel)channel
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// The broadcast parameters of the channel after triggering.
/// @param index Number of the channel.(0~2)
/// @param advInterval Adv Interval.1~100(Unit:100ms)
/// @param advDuration Adv Duration.1s~65535s.
/// @param rssi -127dBm~0dBm.
/// @param txPower Tx Power.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configTriggeredSlotParamWithIndex:(NSInteger)index
                                  advInterval:(NSInteger)advInterval
                                  advDuration:(NSInteger)advDuration
                                         rssi:(NSInteger)rssi
                                      txPower:(mk_bxs_txPower)txPower
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxs_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;









/// Hall sensor status data store.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configHallDataStoreStatus:(BOOL)isOn 
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear Hall sensor history data.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_clearHallHistoryDataWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;



#pragma mark - 新做
/// Reset Device by button.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configResetDeviceByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Hall Sensor Status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configHallSensorStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Close Slot Trigger.
/// @param index Number of the channel.(0~2)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_closeSlotTriggerWithIndex:(NSInteger)index
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Temperature triggered parameters.
/// @param slotIndex 0~2.Number of the channel.
/// @param event 0:Temperature is more than or equal to the threshold.  1:Temperature is less than the threshold.
/// @param temperature -40℃~150℃.
/// @param lockedADV Lock Event Occurs ADV Duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configTemperatureTriggerParams:(NSInteger)slotIndex
                              triggerEvent:(NSInteger)event
                               temperature:(NSInteger)temperature
                                 lockedADV:(BOOL)lockedADV
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Humidity triggered parameters.
/// @param slotIndex 0~2.Number of the channel.
/// @param event 0:Humidity is more than or equal to the threshold.  1:Humidity is less than the threshold.
/// @param humidity 0 %RH~100 %RH.
/// @param lockedADV Lock Event Occurs ADV Duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configHumidityTriggerParams:(NSInteger)slotIndex
                           triggerEvent:(NSInteger)event
                               humidity:(NSInteger)humidity
                              lockedADV:(BOOL)lockedADV
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion Detection triggered parameters.
/// @param slotIndex 0~2.Number of the channel.
/// @param event 0:Device start moving. 1:Device remains stationary.
/// @param period 1s~65535s.
/// @param lockedADV Lock Event Occurs ADV Duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configMotionDetectionTriggerParams:(NSInteger)slotIndex
                                  triggerEvent:(NSInteger)event
                                        period:(NSInteger)period
                                     lockedADV:(BOOL)lockedADV
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Hall triggered parameters.
/// @param slotIndex 0~2.Number of the channel.
/// @param event 0:Door open. 1:Door close.
/// @param lockedADV Lock Event Occurs ADV Duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configHallTriggerParams:(NSInteger)slotIndex
                       triggerEvent:(NSInteger)event
                          lockedADV:(BOOL)lockedADV
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as NO DATA.
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotNoDataWithIndex:(NSInteger)index
                                 type:(mk_bxs_slotDataType)type
                            advParams:(id <mk_bxs_slotAdvContentParam>)param
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as UID.
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param namespaceID 10 Bytes.
/// @param instanceID 6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotUIDWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                       namespaceID:(NSString *)namespaceID
                        instanceID:(NSString *)instanceID
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as URL
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param urlType urlType
/// @param urlContent 1~17 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotURLWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                           urlType:(mk_bxs_urlHeaderType)urlType
                        urlContent:(NSString *)urlContent
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as TLM.
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTLMWithIndex:(NSInteger)index
                              type:(mk_bxs_slotDataType)type
                         advParams:(id <mk_bxs_slotAdvContentParam>)param
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as iBeacon.
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param major 0~65535
/// @param minor 0~65535
/// @param uuid 16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotBeaconWithIndex:(NSInteger)index
                                 type:(mk_bxs_slotDataType)type
                            advParams:(id <mk_bxs_slotAdvContentParam>)param
                                major:(NSInteger)major
                                minor:(NSInteger)minor
                                 uuid:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as Sensor Info.
/// @param index Number of the channel.(0~2)
/// @param type mk_bxs_slotDataType_beforeTriggerData:Pre-trigger broadcasting and related advertising parameters   mk_bxs_slotDataType_triggerData:Advertising parameters of trigger event occurs  mk_bxs_slotDataType_slotData:channel broadcast content.
/// @param advParams ADV Params
/// @param deviceName 1~20 ascii characters.
/// @param tagID 1~6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotSensorInfoWithIndex:(NSInteger)index
                                     type:(mk_bxs_slotDataType)type
                                advParams:(id <mk_bxs_slotAdvContentParam>)param
                               deviceName:(NSString *)deviceName
                                    tagID:(NSString *)tagID
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel triggered data as NO DATA.
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredNoDataWithIndex:(NSInteger)index
                                     advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel triggered data as UID.
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param namespaceID 10 Bytes.
/// @param instanceID 6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredUIDWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                namespaceID:(NSString *)namespaceID
                                 instanceID:(NSString *)instanceID
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel triggered data as URL
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param urlType urlType
/// @param urlContent 1~17 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredURLWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                    urlType:(mk_bxs_urlHeaderType)urlType
                                 urlContent:(NSString *)urlContent
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channe triggeredl data as TLM.
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredTLMWithIndex:(NSInteger)index
                                  advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel triggered data as iBeacon.
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param major 0~65535
/// @param minor 0~65535
/// @param uuid 16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredBeaconWithIndex:(NSInteger)index
                                     advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                         major:(NSInteger)major
                                         minor:(NSInteger)minor
                                          uuid:(NSString *)uuid
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel triggered data as Sensor Info.
/// @param index Number of the channel.(0~2)
/// @param advParams ADV Params
/// @param deviceName 1~20 ascii characters.
/// @param tagID 1~6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configSlotTriggeredSensorInfoWithIndex:(NSInteger)index
                                         advParams:(id <mk_bxs_slotTriggeredAdvContentParam>)param
                                        deviceName:(NSString *)deviceName
                                             tagID:(NSString *)tagID
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Direction finding(CTE).
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configDirectionFindingStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable state of the device.
/// @param connectable connectable
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Delete the temperature and humidity data stored in the device.
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxs_deleteBXPRecordHTDatasWithSucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote LED reminder parameters.
/// @param blinkingTime Blinking time.1 ~ 600(Unit:100ms)
/// @param blinkingInterval Blinking interval.1 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configRemoteReminderLEDNotiParams:(NSInteger)blinkingTime
                             blinkingInterval:(NSInteger)blinkingInterval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Tag ID Autofill status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configTagIDAutofillStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configDeviceTime:(unsigned long)timestamp
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// T&H Data Store Params.
/// @param isOn isOn
/// @param interval Temperature and humidity data storage time interval.0s~65535s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configTHDataStoreStatus:(BOOL)isOn
                           interval:(NSInteger)interval
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the temperature and humidity sampling rate

 @param rate Sampling rate, the unit is S, that is, how many seconds to sample the temperature and humidity data, 1s~65535s
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxs_configTHSamplingRate:(NSInteger)rate
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Buzzer reminder parameters.
/// @param ringTime Ringing time.1 ~ 600(Unit:100ms)
/// @param ringInterval Ringing interval.1 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configRemoteReminderBuzzerNotiParams:(NSInteger)ringTime
                                blinkingInterval:(NSInteger)ringInterval
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Remote Buzzer reminder ringing frequency.
/// @param frequency frequency.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configRemoteReminderBuzzerFrequency:(mk_bxs_buzzerRingingFrequencyType)frequency
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Battery Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_batteryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the trigger LED indicator light reminder status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear the count of the Magnetic trigger.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_clearHallTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear the count of the motion trigger.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_clearMotionTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Battery ADV Mode.
/// @param mode mode
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configBatteryADVMode:(mk_bxs_batteryADVMode)mode
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - AA07 密码相关

/// Configure the current connection password of the device.
/// @param password 1~16 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxs_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
