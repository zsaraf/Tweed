//
//  UIColor+Sesh.h
//  Sesh
//
//  Created by Zachary Saraf on 2/11/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Sesh)

// COLORS
+ (UIColor *)seshLightRed;
+ (UIColor *)seshDarkRed;
+ (UIColor *)seshDarkRedSelected;
+ (UIColor *)seshGreen;
+ (UIColor *)seshBackgroundColor;
+ (UIColor *)seshLightButtonColor;
+ (UIColor *)seshLightPressedButtonColor;
+ (UIColor *)seshDarkGray;
+ (UIColor *)seshGray;
+ (UIColor *)seshLightGray;
+ (UIColor *)seshExtraLightGray;
+ (UIColor *)seshButtonNormalColor;
+ (UIColor *)seshButtonSelectedColor;
+ (UIColor *)seshMidnightBlue;
+ (UIColor *)seshTableViewCellSeparatorColor;
+ (UIColor *)seshAlertViewCancelColor;
+ (UIColor *)seshAlertViewCancelSelectedColor;
+ (UIColor *)seshErrorRed;

+ (UIColor *)colorWithChavatarImageName:(NSString *)chavatarImageName;

+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

@end
