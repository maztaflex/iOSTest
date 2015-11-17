//
//  YHPushModel.m
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 6..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHPushModel.h"

@implementation YHPushModel

- (void)registerForParseRemoteNotificationWithApplication:(UIApplication *)application
{
    // Init Parse
    [Parse setApplicationId:kParseAppId
                  clientKey:kParseClientKey];
    
    BOOL isLaunched = [[self.tools getUserDefaultsValueWithKey:kIsRegisgeredRemotePush] boolValue];
    if (isLaunched) return;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") == YES)
    {
        // iOS 8 이상 Device Token 정보 등록
        // Register for Push Notitications
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS 8 미만 Device Token 정보 등록
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)saveTokenForParseWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)setObjectForParse:(id)obj forKey:(NSString *)key
{
    // Store the object in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    LogGreen(@"currentInstallation.installationId : %@",currentInstallation.installationId);
    [currentInstallation setObject:obj forKey:key];
    [currentInstallation saveInBackground];
}

- (void)defaultHandlerForParseDidReceivePushWithUserInfo:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}


@end
