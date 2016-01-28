//
//  YHPushModel.h
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 6..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHModel.h"
#import <Parse/Parse.h>

@interface YHPushModel : YHModel

// Parse
- (void)registerForParseRemoteNotificationWithApplication:(UIApplication *)application;
- (void)saveTokenForParseWithDeviceToken:(NSData *)deviceToken;
- (void)setObjectForParse:(id)obj forKey:(NSString *)key;
- (void)defaultHandlerForParseDidReceivePushWithUserInfo:(NSDictionary *)userInfo;


@end
