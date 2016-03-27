//
//  CinchButton.m
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 7/14/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshButton.h"

#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"
#import "UIImage+SeshUtils.h"
#import "SeshUtils.h"
#import "Tweed-Swift.h"

static const CGFloat kButtonFontSize = 15.f;
static const float kButtonWidth = 225;
static const float kButtonHeight = 40;

@implementation SeshButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setType:SeshButtonTypeRed];
    self.frame = frame;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    return self;
}

- (instancetype)initWithType:(SeshButtonType)type title:(NSString *)title
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setType:type];
    }
    return self;
}

- (void)setType:(SeshButtonType)type
{
    if (type == SeshButtonTypeRed) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor seshButtonNormalColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor seshButtonSelectedColor]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor seshButtonSelectedColor]] forState:UIControlStateSelected];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self.titleLabel setFont:[UIFont mediumGothamWithSize:[SeshUtils scaledFontSizeForFontSize:kButtonFontSize]]];
    } else if (type == SeshButtonTypeGray) {
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:.9 alpha:1.0]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:.5 alpha:1.0]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithWhite:.4 alpha:1.0] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont mediumGothamWithSize:[SeshUtils scaledFontSizeForFontSize:kButtonFontSize]];
    }
}

- (void)sizeToFit
{
    self.bounds = CGRectMake(0, 0, kButtonWidth, kButtonHeight);
}

+ (CGSize)typicalSizeForBoundingRect:(CGSize)boundingSize
{
    CGFloat width = boundingSize.width * [self superviewWidthPercentage];
    CGFloat height = [self typicalHeight];
    return CGSizeMake(width, height);
}

+ (CGFloat)superviewWidthPercentage
{
    return 0.85f;
}

+ (CGFloat)typicalHeight
{
    return [UIScreen mainScreen].bounds.size.height/16;
}

@end
