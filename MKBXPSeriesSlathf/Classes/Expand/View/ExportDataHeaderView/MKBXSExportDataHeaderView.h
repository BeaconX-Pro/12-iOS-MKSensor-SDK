//
//  MKBXSExportDataHeaderView.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/19.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSExportDataHeaderViewDelegate <NSObject>

- (void)bxs_syncButtonPressed:(BOOL)selected;

- (void)bxs_switchButtonPressed:(BOOL)selected;

- (void)bxs_deleteButtonPressed;

- (void)bxs_exportButtonPressed;

@end

@interface MKBXSExportDataHeaderView : UIView

@property (nonatomic, weak)id <MKBXSExportDataHeaderViewDelegate>delegate;

- (void)resetAllStatus;

@end

NS_ASSUME_NONNULL_END
