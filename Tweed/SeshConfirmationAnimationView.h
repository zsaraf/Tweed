//
//  SeshConfirmationAnimationView.h
//  CinchApp
//
//  Created by Zachary Saraf on 9/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
@import pop;

@class SeshConfirmationAnimationView;

@protocol SeshConfirmationViewDelegate <NSObject>

@optional

- (void)confirmationViewDidFinishAnimating:(SeshConfirmationAnimationView *)view;

@end

typedef NS_ENUM(NSUInteger, SeshConfirmationAnimationViewType) {
    SeshConfirmationAnimationViewTypeWhite,
    SeshConfirmationAnimationViewTypeBlack,
    SeshConfirmationAnimationViewTypeNone
};

typedef void(^SeshConfirmationAnimationViewCompletionHandler)(SeshConfirmationAnimationView *confirmationView);

@interface SeshConfirmationAnimationView : UIView <POPAnimationDelegate>

@property (nonatomic, strong) NSString *confirmationText;
@property (nonatomic, weak) id<SeshConfirmationViewDelegate> delegate;
@property (nonatomic, assign) SeshConfirmationAnimationViewType type;
@property (nonatomic, copy) SeshConfirmationAnimationViewCompletionHandler completionBlock;

- (void)startAnimating;

@end
