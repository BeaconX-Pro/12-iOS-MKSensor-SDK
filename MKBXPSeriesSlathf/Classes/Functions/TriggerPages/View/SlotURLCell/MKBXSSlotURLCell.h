//
//  MKBXSSlotURLCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSSlotURLCellModel : NSObject

/// 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
@property (nonatomic, assign)NSInteger urlType;

@property (nonatomic, copy)NSString *urlContent;

@end

@protocol MKBXSSlotURLCellDelegate <NSObject>

/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxs_advContent_urlTypeChanged:(NSInteger)urlType;

- (void)bxs_advContent_urlContentChanged:(NSString *)content;

@end

@interface MKBXSSlotURLCell : MKBaseCell

@property (nonatomic, strong)MKBXSSlotURLCellModel *dataModel;

@property (nonatomic, weak)id <MKBXSSlotURLCellDelegate>delegate;

+ (MKBXSSlotURLCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
