//
//  UIWindow+Sesh.m
//  Sesh
//
//  Created by Zachary Saraf on 1/27/15.
//  Copyright (c) 2015 Zachary Waleed Saraf. All rights reserved.
//

#import "UIWindow+Sesh.h"

@implementation UIWindow (Sesh)

- (void)dismissViewControllers
{
    [self dismissViewController:self.rootViewController];
}

- (void)dismissViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        [self dismissViewController:lastViewController];
        return;
    }
    
    [rootViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)resignAllResponders
{
    [self resignFirstResponderOfViewRecursively:self.rootViewController];
}

- (void)resignFirstResponderOfViewRecursively:(UIViewController *)rootViewController
{
    [rootViewController.view endEditing:YES];

    if (rootViewController.presentedViewController) {
        [self resignFirstResponderOfViewRecursively:rootViewController.presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *lastVC = [(UINavigationController *)rootViewController viewControllers].lastObject;
        [self resignFirstResponderOfViewRecursively:lastVC];
    }
}

@end
