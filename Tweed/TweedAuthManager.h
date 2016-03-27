//
//  CinchAuthManager.h
//  CinchApp
//
//  Created by franzwarning on 7/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweedAuthManager : NSObject

+ (TweedAuthManager *)sharedManager;

- (NSString *)accessToken;
- (BOOL)isValidSession;
- (void)getAccessTokenWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
