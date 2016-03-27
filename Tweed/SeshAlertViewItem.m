//
//  SeshAlertViewItem.m
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshAlertViewItem.h"

@implementation SeshAlertViewItem

+ (instancetype)alertViewViewButtonItemWithTitle:(NSString *)title
                                 backgroundColor:(UIColor *)backgroundColor
                         selectedBackgroundColor:(UIColor *)selectedBackgroundColor

{
    SeshAlertViewItem *item = [[SeshAlertViewItem alloc] init];
    item.title = title;
    item.backgroundColor = backgroundColor;
    item.selectedBackgroundColor = selectedBackgroundColor;
    return item;
}

@end
