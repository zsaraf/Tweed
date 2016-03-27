//
//  CinchAuthManager.m
//  CinchApp
//
//  Created by franzwarning on 7/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "TweedAuthManager.h"
#import "AccessToken.h"
#import "Tweed-Swift.h"

@implementation TweedAuthManager

+ (TweedAuthManager *)sharedManager
{
    static TweedAuthManager *shared;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        shared = [[TweedAuthManager alloc] init];
    });
    
    return shared;
}

/**
 * Checks whether or not the current session is authenticated by checking for the
 * authorization token and making sure it is not expired.
 * @return YES if valid session, NO if invalid session.
 */
- (BOOL)isValidSession
{
    if ([self accessToken].length > 0) {
        return true;
    } else {
        return false;
    }
}

/**
 * Get the access token (if there is one).
 * @return The access token for this session. String is empty if no access token.
 */
- (NSString *)accessToken
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    // If there is nothing there -- return
    if (!encodedObject) {
        return @"";
    }
    AccessToken *at = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    if ([at isValid]) {
        return at.sessionId;
    } else {
        return nil;
    }
}

- (void)getAccessTokenWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    [TweedNetworking getAnonymousToken:^(NSURLSessionTask * _Nonnull task, id _Nonnull responseObject) {
        [self foundSessionId:responseObject[@"session_id"]];
        completionHandler(YES);
    } failureHandler:^(NSURLSessionTask * _Nonnull responseObject, NSError * _Nonnull error) {
        completionHandler(NO);
    }];
}

- (void)foundSessionId:(NSString *)sessionId
{
    // Create the access token
    AccessToken *newToken = [AccessToken tokenWithSessionId:sessionId];
    
    // Write the accessToken to NSUserDefaults
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:newToken];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
