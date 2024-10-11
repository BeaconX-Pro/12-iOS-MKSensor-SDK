//
//  MKBXSFilterTempHistoryHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/23.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSFilterTempHistoryHeaderViewDelegate <NSObject>

- (void)bxs_filterHTHistoryHeaderView_switchButtonPressed:(BOOL)selected;

- (void)bxs_filterHTHistoryHeaderView_exportButtonPressed;

@end

@interface MKBXSFilterTempHistoryHeaderView : UIView

@property (nonatomic, weak)id <MKBXSFilterTempHistoryHeaderViewDelegate>delegate;

- (void)updateSumRecord:(NSString *)record;

@end

NS_ASSUME_NONNULL_END
