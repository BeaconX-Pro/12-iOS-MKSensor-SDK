//
//  MKBXSScanController.h
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/17.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_bxs_scanType) {
    mk_bxs_scanType_common,
    mk_bxs_scanType_temperatureAndHumidity,
    mk_bxs_scanType_temperature,
};

@interface MKBXSScanController : MKBaseViewController

@property (nonatomic, assign)mk_bxs_scanType scanType;

@end

NS_ASSUME_NONNULL_END
