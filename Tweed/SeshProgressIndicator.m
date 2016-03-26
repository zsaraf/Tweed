//
//  SeshProgressIndicator.m
//  CinchApp
//
//  Created by Zachary Saraf on 9/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshProgressIndicator.h"
#import <math.h>
#import "UIColor+Sesh.h"
#import "UIFont+Sesh.h"

@implementation SeshProgressIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.strokeColor = [UIColor seshDarkRed];
        self.strokeWidth = 4.0;
        self.radius = 40;
        
        self.progress = .5;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddArc(c, self.bounds.size.width/2, self.bounds.size.height/2, self.radius, 0, 2 * M_PI * _progress, 0);
    CGContextSetLineWidth(c, self.strokeWidth);
    CGContextSetStrokeColorWithColor(c, self.strokeColor.CGColor);
    CGContextStrokePath(c);
}

- (void)sizeToFit
{
    self.bounds = CGRectMake(0, 0, self.radius * 2 + self.strokeWidth * 2, self.radius * 2 + self.strokeWidth * 2);
}

@end
