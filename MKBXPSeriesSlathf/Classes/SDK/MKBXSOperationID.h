
typedef NS_ENUM(NSInteger, mk_bxs_taskOperationID) {
    mk_bxs_defaultTaskOperationID,
    
#pragma mark - 密码相关
    
    
#pragma mark - 自定义读取
    mk_bxs_taskReadMacAddressOperation,         //读取mac地址
    mk_bxs_taskReadThreeAxisDataParamsOperation,    //读取三轴传感器参数
    mk_bxs_taskReadFirmwareOperation,           //读取固件版本
    mk_bxs_taskReadManufacturerOperation,       //读取厂商信息
    mk_bxs_taskReadProductDateOperation,        //读取生产日期
    mk_bxs_taskReadSoftwareOperation,           //读取软件版本
    mk_bxs_taskReadHardwareOperation,           //读取硬件类型
    mk_bxs_taskReadDeviceModelOperation,        //读取产品型号
    mk_bxs_taskReadConnectableOperation,        //读取可连接性
    
    
    
    
    
    
    
    mk_bxs_taskReadTriggeredSlotParamsOperation,    //读取触发后通道广播参数
    
    
    
    mk_bxs_taskReadDeviceTypeOperation,         //读取设备类型
    
    
    
    
    
    
    mk_bxs_taskReadSlotAdvTypeOperation,            //读取所有通道的广播类型
    
    mk_bxs_taskReadHallDataStoreStatusOperation,    //读取霍尔记录开关
    mk_bxs_taskReadHallHistoryDataOperation,        //读取霍尔传感器历史数据
    
    
    
    
    mk_bxs_taskReadResetDeviceByButtonStatusOperation,  //读取按键复位功能
    mk_bxs_taskReadHallSensorStatusOperation,           //读取霍尔开关机功能
    mk_bxs_taskReadSlotTypeOperation,               //读取广播通道类型
    mk_bxs_taskReadSlotTriggerDataOperation,        //读取通道触发类型
    mk_bxs_taskReadBeforeTriggerSlotDataOperation,  //读取触发前广播参数
    mk_bxs_taskReadTriggerSlotDataOperation,        //读取触发广播参数
    mk_bxs_taskReadSlotDataOperation,           //读取通道广播内容
    mk_bxs_taskReadADVChannelOperation,             //读取低电量百分比提醒功能和报警阈值
    mk_bxs_taskReadDirectionFindingStatusOperation,     //读取AOA CTE 广播帧状态
    mk_bxs_taskTagIDAutofillStatusOperation,        //读取Tag ID自动填充状态
    mk_bxs_taskDeviceRuntimeOperation,              //读取系统运行时间
    mk_bxs_taskReadDeviceUTCTimeOperation,          //读取设备的UTC时间
    mk_bxs_taskReadTHDataStoreStatusOperation,      //读取温湿度数据存储开关状态
    mk_bxs_taskReadTHSamplingRateOperation,         //读取温湿度采样率
    mk_bxs_taskReadHTRecordTotalNumbersOperation,   //读取温湿度历史数据总条数
    mk_bxs_taskReadSensorTypeOperation,             //读取传感器型号
    mk_bxs_taskReadTriggerLEDIndicatorStatusOperation,  //读取触发led提醒状态
    mk_bxs_taskReadHallTriggerCountOperation,       //读取霍尔传感器触发次数
    mk_bxs_taskReadMotionTriggerCountOperation,    //读取移动触发次数
    mk_bxs_taskReadBatteryVoltageOperation,     //读取电池电压
    mk_bxs_taskReadBatteryPercentageOperation,      //读取电池剩余电量百分比
    mk_bxs_taskReadBatteryADVModeOperation,         //读取电量百分比/电压值
    
  
#pragma mark - 温湿度
    mk_bxs_taskReadTemperatureHumidityDataOperation,    //读取温湿度实时数据
    
#pragma mark - 密码特征
    mk_bxs_taskReadNeedPasswordOperation,       //读取设备是否需要连接密码
    
#pragma mark - 霍尔传感器特征相关
    mk_bxs_taskReadMagnetStatusOperation,       //读取霍尔传感器状态
    
#pragma mark - 自定义协议配置
    
    mk_bxs_taskConfigThreeAxisDataParamsOperation,  //配置三轴传感器参数
    mk_bxs_taskConfigADVChannelOperation,           //配置广播信道开启
    
    
    
    
    
    
    
    
    
    mk_bxs_taskConfigTriggeredSlotParamOperation,   //配置触发后通道广播参数
    
    mk_bxs_taskPowerOffOperation,               //关机
    
    mk_bxs_taskFactoryResetOperation,           //恢复出厂设置
    
    mk_bxs_taskClearHallTriggerCountOperation,          //清除霍尔传感器触发次数
    
    
    
    
    
    
    
    mk_bxs_taskConfigHallDataStoreStatusOperation,      //配置霍尔记录开关状态
    mk_bxs_taskClearHallHistoryDataOperation,           //清除霍尔传感器历史数据
    
    
    
    mk_bxs_taskConfigResetDeviceByButtonStatusOperation,    //配置按键复位功能
    mk_bxs_taskConfigHallSensorStatusOperation,     //配置霍尔开关机状态
    mk_bxs_taskConfigSlotTriggerParamsOperation,    //配置触发参数
    mk_bxs_taskConfigBeforeTriggerSlotDataOperation,  //配置触发前广播参数
    mk_bxs_taskConfigTriggerSlotDataOperation,        //配置触发广播参数
    mk_bxs_taskConfigSlotDataOperation,             //配置触发前通道广播内容
    mk_bxs_taskConfigDirectionFindingStatusOperation,   //配置AOA CTE 广播帧
    mk_bxs_taskConfigConnectableOperation,      //配置可连接状态
    mk_bxs_taskConfigTagIDAutofillStatusOperation,      //配置Tag ID自动填充状态
    mk_bxs_taskConfigDeviceTimeOperation,               //配置设备UTC时间
    mk_bxs_taskConfigTHDataStoreStatusOperation,        //配置温湿度存储参数
    mk_bxs_taskConfigTHSamplingRateOperation,           //配置温湿度采样率
    mk_bxs_taskDeleteBXPRecordHTDatasOperation,         //清除温湿度历史数据
    mk_bxs_taskConfigRemoteReminderLEDNotiParamsOperation,  //配置远程控制LED
    mk_bxs_taskClearMotionTriggerCountOperation,        //清除移动触发次数
    mk_bxs_taskConfigRemoteReminderBuzzerNotiParamsOperation,   //配置远程蜂鸣器
    mk_bxs_taskConfigTriggerLEDIndicatorStatusOperation,    //配置触发led提醒状态
    mk_bxs_taskConfigBatteryResetOperation,             //配置电池容量
    mk_bxs_taskConfigBatteryADVModeOperation,           //配置电量百分比/电压值
    
 
#pragma mark - 密码相关
    mk_bxs_connectPasswordOperation,            //连接密码
    mk_bxs_taskConfigConnectPasswordOperation,  //修改密码
    mk_bxs_taskConfigPasswordVerificationOperation, //配置是否需要连接密码
};
