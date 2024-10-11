//
//  MKBXSScanFilterView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSScanFilterView : UIView

/// 加载扫描过滤页面
/// @param name 过滤的名字
/// @param tagID    过滤的tagID
/// @param rssi 过滤的rssi
/// @param searchBlock 回调
+ (void)showSearchName:(NSString *)name
                 tagID:(NSString *)tagID
                  rssi:(NSInteger)rssi
           searchBlock:(void (^)(NSString *searchName, NSString *searchTagID,NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
