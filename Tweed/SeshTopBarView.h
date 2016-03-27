//
//  SeshTopBarView.h
//  CinchApp
//
//  Created by Zachary Saraf on 9/24/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeshTopBarView;

@protocol SeshTopBarViewDelegate <NSObject>

@optional
- (void)topBarViewDidTapLeftButtonImage:(SeshTopBarView *)topBarView;
- (void)topBarViewDidTapRightButtonImage:(SeshTopBarView *)topBarView;

@end

@interface SeshTopBarView : UIView

- (id)initWithLeftButtonImage:(UIImage *)leftButtonImage
             rightButtonImage:(UIImage *)rightButtonImage
                    titleText:(NSString *)titleText;

@property (nonatomic, weak) id<SeshTopBarViewDelegate> delegate;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end
