//
//  SeshTopBarView.m
//  CinchApp
//
//  Created by Zachary Saraf on 9/24/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshTopBarView.h"
#import "UILabel+Sesh.h"
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"
#import "SeshIncreaseTapRadiusButton.h"

static const CGFloat kTopBarButtonSize = 18.0;
static const CGFloat kTopBarHorizontalPadding = 15.0;

@implementation SeshTopBarView

- (id)initWithLeftButtonImage:(UIImage *)leftButtonImage
             rightButtonImage:(UIImage *)rightButtonImage
                    titleText:(NSString *)titleText
{
    if (self = [super initWithFrame:CGRectZero]) {
        _leftButton = [SeshIncreaseTapRadiusButton buttonWithType:UIButtonTypeCustom tapRadius:30];
        [_leftButton addTarget:self action:@selector(tappedLeftButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:leftButtonImage forState:UIControlStateNormal];
        _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_leftButton];
        
        _rightButton = [SeshIncreaseTapRadiusButton buttonWithType:UIButtonTypeCustom tapRadius:30];
        [_rightButton addTarget:self action:@selector(tappedRightButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setImage:rightButtonImage forState:UIControlStateNormal];
        _rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_rightButton];

        _titleLabel = [UILabel seshLabelWithFontType:kSeshLabelFontLight fontSize:19.0 color:nil text:titleText];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonYOrigin = (self.bounds.size.height - kTopBarButtonSize)/2;
    _leftButton.frame = CGRectMake(kTopBarHorizontalPadding, buttonYOrigin, kTopBarButtonSize, kTopBarButtonSize);
    _rightButton.frame = CGRectMake(self.bounds.size.width - kTopBarHorizontalPadding - kTopBarButtonSize, buttonYOrigin, kTopBarButtonSize, kTopBarButtonSize);

    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)tappedLeftButton:(UIButton *)leftButton
{
    if ([leftButton imageForState:UIControlStateNormal] && [self.delegate respondsToSelector:@selector(topBarViewDidTapLeftButtonImage:)]) {
        [self.delegate topBarViewDidTapLeftButtonImage:self];
    }
}

- (void)tappedRightButton:(UIButton *)rightButton
{
    if ([rightButton imageForState:UIControlStateNormal] && [self.delegate respondsToSelector:@selector(topBarViewDidTapRightButtonImage:)]) {
        [self.delegate topBarViewDidTapRightButtonImage:self];
    }
}

@end
