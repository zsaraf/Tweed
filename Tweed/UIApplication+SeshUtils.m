//
//  UIApplication+SeshUtils.m
//  CinchApp
//
//  Created by Raymond kennedy on 1/5/15.
//  Copyright (c) 2015 Zachary Waleed Saraf. All rights reserved.
//

#import "UIApplication+SeshUtils.h"

@implementation UIApplication (SeshUtils)

- (UIViewController *)blurViewController {
    return [self topViewController:self.keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil ||
        [rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        UIViewController *vc = [self topViewController:lastViewController];
        if (vc == lastViewController) {
            return rootViewController.presentedViewController;
        } else {
            return lastViewController;
        }
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

@end
