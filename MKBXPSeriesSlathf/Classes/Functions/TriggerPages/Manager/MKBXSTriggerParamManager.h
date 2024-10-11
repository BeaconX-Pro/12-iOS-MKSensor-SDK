//
//  MKBXSTriggerParamManager.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXSTriggerStepOneModel.h"

#import "MKBXSTriggerStepTwoModel.h"

#import "MKBXSTriggerStepThreeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSTriggerParamManager : NSObject

@property (nonatomic, assign)NSInteger slotIndex;

@property (nonatomic, strong)MKBXSTriggerStepOneModel *stepOneModel;

@property (nonatomic, strong)MKBXSTriggerStepTwoModel *stepTwoModel;

@property (nonatomic, strong)MKBXSTriggerStepThreeModel *stepThreeModel;

+ (MKBXSTriggerParamManager *)shared;

+ (void)sharedDealloc;

- (NSString *)fetchStepThreeAlert;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
