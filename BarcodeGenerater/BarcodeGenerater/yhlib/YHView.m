//
//  YHView.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHView.h"

@implementation YHView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tools = [YHTools sharedInstance];
}


@end
