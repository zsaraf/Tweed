//
//  CinchButton.h
//  CinchApp
//
//  Created by Zachary Waleed Saraf on 7/14/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SeshButtonType) {
    SeshButtonTypeRed,
    SeshButtonTypeGray,
};

@interface SeshButton : UIButton

- (instancetype)initWithType:(SeshButtonType)type title:(NSString *)title;

+ (CGSize)typicalSizeForBoundingRect:(CGSize)boundingSize;

+ (CGFloat)superviewWidthPercentage;

+ (CGFloat)typicalHeight;

@end
