//
//  YHNetwork.m
//
//  Created by DEV_TEAM1_IOS on 2015. 9. 14..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHNetwork.h"

@implementation YHNetwork

static dispatch_once_t once;

static YHNetwork * __sharedInstance = nil;

+ (YHNetwork *)sharedInstance
{
    if (!__sharedInstance)
    {
        dispatch_once(&once, ^{
            
            __sharedInstance = [[YHNetwork alloc] initWithBaseURL:[NSURL URLWithString:REQ_BASE_URL]];
//            __sharedInstance.requestSerializer.HTTPShouldHandleCookies = YES;
            
        });
    }
    
    return __sharedInstance;
}


@end
