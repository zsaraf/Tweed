//
//  AccessToken.m
//  CinchApp
//
//  Created by franzwarning on 7/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import "AccessToken.h"

@interface AccessToken () <NSCoding>
@end

@implementation AccessToken

/**
 * Tells whether or not the token is valid.
 * @return YES if valid token. NO if invalid token.
 */
- (BOOL)isValid
{
    if (self.sessionId){
        return YES;
    }
    
    return NO;
}

/**
 * Sets the token and expiration date.
 * @param token The token string.
 * @param expiration The amount of time (in seconds) the token has until it expires.
 */
+ (AccessToken *)tokenWithSessionId:(NSString *)sessionId;
{
    AccessToken *accessToken = [[AccessToken alloc] init];
    accessToken.sessionId = sessionId;
    return accessToken;
}

/**
 * Encode the access token.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sessionId forKey:@"token"];
}

/**
 * Decode the access token.
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.sessionId = [decoder decodeObjectForKey:@"token"];
    }
    return self;
}

@end
