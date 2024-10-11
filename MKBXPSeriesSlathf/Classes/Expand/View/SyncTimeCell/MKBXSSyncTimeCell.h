//
//  MKBXSSyncTimeCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/24.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSyncTimeCellModel : NSObject

@property (nonatomic, copy)NSString *date;

@end

@protocol MKBXSSyncTimeCellDelegate <NSObject>

- (void)bxs_syncTimeCell_syncTimePressed;

@end

@interface MKBXSSyncTimeCell : MKBaseCell

@property (nonatomic, strong)MKBXSSyncTimeCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSyncTimeCellDelegate>delegate;

+ (MKBXSSyncTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
