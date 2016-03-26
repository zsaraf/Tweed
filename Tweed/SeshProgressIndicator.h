//
//  SeshProgressIndicator.h
//  CinchApp
//
//  Created by Zachary Saraf on 9/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeshProgressIndicator : UIView

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat radius;

/* Progress between 0.0 and 1.0 */
@property (nonatomic, assign) CGFloat progress;

@end
