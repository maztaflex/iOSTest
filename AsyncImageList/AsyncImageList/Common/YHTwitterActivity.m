//
//  YHTwitterActivity.m
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 31..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHTwitterActivity.h"

@implementation YHTwitterActivity

- (NSString *)activityTitle
{
    return @"Twitter";
}

- (NSString *)activityType
{
    return UIActivityTypePostToTwitter;
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"toggle_select_n"];
}


@end
