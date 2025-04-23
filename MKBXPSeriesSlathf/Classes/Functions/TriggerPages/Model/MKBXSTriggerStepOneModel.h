//
//  MKBXSTriggerStepOneModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTriggerStepOneModel : NSObject

/// YES:打开了霍尔开关机   NO:关闭了霍尔开关机
@property (nonatomic, assign)BOOL hallStatus;

@property (nonatomic, assign)BOOL resetByButton;

@property (nonatomic, assign)BOOL trigger;

/// 0:Temperature 1:Humidity 2:Motion detection 3:Door magnetic detection
@property (nonatomic, assign)NSInteger triggerType;



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


- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
