
static NSString *const kBXTOtaServerUUIDString = @"1d14d6ee-fd63-4fa1-bfa4-8f47b42119f0";
static NSString *const kBXTOtaControlUUIDString = @"f7bf3564-fb6d-4e53-88a4-5e37e0326063";
static NSString *const kBXTOtaDataUUIDString = @"984227f3-34fc-4045-a5d0-2c581f81a153";

#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKMTCentralManager

typedef NS_ENUM(NSInteger, mk_bxs_centralConnectStatus) {
    mk_bxs_centralConnectStatusUnknow,                                           //未知状态
    mk_bxs_centralConnectStatusConnecting,                                       //正在连接
    mk_bxs_centralConnectStatusConnected,                                        //连接成功
    mk_bxs_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bxs_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_bxs_centralManagerStatus) {
    mk_bxs_centralManagerStatusUnable,                           //不可用
    mk_bxs_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bxs_threeAxisDataRate) {
    mk_bxs_threeAxisDataRate1hz,           //1hz
    mk_bxs_threeAxisDataRate10hz,          //10hz
    mk_bxs_threeAxisDataRate25hz,          //25hz
    mk_bxs_threeAxisDataRate50hz,          //50hz
    mk_bxs_threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_bxs_threeAxisDataAG) {
    mk_bxs_threeAxisDataAG0,               //±2g
    mk_bxs_threeAxisDataAG1,               //±4g
    mk_bxs_threeAxisDataAG2,               //±8g
    mk_bxs_threeAxisDataAG3                //±16g
};

typedef NS_ENUM(NSInteger, mk_bxs_txPower) {
    mk_bxs_txPowerNeg20dBm,   //RadioTxPower:-20dBm
    mk_bxs_txPowerNeg16dBm,   //-16dBm
    mk_bxs_txPowerNeg12dBm,   //-12dBm
    mk_bxs_txPowerNeg8dBm,    //-8dBm
    mk_bxs_txPowerNeg4dBm,    //-4dBm
    mk_bxs_txPower0dBm,       //0dBm
    mk_bxs_txPower3dBm,       //3dBm
    mk_bxs_txPower4dBm,       //4dBm
    mk_bxs_txPower6dBm,       //6dBm
};

typedef NS_ENUM(NSInteger, mk_bxs_urlHeaderType) {
    mk_bxs_urlHeaderType1,             //http://www.
    mk_bxs_urlHeaderType2,             //https://www.
    mk_bxs_urlHeaderType3,             //http://
    mk_bxs_urlHeaderType4,             //https://
};


typedef NS_ENUM(NSInteger, mk_bxs_triggerType) {
    mk_bxs_triggerType_null,
    mk_bxs_triggerType_temperature,
    mk_bxs_triggerType_humidity,
    mk_bxs_triggerType_motionDetection,
    mk_bxs_triggerType_hall
};

typedef NS_ENUM(NSInteger, mk_bxs_batteryADVMode) {
    mk_bxs_batteryADVMode_voltage,
    mk_bxs_batteryADVMode_percentage,
};

typedef NS_ENUM(NSInteger, mk_bxs_advChannel) {
    mk_bxs_advChannel_ch37,
    mk_bxs_advChannel_ch38,
    mk_bxs_advChannel_ch37Andch38,
    mk_bxs_advChannel_ch39,
    mk_bxs_advChannel_ch37Andch39,
    mk_bxs_advChannel_ch38Andch39,
    mk_bxs_advChannel_all,  //CH37&38&39
};

typedef NS_ENUM(NSInteger, mk_bxs_slotAdvType) {
    mk_bxs_slotAdvType_tlm,
    mk_bxs_slotAdvType_uid,
    mk_bxs_slotAdvType_url,
    mk_bxs_slotAdvType_iBeacon,
    mk_bxs_slotAdvType_noData,
};

typedef NS_ENUM(NSInteger, mk_bxs_slotDataType) {
    mk_bxs_slotDataType_beforeTriggerData,
    mk_bxs_slotDataType_slotData,
};

@protocol mk_bxs_slotAdvContentParam <NSObject>

/// 20ms~65535ms
@property (nonatomic, assign)NSInteger advInterval;

/// 1s~65535s
@property (nonatomic, assign)NSInteger advDuration;

/// 0s~65535s
@property (nonatomic, assign)NSInteger standbyDuration;

/// -100dBm~0dBm
@property (nonatomic, assign)NSInteger rssi;

/*
 0:-20dBm
 1:-16dBm
 2:-12dBm
 3:-8dBm
 4:-4dBm
 5:0dBm
 6:3dBm
 7:4dBm
 8:6dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@end

@protocol mk_bxs_slotTriggeredAdvContentParam <NSObject>

/// 20ms~65535ms
@property (nonatomic, assign)NSInteger advInterval;

/// 0s~65535s
@property (nonatomic, assign)NSInteger advDuration;

/// -100dBm~0dBm
@property (nonatomic, assign)NSInteger rssi;

/*
 0:-20dBm
 1:-16dBm
 2:-12dBm
 3:-8dBm
 4:-4dBm
 5:0dBm
 6:3dBm
 7:4dBm
 8:6dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@end

#pragma mark ****************************************Delegate************************************************

@class MKBXSBaseBeacon;
@protocol mk_bxs_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param beaconList device
- (void)mk_bxs_receiveBeacon:(NSArray <MKBXSBaseBeacon *>*)beaconList;

@optional

/// Starts scanning equipment.
- (void)mk_bxs_startScan;

/// Stops scanning equipment.
- (void)mk_bxs_stopScan;

@end
