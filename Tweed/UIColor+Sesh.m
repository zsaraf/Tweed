//
//  UIColor+Sesh.m
//  Sesh
//
//  Created by Zachary Saraf on 2/11/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

#import "UIColor+Sesh.h"

@implementation UIColor (Sesh)

+ (UIColor *)seshLightRed
{
    return [UIColor colorWithRed:0.96 green:0.82 blue:0.77 alpha:1];
}

+ (UIColor *)seshDarkRed
{
    return [UIColor colorWithRed:0.95 green:0.5 blue:0.44 alpha:1];
}

+ (UIColor *)seshDarkRedSelected
{
    return [UIColor colorWithRed:0.85 green:0.45 blue:0.40 alpha:1];
}

+ (UIColor *)seshGreen
{
    return [UIColor colorWithRed:0.35 green:0.95 blue:0.67 alpha:1];
}

+ (UIColor *)seshBackgroundColor
{
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
}

+ (UIColor *)seshLightButtonColor
{
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.96 alpha:1];
}

+ (UIColor *)seshLightPressedButtonColor
{
    return [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];

}

+ (UIColor *)seshDarkGray
{
    return [UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1];
}

+ (UIColor *)seshGray
{
    return [UIColor colorWithRed:0.73 green:0.74 blue:0.75 alpha:1];
}

+ (UIColor *)seshMidnightBlue
{
    return [UIColor colorWithRed:64/255. green:78/255. blue:92/255. alpha:1.0f];
}

+ (UIColor *)seshLightGray
{
    return [UIColor colorWithWhite:.5 alpha:1];
}

+ (UIColor *)seshExtraLightGray
{
    return [UIColor colorWithWhite:.7 alpha:1.0];
}

+ (UIColor *)seshErrorRed
{
    return [UIColor colorWithRed:0.94 green:0.24 blue:0.35 alpha:1];
}

+ (UIColor *)seshButtonNormalColor
{
    return [UIColor colorWithRed:.96 green:.50 blue:.43 alpha:1];
}

+ (UIColor *)seshButtonSelectedColor
{
    return [UIColor colorWithRed:.87 green:.45 blue:.39 alpha:1];
}

+ (UIColor *)seshTableViewCellSeparatorColor
{
    return [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
}

+ (UIColor *)seshAlertViewCancelColor
{
    return [UIColor colorWithRed:0.58 green:0.58 blue:0.6 alpha:1];
}

+ (UIColor *)seshAlertViewCancelSelectedColor
{
    return [UIColor colorWithRed:0.48 green:0.48 blue:0.5 alpha:1];
}

+ (UIColor *)colorWithChavatarImageName:(NSString *)chavatarImageName
{
    chavatarImageName = [chavatarImageName stringByReplacingOccurrencesOfString:@"chavatar_" withString:@""];
    if ([chavatarImageName isEqualToString:@"black"]) {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"blue"]) {
        return [UIColor colorWithRed:0 green:0.62 blue:0.8 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"deeppurple"]) {
        return [UIColor colorWithRed:0.78 green:0.49 blue:0.71 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"green"]) {
        return [UIColor colorWithRed:0.46 green:0.76 blue:0.35 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"orange"]) {
        return [self seshDarkRed];
    } else if ([chavatarImageName isEqualToString:@"purple"]) {
        return [UIColor colorWithRed:0.62 green:0.71 blue:0.87 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"red"]) {
        return [UIColor colorWithRed:0.94 green:0.24 blue:0.44 alpha:1];
    } else if ([chavatarImageName isEqualToString:@"yellow"]) {
        return [UIColor colorWithRed:0 green:0.97 blue:0.53 alpha:1];
    } else {
        return [self seshDarkRed];
    }
}

+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    const CGFloat* colors = CGColorGetComponents( color.CGColor );
    UIColor *newColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:alpha];
    return newColor;
}

@end
