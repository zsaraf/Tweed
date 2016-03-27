//
//  SeshIncreaseTapRadiusButton.m
//  Sesh
//
//  Created by Zachary Saraf on 8/11/15.
//  Copyright (c) 2015 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshIncreaseTapRadiusButton.h"

@implementation SeshIncreaseTapRadiusButton {
    CGFloat _tapRadius;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
                     tapRadius:(CGFloat)tapRadius
{
    SeshIncreaseTapRadiusButton *button = [super buttonWithType:buttonType];
    button->_tapRadius = tapRadius;
    return button;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect expandedBounds = CGRectInset(self.bounds, -1 *_tapRadius, -1 * _tapRadius);
    if (point.x > expandedBounds.origin.x &&
        point.x < expandedBounds.origin.x + expandedBounds.size.width &&
        point.y > expandedBounds.origin.y &&
        point.y < expandedBounds.origin.y + expandedBounds.size.height) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
