//
//  SeshAlertView.h
//  CinchApp
//
//  Created by Zachary Saraf on 12/27/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshBlurWindow.h"
#import "SeshAlertViewItem.h"
#import "SeshAlertViewController.h"

@class SeshAlertView;

typedef void(^SeshAlertViewDismissalHandler)(SeshAlertView *alertView, NSInteger index);
typedef BOOL(^SeshAlertViewClickedButtonHandler)(SeshAlertView *alertView, NSInteger index);

@protocol SeshAlertViewDelegate <NSObject>

@optional

/* Button at index in alert view was clicked. Return YES if alert view should dismiss
   Return no if alert view should not dismiss. */
- (BOOL)seshAlertView:(SeshAlertView *)seshAlertView
 clickedButtonAtIndex:(NSInteger)index;

- (void)seshAlertView:(SeshAlertView *)seshAlertView
  didDismissWithIndex:(NSInteger)index;

- (BOOL)seshAlertViewDidClickOutsideBounds:(SeshAlertView *)seshAlertView;

@end

@interface SeshAlertView : SeshBlurWindow <SeshAlertViewControllerDelegate>


- (instancetype)initSwiftWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles;

/* 
 This can only be called when networking is set to yes.
 This will bring up a new alert view that says that there are network 
 problems. If you pass nil for title, description, or button title, we will
 use defaults.
 */
- (void)setInvalidatedWithTitle:(NSString *)title
                    description:(NSString *)description
                    buttonTitle:(NSString *)buttonTitle;

@property (nonatomic, weak) id<SeshAlertViewDelegate> alertViewDelegate;

/* If this is non nil, this will be called when the seshalert view dismisses */
@property (nonatomic, copy) SeshAlertViewDismissalHandler dismissalBlock;
@property (nonatomic, copy) SeshAlertViewClickedButtonHandler buttonClickedBlock;
@property (nonatomic, assign) BOOL networking;
@property (nonatomic, assign) CGFloat xProportion;
@property (nonatomic, assign) CGFloat yProportion;
@property (nonatomic, assign) BOOL dismissOnTapOutsideBounds;

@end
