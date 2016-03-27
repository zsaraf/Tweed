//
//  SeshUtils.h
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 8/12/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

@interface SeshUtils : NSObject

+ (CGFloat)scaledFontSizeForFontSize:(CGFloat)fontSize;

@end
