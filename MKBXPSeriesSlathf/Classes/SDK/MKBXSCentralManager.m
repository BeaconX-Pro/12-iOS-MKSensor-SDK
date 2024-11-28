//
//  MKBXSCentralManager.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKBXSPeripheral.h"
#import "MKBXSOperation.h"
#import "MKBXSTaskAdopter.h"
#import "CBPeripheral+MKBXSAdd.h"
#import "MKBXSBaseBeacon.h"
#import "MKBXSSDKDataAdopter.h"

NSString *const mk_bxs_peripheralConnectStateChangedNotification = @"mk_bxs_peripheralConnectStateChangedNotification";
NSString *const mk_bxs_centralManagerStateChangedNotification = @"mk_bxs_centralManagerStateChangedNotification";

NSString *const mk_bxs_deviceDisconnectTypeNotification = @"mk_bxs_deviceDisconnectTypeNotification";
NSString *const mk_bxs_receiveThreeAxisDataNotification = @"mk_bxs_receiveThreeAxisDataNotification";
NSString *const mk_bxs_receiveHallSensorStatusChangedNotification = @"mk_bxs_receiveHallSensorStatusChangedNotification";
NSString *const mk_bxs_receiveHTDataNotification = @"mk_bxs_receiveHTDataNotification";
NSString *const mk_bxs_receiveRecordHTDataNotification = @"mk_bxs_receiveRecordHTDataNotification";

static MKBXSCentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKBXSCentralManager)
//
//@end
//
//@implementation NSObject (MKBXSCentralManager)
//
//+ (void)load{
//    [MKBXSCentralManager shared];
//}
//
//@end

@interface MKBXSCentralManager ()

@property (nonatomic, assign)mk_bxs_centralConnectStatus connectStatus;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, copy)void (^needPasswordBlock)(NSDictionary *result);

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL readingNeedPassword;

@property (nonatomic, copy)void (^characteristicWriteBlock)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);

@end

@implementation MKBXSCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKBXSCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXSCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"%@",advertisementData);
        NSArray *deviceList = [MKBXSBaseBeacon parseAdvData:advertisementData];
        for (NSInteger i = 0; i < deviceList.count; i ++) {
            MKBXSBaseBeacon *beaconModel = deviceList[i];
            beaconModel.identifier = peripheral.identifier.UUIDString;
            beaconModel.rssi = RSSI;
            beaconModel.peripheral = peripheral;
            beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
            beaconModel.connectEnable = [advertisementData[CBAdvertisementDataIsConnectable] boolValue];
        }
        if ([self.delegate respondsToSelector:@selector(mk_bxs_receiveBeacon:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate mk_bxs_receiveBeacon:deviceList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxs_startScan)]) {
        [self.delegate mk_bxs_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxs_stopScan)]) {
        [self.delegate mk_bxs_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    if (self.readingNeedPassword) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_bxs_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_bxs_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_bxs_centralConnectStatusDisconnect;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_bxs_centralConnectStatusConnectedFailed;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":[content substringWithRange:NSMakeRange(8, 2)]}];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA03"]]) {
        //三轴数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSNumber *xData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]];
        NSString *xDataString = [NSString stringWithFormat:@"%ld",(long)[xData integerValue]];
        NSNumber *yData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]];
        NSString *yDataString = [NSString stringWithFormat:@"%ld",(long)[yData integerValue]];
        NSNumber *zData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
        NSString *zDataString = [NSString stringWithFormat:@"%ld",(long)[zData integerValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_receiveThreeAxisDataNotification
                                                            object:nil
                                                          userInfo:@{@"xData":xDataString,
                                                                     @"yData":yDataString,
                                                                     @"zData":zDataString,
                                                                   }];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        BOOL moved = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_receiveHallSensorStatusChangedNotification
                                                            object:nil
                                                          userInfo:@{@"moved":@(moved)}];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
        //监听的温湿度数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSInteger tempTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]] integerValue];
        NSInteger tempHui = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(12, 4)];
        NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
        NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
        NSDictionary *htData = @{
                                 @"temperature":temperature,
                                 @"humidity":humidity,
                                 };
        MKBLEBase_main_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_receiveHTDataNotification
                                                                object:nil
                                                              userInfo:htData];
        });
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA09"]]) {
        //监听的符合采样条件已储存的温湿度数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSLog(@"%@",content);
        MKBLEBase_main_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_receiveRecordHTDataNotification
                                                                object:nil
                                                              userInfo:@{@"content":content}];
        });
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.characteristicWriteBlock) {
        self.characteristicWriteBlock(peripheral, characteristic, error);
    }
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_bxs_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_bxs_centralManagerStatusEnable
    : mk_bxs_centralManagerStatusUnable;
}

