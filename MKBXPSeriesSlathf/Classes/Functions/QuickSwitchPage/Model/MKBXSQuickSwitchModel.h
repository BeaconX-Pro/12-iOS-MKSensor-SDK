//
//  MKBXSQuickSwitchModel.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSQuickSwitchModel : NSObject

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)BOOL trigger;

@property (nonatomic, assign)BOOL passwordVerification;

@property (nonatomic, assign)BOOL autoFill;

@property (nonatomic, assign)BOOL resetByButton;

@property (nonatomic, assign)BOOL turnOffByButton;

@property (nonatomic, assign)BOOL direction;


- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
