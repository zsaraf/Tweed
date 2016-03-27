//
//  SeshAlertView.m
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshAlertView.h"
#import "SeshAlertViewManager.h"
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"
#import "SeshAlertViewInternal.h"
#import "SeshConfirmationAnimationView.h"

@import pop;

#define DEFAULT_X_PROPORTION (.75)
#define DEFAULT_Y_PROPORTION (.5)

@interface SeshAlertView () <POPAnimationDelegate, SeshConfirmationViewDelegate>

@end

@implementation SeshAlertView {
    POPSpringAnimation *_dismissAnimation;
    
    UIImageView *_spinnerView;
    SeshConfirmationAnimationView *_confirmationView;
    
    BOOL _invalidated;
}

@synthesize internalDelegate = _internalDelegate;

- (instancetype)initFromWindow:(UIWindow *)oldWindow
                         title:(NSString *)title
                   description:(NSString *)description
                   buttonItems:(NSArray *)buttonItems
{
    _xProportion = DEFAULT_X_PROPORTION;
    _yProportion = DEFAULT_Y_PROPORTION;
    SeshAlertViewController *vc = [[SeshAlertViewController alloc] initWithTitle:title description:description buttonItems:buttonItems image:nil];
    vc.delegate = self;
    SeshAlertView *alertView =  [super initWithMainViewController:vc
                                                       pageTitle:@""
                                                 showCloseButton:NO
                                                showAcceptButton:NO
                                                       fullScreen:NO];
    alertView.tintColor = [UIColor colorWithWhite:.95 alpha:.7];
    return alertView;
}

- (instancetype)initSwiftWithTitle:(NSString *)title
                           message:(NSString *)message
                          delegate:(id)delegate
                 cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherButtonTitles:(NSArray *)otherButtonTitles
{
    
    _xProportion = DEFAULT_X_PROPORTION;
    _yProportion = DEFAULT_Y_PROPORTION;

    NSMutableArray *items = [NSMutableArray array];
    
    if (otherButtonTitles)
    {
        for (NSString *title in otherButtonTitles) {
            [items addObject:[SeshAlertViewItem alertViewViewButtonItemWithTitle:title backgroundColor:nil selectedBackgroundColor:nil]];
        }

    }

    
    if (cancelButtonTitle) {
        [items addObject:[SeshAlertViewItem alertViewViewButtonItemWithTitle:[cancelButtonTitle uppercaseString] backgroundColor:[UIColor seshAlertViewCancelColor] selectedBackgroundColor:[UIColor seshAlertViewCancelSelectedColor]]];
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    _alertViewDelegate = delegate;
    self = [self initFromWindow:keyWindow title:title description:message buttonItems:items];
    self.tintColor = [UIColor colorWithWhite:.95 alpha:.7];
    return self;
}

- (void)show
{
    [[SeshAlertViewManager sharedManager] scheduleAlertView:self];
}

- (void)showInternal
{
    self.mainViewController.view.bounds = CGRectMake(0, 0, self.bounds.size.width * _xProportion, self.bounds.size.height * _yProportion);
    self.mainViewController.view.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height + self.mainViewController.view.bounds.size.height);

    [super show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    });
}

- (void)dismiss
{
    NSAssert(0, @"Should not call dismiss on a SeshAlertView");
}


- (void)dismissWithCompletion:(BlurWindowDismissalBlock)dismissalBlock
{
    [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height + self.mainViewController.view.bounds.size.height)];
    
    [super dismissWithCompletion:^(SeshBlurWindow *window) {
        if (dismissalBlock) {
            dismissalBlock(window);
        }

        if ([_alertViewDelegate respondsToSelector:@selector(seshAlertView:didDismissWithIndex:)]) {
            [_alertViewDelegate seshAlertView:self didDismissWithIndex:-1];
        }
        if (self.dismissalBlock) {
            self.dismissalBlock(self, -1);
        }

        [_internalDelegate seshAlertView:self didDismissWithIndex:-1];
    }];
}

- (void)dismissWithIndex:(NSInteger)index
{
    [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height + self.mainViewController.view.bounds.size.height)];
    
    [super dismissWithCompletion:^(SeshBlurWindow *window) {
        if ([_alertViewDelegate respondsToSelector:@selector(seshAlertView:didDismissWithIndex:)]) {
            [_alertViewDelegate seshAlertView:self didDismissWithIndex:index];
        }

        if (self.dismissalBlock) {
            self.dismissalBlock(self, index);
        }

        [_internalDelegate seshAlertView:self didDismissWithIndex:index];
    }];
}

- (void)addDismissAnimationToPoint:(CGPoint)point
{
    _dismissAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    _dismissAnimation.toValue = [NSValue valueWithCGPoint:point];
    _dismissAnimation.springBounciness = 9.0;
    _dismissAnimation.springSpeed = 6.0;
    _dismissAnimation.delegate = self;
    [self.mainViewController.view pop_addAnimation:_dismissAnimation forKey:@"Translate"];
}

- (void)setInvalidatedWithTitle:(NSString *)title
                    description:(NSString *)description
                    buttonTitle:(NSString *)buttonTitle
{
    if (!_invalidated) {
        NSAssert(_networking, @"Networking must be set to yes in order to invalidate an alert view");
        _invalidated = YES;
        
        CGRect oldFrame = self.mainViewController.view.frame;
        [self.mainViewController.view removeFromSuperview];
        self.mainViewController = nil;
        
        if (!title) {
            title = @"Network Error!";
        }
        if (!description) {
            description = @"Please check your internet connection and try again.";
        }
        
        if (!buttonTitle) {
            buttonTitle = @"OKAY";
        }
        NSArray *buttonItems = @[[SeshAlertViewItem alertViewViewButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithWhite:.8 alpha:1.0] selectedBackgroundColor:[UIColor colorWithWhite:.6 alpha:1.0]]];
        SeshAlertViewController *vc = [[SeshAlertViewController alloc] initWithTitle:title description:description buttonItems:buttonItems image:nil];
        vc.delegate = self;
        self.mainViewController = vc;
        self.mainViewController.view.frame = oldFrame;
        [self.rootViewController.view addSubview:self.mainViewController.view];

        [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    }
}

