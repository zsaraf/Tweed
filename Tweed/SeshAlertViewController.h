//
//  SeshAlertViewController.h
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeshBlurWindow.h"

@class SeshAlertViewController;
@protocol SeshAlertViewControllerDelegate <NSObject>

- (void)alertViewController:(SeshAlertViewController *)controller
        didTapButtonAtIndex:(NSInteger)index;
- (void)didClickOutsideBounds;
- (void)shouldBeginBackgroundNetworkingWithCompletionText:(NSString *)completionText;
- (void)shouldFinishBackgroundNetworkingWithButtonIndex:(NSInteger)index;
- (void)backgroundNetworkingFailedWithReason:(NSString *)reason;

@end

@interface SeshAlertViewController : UIViewController <SeshBlurWindowViewControllerDelegate>

- (instancetype)initWithTitle:(NSString *)title
                  buttonItems:(NSArray *)buttonItems
                   customView:(UIView *)customView;

- (instancetype)initWithFrontSideTitle:(NSString *)frontSideTitle
                  frontSideButtonItems:(NSArray *)frontSideButtonItems
                   frontSideCustomView:(UIView *)frontSideCustomView
                         backSideTitle:(NSString *)backSideTitle
                   backSideButtonItems:(NSArray *)backSideButtonItems
                    backSideCustomView:(UIView *)backSideCustomView;

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
                  buttonItems:(NSArray *)buttonItems
                        image:(UIImage *)image;

- (void)flipContent;

@property (nonatomic, weak) id<SeshAlertViewControllerDelegate> delegate;
@property (nonatomic, weak) UIImageView *_imageView;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *bsButtons;

@end
