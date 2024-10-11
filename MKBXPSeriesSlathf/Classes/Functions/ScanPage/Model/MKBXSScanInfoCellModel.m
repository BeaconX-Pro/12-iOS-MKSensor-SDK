//
//  MKBXSScanInfoCellModel.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/1/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSScanInfoCellModel.h"

@implementation MKBXSScanInfoCellModel

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