- (void)setNetworking:(BOOL)networking
{
    _networking = networking;
    
    if (networking) {
        _spinnerView = nil;
        _spinnerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle3.png"]];
        _spinnerView.backgroundColor = [UIColor clearColor];
        CGFloat spinnerSize = [UIScreen mainScreen].bounds.size.width/6.0;
        _spinnerView.bounds = CGRectMake(0, 0, spinnerSize, spinnerSize);
        _spinnerView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _spinnerView.alpha = 1.0;
        
        [self.rootViewController.view insertSubview:_spinnerView belowSubview:self.mainViewController.view];
        
        [self addRotationAnimation];
        [UIView animateWithDuration:.1 animations:^{
            _spinnerView.alpha = 1.0;
        }];
        [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height + self.mainViewController.view.bounds.size.height)];
    } else {
        [UIView animateWithDuration:.1 animations:^{
            _spinnerView.alpha = 0.0;
        }];
        
        [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
    }
}

- (void)addRotationAnimation
{
    CABasicAnimation* rotationAnimation;
    CGFloat duration = 1.5;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.removedOnCompletion = YES;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.repeatCount = INFINITY;
    
    [_spinnerView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - SeshAlertViewControllerDelegate methods

- (void)alertViewController:(SeshAlertViewController *)controller didTapButtonAtIndex:(NSInteger)index
{
    BOOL shouldDismiss = YES;
    
    if (_invalidated) {
        [self dismissWithIndex:0];
    } else {
        if ([_alertViewDelegate respondsToSelector:@selector(seshAlertView:clickedButtonAtIndex:)]) {
            shouldDismiss = [_alertViewDelegate seshAlertView:self clickedButtonAtIndex:index];
        }
        if (self.buttonClickedBlock) {
            shouldDismiss = shouldDismiss && self.buttonClickedBlock(self, index);
        }
        
        if (shouldDismiss) {
            [self dismissWithIndex:index];
        }
    }
}

- (void)shouldBeginBackgroundNetworkingWithCompletionText:(NSString *)completionText
{
    _confirmationView = [[SeshConfirmationAnimationView alloc] initWithFrame:self.rootViewController.view.bounds];
    _confirmationView.alpha = 0.0f;
    _confirmationView.type = SeshConfirmationAnimationViewTypeNone;
    _confirmationView.confirmationText = completionText;
    [self.rootViewController.view addSubview:_confirmationView];

    [UIView animateWithDuration:0.3 animations:^{
        _confirmationView.alpha = 1.0f;
    }];
    
    [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height + self.mainViewController.view.bounds.size.height)];

}

- (void)backgroundNetworkingFailedWithReason:(NSString *)reason
{
    NSString *title = @"Whoops!";
    
    if (!reason) {
        reason = @"Please check your internet connection and try again.";
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _confirmationView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_confirmationView removeFromSuperview];
                         
                         _invalidated = YES;
                         
                         CGRect oldFrame = CGRectMake(self.mainViewController.view.frame.origin.x, self.mainViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width * DEFAULT_X_PROPORTION, self.rootViewController.view.frame.size.height * DEFAULT_Y_PROPORTION);
                         [self.mainViewController.view removeFromSuperview];
                         self.mainViewController = nil;
                        
                        NSArray *buttonItems = @[[SeshAlertViewItem alertViewViewButtonItemWithTitle:@"OKAY" backgroundColor:[UIColor colorWithWhite:.8 alpha:1.0] selectedBackgroundColor:[UIColor colorWithWhite:.6 alpha:1.0]]];
                         SeshAlertViewController *vc = [[SeshAlertViewController alloc] initWithTitle:title description:reason buttonItems:buttonItems image:nil];
                         vc.delegate = self;
                         self.mainViewController = vc;
                         self.mainViewController.view.frame = oldFrame;
                         [self.rootViewController.view addSubview:self.mainViewController.view];
                         
                         [self addDismissAnimationToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
                     }];
}

- (void)shouldFinishBackgroundNetworkingWithButtonIndex:(NSInteger)index
{
    __block SeshAlertView *alertView = self;

    _confirmationView.completionBlock = ^(SeshConfirmationAnimationView *confirmationView) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             confirmationView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             
                             [super dismissWithCompletion:^(SeshBlurWindow *window) {
                                 if ([alertView.alertViewDelegate respondsToSelector:@selector(seshAlertView:didDismissWithIndex:)]) {
                                     [alertView.alertViewDelegate seshAlertView:alertView didDismissWithIndex:index];
                                 }
                                 
                                 if (alertView.dismissalBlock) {
                                     alertView.dismissalBlock(alertView, index);
                                 }
                                 
                                 [alertView.internalDelegate seshAlertView:alertView didDismissWithIndex:index];
                             }];
                         }];

    };
    
    [_confirmationView startAnimating];
}


- (void)didClickOutsideBounds
{
    BOOL shouldDismiss = self.dismissOnTapOutsideBounds;
    if (_invalidated) {
        [self dismissWithIndex:0];
    } else {
        if ([_alertViewDelegate respondsToSelector:@selector(seshAlertViewDidClickOutsideBounds:)]) {
            shouldDismiss = [_alertViewDelegate seshAlertViewDidClickOutsideBounds:self];
        }
        
        if (shouldDismiss) {
            [self dismissWithIndex:0];
        }
    }
}

@end
