//
//  MKBXSSettingModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2023/6/2.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSettingModel : NSObject

/// 霍尔开关机状态
@property (nonatomic, assign)BOOL hallStatus;

/// 是否支持三轴
@property (nonatomic, assign)BOOL supportThreeAcc;

/// 是否支持温湿度
@property (nonatomic, assign)BOOL supportTH;

/// 0:Voltage   1:Percentage
@property (nonatomic, assign)NSInteger batteryAdvMode;

/// 0:CH37&38&39    1:CH37  2:CH38  3:CH39
@property (nonatomic, assign)NSInteger advChannel;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
