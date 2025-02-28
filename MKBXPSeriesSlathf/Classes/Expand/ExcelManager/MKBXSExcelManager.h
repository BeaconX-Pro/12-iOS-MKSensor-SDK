//
//  MKBXSExcelManager.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2025/2/26.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSExcelManager : NSObject

+ (void)exportExcelWithTHDataList:(NSArray <NSDictionary *>*)list
                         sucBlock:(void(^)(void))sucBlock
                      failedBlock:(void(^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
