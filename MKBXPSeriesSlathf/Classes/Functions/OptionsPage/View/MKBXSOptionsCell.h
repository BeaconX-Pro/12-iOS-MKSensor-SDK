//
//  MKBXSOptionsCell.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSOptionsCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *noteMsg;

@property (nonatomic, copy)NSString *iconName;

@end

@interface MKBXSOptionsCell : MKBaseCell

@property (nonatomic, strong)MKBXSOptionsCellModel *dataModel;

+ (MKBXSOptionsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
