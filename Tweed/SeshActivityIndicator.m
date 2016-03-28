//
//  SeshActivityIndicator.m
//  Sesh
//
//  Created by Zachary Saraf on 1/25/15.
//  Copyright (c) 2015 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshActivityIndicator.h"

@implementation SeshActivityIndicator {
    UIImageView *_spinnerView;

    BOOL _isAnimating;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _spinnerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tweed_activityindicator"]];
        _spinnerView.backgroundColor = [UIColor clearColor];
        CGFloat spinnerSize = [UIScreen mainScreen].bounds.size.width/6.0;
        _spinnerView.bounds = CGRectMake(0, 0, spinnerSize, spinnerSize);
        _spinnerView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        _spinnerView.alpha = 1.0;
        [self addSubview:_spinnerView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _spinnerView.frame = self.bounds;
}

- (void)addRotationAnimation
{
    [_spinnerView.layer removeAllAnimations];
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

- (void)startAnimating
{
    _isAnimating = YES;
    [self addRotationAnimation];
}

- (void)stopAnimating
{
    _isAnimating = NO;
    [_spinnerView.layer removeAllAnimations];
}

- (void)didBecomeActive:(NSNotification *)notification
{
    if (_isAnimating) {
        [self addRotationAnimation];
    }
}

@end
