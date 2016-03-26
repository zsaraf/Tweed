//
//  UILabel+Sesh.h
//  CinchApp
//
//  Created by Zachary Saraf on 9/14/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kSeshLabelFont)
{
    kSeshLabelFontRegular,
    kSeshLabelFontBold,
    kSeshLabelFontLight,
};

@interface UILabel (Sesh)

/**
 Creates a label with font type, font size, color, and text.  If color is nil,
 it will use the seshDarkRed color from SeshViewUtils.
 */
+ (instancetype)seshLabelWithFontType:(kSeshLabelFont)fontType
                             fontSize:(CGFloat)fontSize
                                color:(UIColor *)fontColor
                                 text:(NSString *)text;

+ (instancetype)seshLabelWithFontType:(kSeshLabelFont)fontType
                             fontSize:(CGFloat)fontSize
                                color:(UIColor *)fontColor
                                 text:(NSString *)text
                        textAlignment:(NSTextAlignment)textAlignment;

@end
