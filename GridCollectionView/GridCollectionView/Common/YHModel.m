//
//  YHModel.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHModel.h"

@implementation YHModel

- (instancetype)init
{
    if (self = [super init]) {
        _tools = [YHTools sharedInstance];
        _networkManager = [YHNetwork sharedInstance];
    }
    
    return self;
}

@end
