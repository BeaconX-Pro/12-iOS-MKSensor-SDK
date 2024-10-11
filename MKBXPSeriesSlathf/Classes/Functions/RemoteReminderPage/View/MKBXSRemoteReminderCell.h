//
//  MKBXSRemoteReminderCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/27.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSRemoteReminderCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKBXSRemoteReminderCellDelegate <NSObject>

- (void)bxs_remindButtonPressed:(NSInteger)index;

@end

@interface MKBXSRemoteReminderCell : MKBaseCell

@property (nonatomic, strong)MKBXSRemoteReminderCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSRemoteReminderCellDelegate>delegate;

+ (MKBXSRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
