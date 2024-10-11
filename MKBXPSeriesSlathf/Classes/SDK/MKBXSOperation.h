//
//  MKBXSOperation.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBXSOperationID.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSOperation : NSOperation<MKBLEBaseOperationProtocol>

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_bxs_taskOperationID)operationID
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError * _Nullable error, id _Nullable returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
