//
//  UIImage+CinchUtils.h
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 7/19/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SeshUtils)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)blurredImageWithRootView:(UIView *)rootView;
+ (UIImage *)blurredImageWithRootView:(UIView *)rootView tintColor:(UIColor *)tintColor radius:(CGFloat)radius saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

@end
