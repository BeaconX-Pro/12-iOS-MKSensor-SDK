//
//  Target_BXS_Module.m
//  MKBXPSeriesSlathf_Example
//
//  Created by aa on 2024/2/1.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "Target_BXS_Module.h"

#import "MKBXSOptionsController.h"

@implementation Target_BXS_Module

- (UIViewController *)Action_BXS_Module_OptionsController:(NSDictionary *)params {
    MKBXSOptionsController *vc = [[MKBXSOptionsController alloc] init];
    return vc;
}

@end
