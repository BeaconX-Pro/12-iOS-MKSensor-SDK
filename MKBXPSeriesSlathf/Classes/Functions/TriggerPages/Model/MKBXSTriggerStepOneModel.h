//
//  MKBXSTriggerStepOneModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTriggerTypeModel : NSObject

/// 0:Temperature 1:Humidity 2:Motion detection 3:Door magnetic detection
@property (nonatomic, assign)NSInteger triggerType;

/// 当前选中的triggerType，根据传感器类型和霍尔、按键开关机状态不同，该值意义也不同
@property (nonatomic, assign)NSInteger triggerIndex;

@property (nonatomic, copy)NSString *triggerMsg;

@end

@interface MKBXSTriggerStepOneModel : NSObject

@property (nonatomic, assign)BOOL trigger;

/// 当前选中的triggerIndex，根据传感器类型和霍尔、按键开关机状态不同，该值意义也不同
@property (nonatomic, assign)NSInteger triggerIndex;

//温度触发参数

/// 0:Above 1:Below
@property (nonatomic, assign)NSInteger tempEvent;

/// 触发值
@property (nonatomic, assign)NSInteger temperature;



//湿度触发参数

/// 0:Above 1:Below
@property (nonatomic, assign)NSInteger humidityEvent;

/// 触发值
@property (nonatomic, assign)NSInteger humidity;




//移动触发参数

/// 0:Device start moving 1:Device remains stationary
@property (nonatomic, assign)NSInteger motionEvent;

/// 触发值
@property (nonatomic, copy)NSString *motionVerificationPeriod;


//Hall触发
/// 0:Door open 1:Door close
@property (nonatomic, assign)NSInteger hallEvent;

@property (nonatomic, assign)BOOL lockedAdvIsOn;

- (instancetype)initWithSlotIndex:(NSInteger)index;

- (NSArray *)fetchTriggerTypeList;

/// 获取当前触发类型
/// 0:温度触发  1:湿度触发  2:移动触发  3:霍尔触发
- (NSInteger)fetchTriggerType;


- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
