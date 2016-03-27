//
//  SeshAlertViewManager.m
//  CinchApp
//
//  Created by Zachary Saraf on 12/30/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "SeshAlertViewManager.h"
#import "SeshAlertViewInternal.h"

@interface SeshAlertViewManager () <SeshAlertViewDelegate>

@end

@implementation SeshAlertViewManager{
    NSMutableArray *_alertViewQueue;
}

static SeshAlertViewManager *sharedInstance = nil;

- (instancetype)init
{
    if (self = [super init]) {
        _alertViewQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (SeshAlertViewManager *)sharedManager {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[SeshAlertViewManager alloc] init];
    });
    
    return sharedInstance;
}


- (void)scheduleAlertView:(SeshAlertView *)alertView
{
    alertView.internalDelegate = self;
    [_alertViewQueue addObject:alertView];

    if (!self.currentAlertView) {
        [self _showNextAlertView];
    } else if (!self.currentAlertView.isKeyWindow) {
        self.currentAlertView.hidden = YES;
        [self seshAlertView:self.currentAlertView didDismissWithIndex:-1];
    }
}

- (void)_showNextAlertView
{
    if (_alertViewQueue.count > 0) {
        SeshAlertView *view = [_alertViewQueue objectAtIndex:0];
        [_alertViewQueue removeObjectAtIndex:0];
        self.currentAlertView = view;

        [view showInternal];
    }
}

#pragma mark - SeshAlertViewDelegate methods

- (void)seshAlertView:(SeshAlertView *)seshAlertView
  didDismissWithIndex:(NSInteger)index
{
    self.currentAlertView = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _showNextAlertView];
    });
}

@end
