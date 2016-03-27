//
//  SeshAlertViewManager.h
//  CinchApp
//
//  Created by Zachary Saraf on 12/30/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeshAlertView;
@interface SeshAlertViewManager : NSObject

+ (SeshAlertViewManager *)sharedManager;

- (void)scheduleAlertView:(SeshAlertView *)alertView;

@property (nonatomic, strong) SeshAlertView *currentAlertView;
@property (nonatomic, assign) BOOL disableAlertViews;

@end
