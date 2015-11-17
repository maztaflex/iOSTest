//
//  YHGooglePlusActivity.m
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 31..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHGooglePlusActivity.h"
#import "YHSnsModel.h"

@interface YHGooglePlusActivity ()

@property (strong, nonatomic) YHSnsModel *snsModel;
@property (weak, nonatomic) UIViewController *fromViewController;

@end

@implementation YHGooglePlusActivity

- (NSString *)activityTitle
{
    return @"Google+";
}

- (NSString *)activityType
{
    return @"YHCustomActivityTypeGooglePlus";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"toggle_select_n"];
}

- (void)performActivity
{
    LogGreen(@"- (void)performActivity");
    
    NSMutableDictionary *passObjects = [NSMutableDictionary dictionary];
    
    if (self.shareText != nil) {
        [passObjects setObject:self.shareText forKey:@"shareText"];
    }
    
    if (self.shareImage != nil) {
        [passObjects setObject:self.shareImage forKey:@"shareImage"];
    }
    
    if (self.shareURL != nil) {
        [passObjects setObject:self.shareURL forKey:@"shareURL"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YHShouldStartShareGooglePlusNotification object:passObjects];
    
    [self activityDidFinish:YES];
    
}


@end
