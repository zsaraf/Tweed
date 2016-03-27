//
//  AccessToken.h
//  CinchApp
//
//  Created by franzwarning on 7/15/14.
//  Copyright (c) 2014 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (nonatomic, strong) NSString *sessionId;

- (BOOL)isValid;
+ (AccessToken *)tokenWithSessionId:(NSString *)sessionId;

@end
