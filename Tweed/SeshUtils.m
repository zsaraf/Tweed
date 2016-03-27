//
//  SeshUtils.m
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 8/12/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshUtils.h"

@implementation SeshUtils

+ (CGFloat)scaledFontSizeForFontSize:(CGFloat)fontSize
{
    if ([[UIScreen mainScreen] bounds].size.height > 568) {
        return fontSize * 1.2;
    }
    return fontSize;
}

@end