- (nullable CBCharacteristic *)otaContralCharacteristic {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil) {
        return nil;
    }
    return self.peripheral.bxs_otaControl;
}

- (nullable CBCharacteristic *)otaDataCharacteristic {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil) {
        return nil;
    }
    return self.peripheral.bxs_otaData;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                                       [CBUUID UUIDWithString:@"FEAB"],
                                                                       [CBUUID UUIDWithString:@"EA01"],
                                                                       [CBUUID UUIDWithString:@"EB01"]]
                                                             options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)readNeedPasswordWithPeripheral:(nonnull CBPeripheral *)peripheral
                              sucBlock:(void (^)(NSDictionary *result))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.readingNeedPassword) {
        [self operationFailedBlockWithMsg:@"Device is busy now" failedBlock:failedBlock];
        return;
    }
    self.readingNeedPassword = YES;
    self.needPasswordBlock = nil;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    __weak typeof(self) weakSelf = self;
    self.needPasswordBlock = ^(NSDictionary *result) {
        __strong typeof(self) sself = weakSelf;
        if (!MKValidDict(result)) {
            [sself clearAllParams];
            [self operationFailedBlockWithMsg:@"Read Error" failedBlock:failedBlock];
            return;
        }
        [sself clearAllParams];
        if (sucBlock) {
            MKBLEBase_main_safe(^{sucBlock(result);});
        }
    };
    MKBXSPeripheral *bxbPeripheral = [[MKBXSPeripheral alloc] initWithPeripheral:peripheral dfuMode:NO];
    [[MKBLEBaseCentralManager shared] connectDevice:bxbPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self confirmNeedPassword];
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password) || password.length > 16 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be no more than 16 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:NO successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:NO successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)dfuconnectPeripheral:(nonnull CBPeripheral *)peripheral
                    sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral dfu:YES successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bxs_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXSOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                    characteristic:characteristic
                                                                                       commandData:commandData
                                                                                      successBlock:successBlock
                                                                                      failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_bxs_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXSOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                        characteristic:characteristic
                                                                                          successBlock:successBlock
                                                                                          failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addCharacteristicWriteBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block {
    self.characteristicWriteBlock = nil;
    self.characteristicWriteBlock = block;
}

- (BOOL)notifyThreeAxisData:(BOOL)notify {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxs_threeSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxs_threeSensor];
    return YES;
}

- (BOOL)notifyHallSensorData:(BOOL)notify {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxs_hallSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxs_hallSensor];
    return YES;
}

- (BOOL)notifyTHSensorData:(BOOL)notify {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxs_temperatureHumidity == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxs_temperatureHumidity];
    return YES;
}

- (BOOL)notifyRecordTHData:(BOOL)notify {
    if (self.connectStatus != mk_bxs_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxs_recordTH == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxs_recordTH];
    return YES;
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
                      dfu:(BOOL)dfu
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKBXSPeripheral *bxbPeripheral = [[MKBXSPeripheral alloc] initWithPeripheral:peripheral dfuMode:dfu];
    [[MKBLEBaseCentralManager shared] connectDevice:bxbPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (MKValidStr(self.password) && self.password.length <= 16) {
            //需要密码登录
            [self sendPasswordToDevice];
            return;
        }
        //免密登录
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_bxs_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock(peripheral);
            }
        });
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)self.password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandData = [@"ea0151" stringByAppendingString:lenString];
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKBXSOperation *operation = [[MKBXSOperation alloc] initOperationWithID:mk_bxs_connectPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxs_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"success"] boolValue]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Incorrect password!" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_bxs_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxs_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)confirmNeedPassword {
    NSString *commandData = @"ea005300";
    __weak typeof(self) weakSelf = self;
    MKBXSOperation *operation = [[MKBXSOperation alloc] initOperationWithID:mk_bxs_taskReadNeedPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxs_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        //读取成功
        MKBLEBase_main_safe(^{
            if (sself.needPasswordBlock) {
                sself.needPasswordBlock(returnData);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKBXSOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_bxs_taskOperationID)operationID
                                                                  characteristic:(CBCharacteristic *)characteristic
                                                                     commandData:(NSString *)commandData
                                                                    successBlock:(void (^)(id returnData))successBlock
                                                                    failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXSOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXSOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKBXSOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_bxs_taskOperationID)operationID
                                                                      characteristic:(CBCharacteristic *)characteristic
                                                                        successBlock:(void (^)(id returnData))successBlock
                                                                        failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXSOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXSOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (void)clearAllParams {
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.characteristicWriteBlock = nil;
    if (!self.needPasswordBlock) {
        return;
    }
    //读取是否需要密码
    [self disconnect];
    self.needPasswordBlock = nil;
    self.readingNeedPassword = NO;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BXBCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
