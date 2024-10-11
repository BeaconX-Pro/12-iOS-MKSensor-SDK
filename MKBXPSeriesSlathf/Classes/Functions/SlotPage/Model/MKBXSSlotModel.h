//
//  MKBXSSlotModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotModel : NSObject

@property (nonatomic, copy)NSString *slot1;

@property (nonatomic, copy)NSString *slot2;

@property (nonatomic, copy)NSString *slot3;

@property (nonatomic, assign, readonly)BOOL slot0Trigger;

@property (nonatomic, assign, readonly)BOOL slot1Trigger;

@property (nonatomic, assign, readonly)BOOL slot2Trigger;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
