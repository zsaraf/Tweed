//
//  SeshAlertViewInternal.m
//  Sesh
//
//  Created by Zachary Saraf on 8/11/15.
//  Copyright (c) 2015 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeshAlertView.h"

@interface SeshAlertView ()

/* This is so that the alert view manager is the one that is actually responsible for showing the alert view, while the client believes that he is. */
- (void)showInternal;

@property (nonatomic, weak) id<SeshAlertViewDelegate> internalDelegate;

@end
