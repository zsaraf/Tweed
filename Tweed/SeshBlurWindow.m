//
//  SeshBlurWindow.m
//  CinchApp
//
//  Created by Zachary Saraf on 12/21/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshBlurWindow.h"
#import "UIImage+ImageEffects.h"
#import "SeshUtils.h"
#import "UIApplication+SeshUtils.h"
#import "UIWindow+Sesh.h"

static const CGFloat kTopBarSize = 70.0;

@interface SeshBlurWindow ()

@property (nonatomic, strong) SeshTopBarView *topBarView;
@property (nonatomic, weak) UIWindow *oldWindow;

@end

@implementation SeshBlurWindow {
    UIImageView *_blurView;
    UIView *_tintView;
    BOOL _fullScreen;
}

- (instancetype)initWithMainViewController:(UIViewController<SeshBlurWindowViewControllerDelegate> *)mainViewController
                                 pageTitle:(NSString *)pageTitle
                           showCloseButton:(BOOL)showCloseButton
                          showAcceptButton:(BOOL)showAcceptButton
                             fullScreen:(BOOL)fullScreen

{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _tintColor = [UIColor colorWithWhite:0 alpha:.8];
        _pageTitle = pageTitle;
        _showAcceptButton = showAcceptButton;
        _showCloseButton = showCloseButton;
        _mainViewController = mainViewController;
        _fullScreen = fullScreen;
        
        self.rootViewController = [[UIViewController alloc] init];
        self.rootViewController.view.backgroundColor = [UIColor clearColor];
        
        NSInteger index = 0;
        _oldWindow = [UIApplication sharedApplication].keyWindow;
        UIView *rootView = [[UIApplication sharedApplication] blurViewController].view;
        UIGraphicsBeginImageContextWithOptions(rootView.bounds.size, NO, 0.0f);
        [rootView drawViewHierarchyInRect:rootView.bounds afterScreenUpdates:YES];
        UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
        UIColor *tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.1];
        im = [im applyBlurWithRadius:12 tintColor:tintColor saturationDeltaFactor:1.2 maskImage:nil];
        
        UIGraphicsEndImageContext();
        _blurView = [[UIImageView alloc] initWithFrame:self.rootViewController.view.bounds];
        _blurView.image = im;
        _blurView.alpha = 0.0;
        [self.rootViewController.view insertSubview:_blurView atIndex:index++];
        
        _tintView = [[UIView alloc] initWithFrame:self.rootViewController.view.bounds];
        _tintView.backgroundColor = [UIColor clearColor];
        [self.rootViewController.view insertSubview:_tintView atIndex:index];
        
        if (fullScreen) {
            _mainViewController.view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

        } else {
            _mainViewController.view.frame = CGRectMake(0, kTopBarSize, self.bounds.size.width, self.bounds.size.height - kTopBarSize);
        }
        _mainViewController.view.alpha = 0.0;
        [self.rootViewController.view addSubview:_mainViewController.view];
        [self.rootViewController addChildViewController:_mainViewController];
    }
    return self;
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] resignAllResponders];

    [self makeKeyAndVisible];
    
    [UIView animateWithDuration:.4 animations:^{
        _tintView.backgroundColor = _tintColor;
        _blurView.alpha = 1.0;
        _mainViewController.view.alpha = 1.0;
        
        self.topBarView.alpha = 1.0;
    }];
}

- (SeshTopBarView *)topBarView
{
    if (!_topBarView) {
        _topBarView = [[SeshTopBarView alloc] initWithLeftButtonImage:(_showCloseButton) ? [UIImage imageNamed:@"x"] : nil
                                                             rightButtonImage:(_showAcceptButton) ? [UIImage imageNamed:@"check_green"] : nil
                                                                    titleText:(_pageTitle)];
        _topBarView.delegate = self;
        _topBarView.frame = CGRectMake(0, 20, self.rootViewController.view.bounds.size.width, kTopBarSize);
        _topBarView.alpha = 0.0;
        if (!_fullScreen) {
            [self.rootViewController.view addSubview:_topBarView];
        }
    }
    return _topBarView;
}

- (void)dismiss
{
    if ([self.mainViewController respondsToSelector:@selector(blurWindowWillDismiss)]) {
        [self.mainViewController blurWindowWillDismiss];
    }

    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(BlurWindowDismissalBlock)dismissalBlock
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:.3 animations:^{
        _tintView.backgroundColor = [UIColor clearColor];
        _blurView.alpha = 0.0;
        _topBarView.alpha = 0.0;
        _mainViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if ([UIApplication sharedApplication].keyWindow == self) {
            [_oldWindow makeKeyAndVisible];
        }
        if ([self.seshAnimationDelegate respondsToSelector:@selector(seshBlurWindowDidDismiss:)]) {
            [self.seshAnimationDelegate seshBlurWindowDidDismiss:self];
        }
        
        if (dismissalBlock) {
            dismissalBlock(self);
        }
    }];
}

- (void)setPageTitle:(NSString *)pageTitle
{
    _pageTitle = pageTitle;
    
    _topBarView.titleLabel.text = _pageTitle;
    [_topBarView setNeedsLayout];
}

- (void)setShowCloseButton:(BOOL)showCloseButton
{
    _showCloseButton = showCloseButton;
    
    [_topBarView.leftButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
}

- (void)setShowAcceptButton:(BOOL)showAcceptButton
{
    _showAcceptButton = showAcceptButton;
    
    [_topBarView.rightButton setImage:[UIImage imageNamed:@"check_green"] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.rootViewController.view];
    CGPoint viewPoint = [self.mainViewController.view convertPoint:locationPoint fromView:self.rootViewController.view];
    if (![self.mainViewController.view pointInside:viewPoint withEvent:event]) {
        if ([self.mainViewController respondsToSelector:@selector(rootViewControllerTouched)]) {
            [self.mainViewController rootViewControllerTouched];
        }
    }
}

#pragma mark - SeshTopBarViewDelegate methods

- (void)topBarViewDidTapLeftButtonImage:(SeshTopBarView *)topBarView
{
    if ([self.seshAnimationDelegate respondsToSelector:@selector(seshBlurWindow:willDismissWithSuccess:)]) {
        [self.seshAnimationDelegate seshBlurWindow:self willDismissWithSuccess:NO];
    }
    [self dismiss];
}

- (void)topBarViewDidTapRightButtonImage:(SeshTopBarView *)topBarView
{
    if ([self.seshAnimationDelegate respondsToSelector:@selector(seshBlurWindow:willDismissWithSuccess:)]) {
        [self.seshAnimationDelegate seshBlurWindow:self willDismissWithSuccess:YES];
    }
    [self dismiss];
}

@end
