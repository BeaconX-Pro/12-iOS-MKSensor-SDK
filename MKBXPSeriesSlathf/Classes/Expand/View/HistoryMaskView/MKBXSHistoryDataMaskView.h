//
//  MKBXSHistoryDataMaskView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/9/25.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSHistoryDataMaskView : UIView

- (void)updateTotalNumber:(NSString *)totalNumber;

- (void)updateCurrentNumber:(NSString *)number;

- (void)showWithView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
