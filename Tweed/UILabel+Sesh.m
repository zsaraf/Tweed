//
//  UILabel+Sesh.m
//  CinchApp
//
//  Created by Zachary Saraf on 9/14/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "UILabel+Sesh.h"
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"

@implementation UILabel (Sesh)

+ (instancetype)seshLabelWithFontType:(kSeshLabelFont)fontType
                             fontSize:(CGFloat)fontSize
                                color:(UIColor *)fontColor
                                 text:(NSString *)text
{
    return [self seshLabelWithFontType:fontType fontSize:fontSize color:fontColor text:text textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)seshLabelWithFontType:(kSeshLabelFont)fontType
                             fontSize:(CGFloat)fontSize
                                color:(UIColor *)fontColor
                                 text:(NSString *)text
                        textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    if (fontType == kSeshLabelFontBold) {
        label.font = [UIFont mediumGothamWithSize:fontSize];
    } else if (fontType == kSeshLabelFontRegular) {
        label.font = [UIFont bookGothamWithSize:fontSize];
    } else if (fontType == kSeshLabelFontLight) {
        label.font = [UIFont lightGothamWithSize:fontSize];
    }

    label.text = text;
    label.textColor = fontColor ?: [UIColor seshDarkRed];
    label.textAlignment = textAlignment;
    return label;
}

@end
