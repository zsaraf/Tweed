//
//  UIImage+CinchUtils.m
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 7/19/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "UIImage+SeshUtils.h"
#import "UIImage+ImageEffects.h"

@implementation UIImage (SeshUtils)


+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)blurredImageWithRootView:(UIView *)rootView
{
    return [self blurredImageWithRootView:rootView tintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.1] radius:12.0 saturationDeltaFactor:1.2];
}

+ (UIImage *)blurredImageWithRootView:(UIView *)rootView tintColor:(UIColor *)tintColor radius:(CGFloat)radius saturationDeltaFactor:(CGFloat)saturationDeltaFactor
{
    UIGraphicsBeginImageContextWithOptions(rootView.bounds.size, NO, 0.0f);
    [rootView drawViewHierarchyInRect:rootView.bounds afterScreenUpdates:NO];
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    return [im applyBlurWithRadius:radius tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:nil];
}

@end
