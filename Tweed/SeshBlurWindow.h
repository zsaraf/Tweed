//
//  SeshBlurWindow.h
//  CinchApp
//
//  Created by Zachary Saraf on 12/21/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeshTopBarView.h"

@class SeshBlurWindow;

@protocol SeshBlurWindowViewControllerDelegate <NSObject>
@optional
- (void)blurWindowWillDismiss;
- (void)rootViewControllerTouched;

@end

typedef void (^ BlurWindowDismissalBlock)(SeshBlurWindow *window);

@protocol SeshBlurWindowDelegate <NSObject>

@optional

- (void)seshBlurWindow:(SeshBlurWindow *)window
willDismissWithSuccess:(BOOL)success;

- (void)seshBlurWindowDidDismiss:(SeshBlurWindow *)window;

@end

@interface SeshBlurWindow : UIWindow <SeshTopBarViewDelegate>

- (instancetype)initWithMainViewController:(UIViewController<SeshBlurWindowViewControllerDelegate> *)mainViewController
                                 pageTitle:(NSString *)pageTitle
                           showCloseButton:(BOOL)showCloseButton
                          showAcceptButton:(BOOL)showAcceptButton
                                fullScreen:(BOOL)fullScreen;

- (void)show;
- (void)dismiss;

- (void)dismissWithCompletion:(BlurWindowDismissalBlock)dismissalBlock;

@property (nonatomic, strong) UIViewController<SeshBlurWindowViewControllerDelegate> *mainViewController;
@property (nonatomic, weak) id<SeshBlurWindowDelegate> seshAnimationDelegate;
@property (nonatomic, strong) NSString *pageTitle;
@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, assign) BOOL showAcceptButton;
@property (nonatomic, strong) UIColor *tintColor;

@end
