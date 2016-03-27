//
//  SeshAlertViewItem.h
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeshAlertViewItem : NSObject

+ (instancetype)alertViewViewButtonItemWithTitle:(NSString *)title
                                 backgroundColor:(UIColor *)backgroundColor
                         selectedBackgroundColor:(UIColor *)selectedBackgroundColor;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@end
