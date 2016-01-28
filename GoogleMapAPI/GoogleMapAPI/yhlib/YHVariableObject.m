//
//  YHVariableObject.m
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 2..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHVariableObject.h"

@implementation YHVariableObject

- (instancetype)init
{
    if (self = [super init]) {
        _tools = [YHTools sharedInstance];
    }
    
    return self;
}

@end
