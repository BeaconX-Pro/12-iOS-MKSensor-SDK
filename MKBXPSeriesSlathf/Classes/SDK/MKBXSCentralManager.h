//
//  MKBXSCentralManager.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBXSOperationID.h"
#import "MKBXSSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

//Notification of device connection status changes.
extern NSString *const mk_bxs_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_bxs_centralManagerStateChangedNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.The device reset ,it returns 0x03.Power Off the device ,it returns 0x04.
 */
extern NSString *const mk_bxs_deviceDisconnectTypeNotification;

extern NSString *const mk_bxs_receiveThreeAxisDataNotification;

extern NSString *const mk_bxs_receiveHallSensorStatusChangedNotification;

extern NSString *const mk_bxs_receiveHTDataNotification;

extern NSString *const mk_bxs_receiveRecordHTDataNotification;

@class CBCentralManager,CBPeripheral;

@interface MKBXSCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_bxs_centralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_bxs_centralConnectStatus connectStatus;

+ (MKBXSCentralManager *)shared;

/// Destroy the MKBXSCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKBXSCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_bxs_centralManagerStatus )centralStatus;

- (nullable CBCharacteristic *)otaContralCharacteristic;

- (nullable CBCharacteristic *)otaDataCharacteristic;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Read whether a connected device requires a password.
/*
 @{
 @"state":@"00",            //@"00":Password-free connection   @"01":password connection
 }
 */
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)readNeedPasswordWithPeripheral:(nonnull CBPeripheral *)peripheral
                              sucBlock:(void (^)(NSDictionary *result))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param password Device connection password.No more than 16 characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Dfu connect device function.
/// @param peripheral peripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)dfuconnectPeripheral:(nonnull CBPeripheral *)peripheral
                    sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_bxs_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_bxs_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

/// DFU
/// @param block Callback
- (void)addCharacteristicWriteBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block;

/// Monitor three-axis accelerometer data.
/// @param notify notify
- (BOOL)notifyThreeAxisData:(BOOL)notify;

/// Monitor hall sensor data.
/// @param notify notify
- (BOOL)notifyHallSensorData:(BOOL)notify;

/// Monitor temperature & humidity sensor data.
/// @param notify notify
- (BOOL)notifyTHSensorData:(BOOL)notify;

/**
 Whether to monitor the stored temperature and humidity

 @param notify BOOL
 @return result
 */
- (BOOL)notifyRecordTHData:(BOOL)notify;

@end

NS_ASSUME_NONNULL_END
