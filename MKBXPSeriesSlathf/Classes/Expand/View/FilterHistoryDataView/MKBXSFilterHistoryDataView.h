//
//  MKBXSFilterHistoryDataView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/22.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSFilterHistoryDataViewDelegate <NSObject>

- (void)bxs_dateSelectedView_startPressed:(NSString *)startDate endDate:(NSString *)endDate;

@end

@interface MKBXSFilterHistoryDataView : UIView

@property (nonatomic, weak)id <MKBXSFilterHistoryDataViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
