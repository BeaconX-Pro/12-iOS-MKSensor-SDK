//
//  MKBXSTempSensorModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/29.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTempSensorModel : NSObject

@property (nonatomic, copy)NSString *samplingInterval;

@property (nonatomic, copy)NSString *deviceTime;

@property (nonatomic, assign)BOOL dataStore;

@property (nonatomic, copy)NSString *interval;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
