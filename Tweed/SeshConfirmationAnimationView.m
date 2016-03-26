//
//  SeshConfirmationAnimationView.m
//  CinchApp
//
//  Created by Zachary Saraf on 9/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshConfirmationAnimationView.h"
#import "SeshProgressIndicator.h"
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"
#import "UILabel+Sesh.h"
#import "SeshActivityIndicator.h"

#define kActivityIndicatorSize ([UIScreen mainScreen].bounds.size.width/8.0)

@implementation SeshConfirmationAnimationView {
    SeshProgressIndicator *_seshProgressIndicator;
    
    UIImageView *_confirmationImageView;
    
    CGFloat _animationProgress;
    
    UILabel *_confirmationLabel;
    
    SeshActivityIndicator *_indicatorView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = SeshConfirmationAnimationViewTypeWhite;
        _seshProgressIndicator = [[SeshProgressIndicator alloc] initWithFrame:CGRectZero];
        [_seshProgressIndicator sizeToFit];
        _seshProgressIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _seshProgressIndicator.progress = 0.0;
        [self addSubview:_seshProgressIndicator];

        _indicatorView = [[SeshActivityIndicator alloc] initWithFrame:CGRectMake(0, 0, kActivityIndicatorSize, kActivityIndicatorSize)];
        [self addSubview:_indicatorView];
        [_indicatorView startAnimating];
    }
    return self;
}

- (void)setType:(SeshConfirmationAnimationViewType)type
{
    _type = type;

    if (type == SeshConfirmationAnimationViewTypeBlack) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.85];
    } else if (type == SeshConfirmationAnimationViewTypeWhite) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.95];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _seshProgressIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _indicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)startAnimating
{
    [UIView animateWithDuration:.1 animations:^{
        _indicatorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        POPBasicAnimation *springAnim = [POPBasicAnimation animation];
        springAnim.fromValue = @(0.0);
        springAnim.toValue = @(1.0);
        springAnim.duration = 0.5;
        springAnim.property = [POPAnimatableProperty propertyWithName:@"scaleThing" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(SeshProgressIndicator *indicator, CGFloat *value) {
                *value = [indicator progress];
            };
            prop.writeBlock= ^(SeshProgressIndicator *indicator, const CGFloat *value) {
                [indicator setProgress:*value];
            };
            prop.threshold = .0001;
        }];
        springAnim.completionBlock = ^(POPAnimation *anim, BOOL completed) {
            [self addSpringConfirmation];
        };
        
        [_seshProgressIndicator pop_addAnimation:springAnim forKey:@"scaleAnimation"];
    }];
}

- (void)addSpringConfirmation
{
    [_confirmationImageView removeFromSuperview];
    _confirmationImageView = nil;
    
    _confirmationImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"payment_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _confirmationImageView.tintColor = [UIColor seshDarkRed];
    _confirmationImageView.contentMode = UIViewContentModeScaleAspectFit;
    _confirmationImageView.frame = _seshProgressIndicator.frame;
    [self addSubview:_confirmationImageView];
    
    
    _confirmationLabel = [UILabel seshLabelWithFontType:kSeshLabelFontRegular fontSize:16 color:nil text:self.confirmationText];
    [_confirmationLabel sizeToFit];
    _confirmationLabel.layer.anchorPoint = CGPointMake(.5, 0);
    _confirmationLabel.center = CGPointMake(self.bounds.size.width/2,
                                            _seshProgressIndicator.frame.origin.y + _seshProgressIndicator.frame.size.height + 10 + _confirmationLabel.bounds.size.height/2);
    [self addSubview:_confirmationLabel];
    
    POPSpringAnimation *basicAnim = [POPSpringAnimation animation];
    basicAnim.fromValue = @(0.0);
    basicAnim.toValue = @(.4);
    basicAnim.springBounciness = 13;
    basicAnim.springSpeed = 9;
    basicAnim.property = [POPAnimatableProperty propertyWithName:@"scaling" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(SeshConfirmationAnimationView *animView, CGFloat *value) {
            *value = animView->_animationProgress;
        };
        prop.writeBlock= ^(SeshConfirmationAnimationView *animView, const CGFloat *value) {
            [animView _setAnimationProgress:*value];
        };
        prop.threshold = .0001;
    }];
    basicAnim.delegate = self;
    basicAnim.completionBlock = ^(POPAnimation *animation, BOOL success) {
        if ([self.delegate respondsToSelector:@selector(confirmationViewDidFinishAnimating:)]) {
            [self.delegate confirmationViewDidFinishAnimating:self];
        }
        if (self.completionBlock) {
            self.completionBlock(self);
        }
    };
    [self pop_addAnimation:basicAnim forKey:@"basicAnimation"];
}

- (void)_setAnimationProgress:(CGFloat)progress
{
    _animationProgress = progress;
    
    _confirmationImageView.transform = CGAffineTransformMakeScale(1.0 + progress, 1.0 + progress);
    _seshProgressIndicator.transform = CGAffineTransformMakeScale(1.0 + progress, 1.0 + progress);
    _confirmationLabel.transform = CGAffineTransformMakeScale(1.0 + progress, 1.0 + progress);
}

- (void)pop_animationDidReachToValue:(POPBasicAnimation *)anim
{
    if ([anim.toValue floatValue] != 0) {
        anim.toValue = @(0);
    }
}

@end
