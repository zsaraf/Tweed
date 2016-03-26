//
//  UIFont+Sesh.m
//  Sesh
//
//  Created by Zachary Saraf on 2/11/16.
//  Copyright © 2016 Zachary Waleed Saraf. All rights reserved.
//

#import "UIFont+Sesh.h"

@implementation UIFont (Sesh)

+ (UIFont *)lightGothamWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham-Light" size:size];
}

+ (UIFont *)bookGothamWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham-Book" size:size];
}

+ (UIFont *)mediumGothamWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham-Medium" size:size];
}

+ (UIFont *)seshSmallHeader
{
    return [self bookGothamWithSize:14];
}

@end
