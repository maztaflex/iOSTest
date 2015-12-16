//
//  YHSnsModel.h
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 28..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMPBaseViewController;

@import MessageUI;

typedef NS_ENUM(NSInteger, YHSnsType) {
    YHSnsTypeFacebook = 0,
    YHSnsTypeTwitter,
    YHSnsTypeSinaWeibo,
    YHSnsTypeTencentWeibo,
    YHSnsTypeGoolePlus
};

#pragma mark - Subclass of UIApplication for Goole Plus Embeded Login
@interface YHApplications : UIApplication

@end

@interface YHSnsModel : NSObject

#pragma mark - Initialize
- (instancetype)initWithTarget:(SMPBaseViewController *)vc;
+ (Class)YHApplications; // Using for Goole Plus Embeded Login

#pragma mark - System
// SNS Select Menu
- (void)showSelectSNSMenuWithShareContent:(NSString *)text image:(UIImage *)image urlString:(NSString *)urlString;

// Account
- (void)loginWithSnsType:(YHSnsType)snsType;
- (void)loginWithSnsType:(YHSnsType)snsType completionSuccess:(void (^)(void))success;
- (void)logoutWithSnsType:(YHSnsType)snsType;

// Send Mail
- (void)sendMailViewControllerWithTitle:(NSString *)title
                            messageBody:(NSString *)message
                                 target:(UIViewController *)target
                      completionSuccess:(void (^)(void))success
                                   fail:(void (^)(void))fail;
#pragma mark - Google+ SDK
- (void)GPPShareContentWithText:(NSString *)text image:(UIImage *)image url:(NSURL *)url;
+ (BOOL)GPPURLHandelrWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

#pragma mark - Facebook SDK
+ (void)FBSDKApplicationDelegateApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (BOOL)FBSDKApplicationDelegateApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)FBSDKLoginFromViewController:(UIViewController *)fromViewController
                             success:(void(^)(NSString *accessToken))success
                             failure:(void(^)(NSError *error))failure;

#pragma mark - Twitter SDK
+ (void)initTwitterSDK;
+ (void)TWTLoginWithSuccess:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;
@end
