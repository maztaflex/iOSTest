//
//  DataManager.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 18..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static dispatch_once_t once;

static DataManager * __sharedInstance = nil;

+ (DataManager *)sharedInstance
{
    if (!__sharedInstance)
    {
        dispatch_once(&once, ^{
            
            __sharedInstance = [[self alloc] init];
            
        });
    }
    
    return __sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
    }
    
    return self;
}


@end
