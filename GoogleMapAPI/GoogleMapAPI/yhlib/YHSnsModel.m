//
//  YHSnsModel.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 28..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHSnsModel.h"
#import "YHFacebookActivity.h"
#import "YHTwitterActivity.h"
#import "YHGooglePlusActivity.h"
#import "YHTools.h"

// System
#import <Social/Social.h>

// Google Plus
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GTLPlusConstants.h>
#import "YHGoogleLoginViewController.h"

// FaceBook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Twitter
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

// Google Plust SDK Keys
static NSString * const kClientID = @"1076141216720-numeasbn5j5q06h7nde6pt8afptj4la4.apps.googleusercontent.com";

// Twitter SDK Keys
NSString *const kTwitterConsumerKey = @"iuDneOtSNCMCkFJO3GSpT4Ohy";
NSString *const kTwitterConsumerSecret = @"VArIhio9COZCXrwyj0P3YGLYeUoTOpzXWNlMcvSeGFko7qTKod";

@interface YHSnsModel () <GPPSignInDelegate, GPPShareDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) YHViewController *targetViewController;

@property (nonatomic, copy) void (^completionForSendMailSuccess)(void);
@property (nonatomic, copy) void (^completionForSendMailFail)(void);
@property (nonatomic, copy) void (^completionForLoginSuccess)(void);

@property (nonatomic, strong) YHTools *tools;

@end

@implementation YHApplications

- (BOOL)openURL:(NSURL*)url
{
    LogGreen(@"- (BOOL)openURL:(NSURL*)url : %@",url.absoluteString);
    
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"])
    {
        return NO;
        
    }
    else if ([[url absoluteString]hasPrefix:@"https://accounts.google.com/o/oauth2/auth"])
    {
        @try {
            LogRed(@"Plz Google+ Login!");
//            [[NSNotificationCenter defaultCenter] postNotificationName:YHApplicationOpenGoogleAuthNotification object:url];
            [[NSNotificationCenter defaultCenter] postNotificationName:YHShouldGooglePlusInstallNotification object:nil];
        }
        @catch (NSException *exception) {
            LogRed(@"exception : %@",exception);
        }
        
        return NO;
        
    }
    return [super openURL:url];
}

@end

@implementation YHSnsModel

#pragma mark - Etc.
+ (Class)YHApplications
{
    return [YHApplications class];
}

+ (NSArray *)customActivity
{
    NSArray *result = nil;
    
    YHFacebookActivity *fbActivity = [[YHFacebookActivity alloc] initWithServiceType:SLServiceTypeFacebook];
    YHTwitterActivity *twtActivity = [[YHTwitterActivity alloc] initWithServiceType:SLServiceTypeTwitter];
    YHGooglePlusActivity *gppActivity = [[YHGooglePlusActivity alloc] initWithServiceType:@"YHCustomActivityTypeGooglePlus"];
    
    result = @[fbActivity, twtActivity,gppActivity];
    
    return result;
}

#pragma mark - Initialize
// For Google+ Login
- (instancetype)initWithTarget:(YHViewController *)vc
{
    if (self = [super init])
    {
        _targetViewController = vc;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCenter:) name:YHApplicationOpenGoogleAuthNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCenter:) name:YHShouldStartShareGooglePlusNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlerForNotificationCenter:) name:YHShouldGooglePlusInstallNotification object:nil];
    }
    
    self.tools = [YHTools sharedInstance];
    
    return self;
}

#pragma mark - Local Notification
- (void)handlerForNotificationCenter:(NSNotification *)notification
{
    NSString *notifyName = notification.name;
    
    if ([notifyName isEqualToString:YHApplicationOpenGoogleAuthNotification] == YES)
    {
        NSURL *pass =notification.object;
        NSString *bundleIdentifier = @"com.doozerstage.yhdevtools";
        NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:bundleIdentifier];
        YHGoogleLoginViewController *googleLoginVC = [[YHGoogleLoginViewController alloc] initWithNibName:@"YHGoogleLoginViewController" bundle:frameworkBundle];
        googleLoginVC.urlForWebView = pass;
        [self.targetViewController presentViewController:googleLoginVC animated:YES completion:nil];
    }
    
    if ([notifyName isEqualToString:YHShouldStartShareGooglePlusNotification] == YES) {
        LogGreen(@"Start Google Share!!");
        
        NSDictionary *shareObjects = notification.object;
        
        [self GPPShareContentWithText:shareObjects[@"shareText"] image:shareObjects[@"shareImage"] url:shareObjects[@"shareURL"]];
    }
    
    if ([notifyName isEqualToString:YHShouldGooglePlusInstallNotification]) {
        [self.targetViewController showDefaultAlertViewWithMessage:[self.tools getLocalizedStringWithKey:@"product_detail_login_googleplus_to_share"]
                                                confirmButtonTitle:[self.tools getLocalizedStringWithKey:@"basic_ok"]];
    }
}

#pragma mark - System Share
- (void)showSelectSNSMenuWithShareContent:(NSString *)text image:(UIImage *)image urlString:(NSString *)urlString
{
    NSString *shareText = text;
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    UIImage *shareImage = image;
    
    NSMutableArray *shareItems = [NSMutableArray array];
    
    if (shareText != nil) {
        [shareItems addObject:shareText];
    }
    
    if (shareImage != nil) {
        [shareItems addObject:shareImage];
    }
    
    if (shareUrl) {
        [shareItems addObject:shareUrl];
    }
    
    
    NSArray *customActivities = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) ? nil : [YHSnsModel customActivity];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:shareItems
                                                                             applicationActivities:customActivities];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIActivityViewControllerCompletionWithItemsHandler handler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
            LogGreen(@"activityType : %@, completed : %zd, returnedItems : %@, activityError : %@",activityType, completed, returnedItems, activityError);
            
        };
        
        activityVC.completionWithItemsHandler = handler;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCenter:) name:@"test111" object:nil];
        
        UIActivityViewControllerCompletionHandler handelr = ^(NSString *activityType, BOOL completed){
            LogGreen(@"activityType : %@, completed : %zd",activityType, completed);
        };
        
        activityVC.completionHandler = handelr;
    }
    
    activityVC.excludedActivityTypes = @[UIActivityTypeMail,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeMessage,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypePrint,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList];
    
    [self.targetViewController presentViewController:activityVC animated:YES completion:nil];
}

- (void)shareContentWithSnsType:(YHSnsType)type
                           text:(NSString *)text
                          image:(UIImage *)image
                            url:(NSURL *)url
                         target:(UIViewController *)target
                     completion:(void (^)(void))completion
{
    NSString *serviceType = nil;
    
    switch (type)
    {
        case YHSnsTypeFacebook:
            serviceType = SLServiceTypeFacebook;
            break;
        case YHSnsTypeTwitter:
            serviceType = SLServiceTypeTwitter;
            break;
        case YHSnsTypeSinaWeibo:
            serviceType = SLServiceTypeSinaWeibo;
            break;
        case YHSnsTypeTencentWeibo:
            serviceType = SLServiceTypeTencentWeibo;
            break;
        case YHSnsTypeGoolePlus:
            serviceType = @"";
        default:
            break;
    }
    
    // Google Plus
    if (type == YHSnsTypeGoolePlus)
    {
        [self loginWithSnsType:YHSnsTypeGoolePlus completionSuccess:^{
            [GPPShare sharedInstance].delegate = self;
            id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            
            if (text != nil) {
                [shareBuilder setPrefillText:text];
            }
            
            if (image != nil) {
                [shareBuilder attachImage:image];
            }
            else {
                if (url != nil) {
//                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.smtown.com"]];
//                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://japan.sumstore.com"]];
//                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://prem.sumstore.com/shopping/product_view.php?goodsno=247"]];
                    [shareBuilder setURLToShare:url];
                }
            }
            
            [shareBuilder open];
        }];
        
        return;
    }
    
    // Facebook & Twitter
    if (type == YHSnsTypeFacebook || type == YHSnsTypeTwitter)
    {
        SLComposeViewController *snsPostVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        if (text != nil) {
            [snsPostVC setInitialText:text];
        }
        
        if (image != nil) {
            [snsPostVC addImage:image];
        }
        
        if (url != nil) {
            [snsPostVC addURL:url];
        }
        
        @try {
            [target presentViewController:snsPostVC animated:YES completion:completion];
        }
        @catch (NSException *exception) {
            LogRed(@"exception : %@",exception);
        }
    }
    
}

#pragma mark - System Account
- (void)loginWithSnsType:(YHSnsType)snsType
{
    if (snsType == YHSnsTypeGoolePlus)
    {
        [self GPPLogin];
    }
}

- (void)loginWithSnsType:(YHSnsType)snsType completionSuccess:(void (^)(void))success
{
    self.completionForLoginSuccess = success;
    
    [self loginWithSnsType:YHSnsTypeGoolePlus];
    
    
}

- (void)logoutWithSnsType:(YHSnsType)snsType
{
    if (snsType == YHSnsTypeGoolePlus) {
        [self GPPLogout];
    }
}

#pragma mark - System Mail
- (void)sendMailViewControllerWithTitle:(NSString *)title
                            messageBody:(NSString *)message
                                 target:(UIViewController *)target
                      completionSuccess:(void (^)(void))success
                                   fail:(void (^)(void))fail
{
    MFMailComposeViewController *sendMailVC = [[MFMailComposeViewController alloc] init];
    sendMailVC.mailComposeDelegate = (id <MFMailComposeViewControllerDelegate>)self;
    if ([MFMailComposeViewController canSendMail])
    {
        [sendMailVC setSubject:title];
        [sendMailVC setMessageBody:message isHTML:NO];
        self.completionForSendMailSuccess = success;
        self.completionForSendMailFail = fail;
    }
    else
    {
        // 메일 사용 불가능
        return;
    }
    
    [target presentViewController:sendMailVC animated:YES completion:nil];
}

// MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    // 메일 상자 닫고 콜백 처리
    [controller dismissViewControllerAnimated:YES completion:^{
        switch (result)
        {
            case MFMailComposeResultCancelled:
                LogGreen(@"MFMailComposeResultCancelled");
                break;
                
            case MFMailComposeResultSaved:
                LogGreen(@"MFMailComposeResultSaved");
                break;
                
            case MFMailComposeResultSent:
                LogGreen(@"MFMailComposeResultSent");
                if (self.completionForSendMailSuccess)  self.completionForSendMailSuccess();
                self.completionForSendMailSuccess = nil;
                
                break;
                
            case MFMailComposeResultFailed:
                LogGreen(@"MFMailComposeResultFailed");
                if (self.completionForSendMailFail)  self.completionForSendMailFail();
                self.completionForSendMailFail = nil;
                
                break;
                
            default:
                break;
        }
    }];
}


#pragma mark - Google Plus SDK
- (BOOL)GPPAuthenticatoinWithCompletion:(void(^)(void))completion
{
    BOOL hasAuth = NO;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[kGTLAuthScopePlusLogin];
    signIn.delegate = self;
    
    if (completion) {
        self.completionForLoginSuccess = completion;
    }
    
    if ([signIn hasAuthInKeychain])
    {
        [signIn trySilentAuthentication];
        
        hasAuth = YES;
        
    }
    else
    {
        hasAuth = NO;
        
        [signIn authenticate];
    }
    
    return hasAuth;
}

- (void)GPPShareContentWithText:(NSString *)text image:(UIImage *)image url:(NSURL *)url
{
    [self GPPAuthenticatoinWithCompletion:^{
        [GPPShare sharedInstance].delegate = self;
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        if (text != nil)
        {
            [shareBuilder setPrefillText:text];
        }
        if (image != nil)
        {
            [shareBuilder attachImage:image];
        }
        else
        {
            if (url != nil)
            {
                [shareBuilder setURLToShare:url];
                //                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://www.smtown.com"]];
                //                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://japan.sumstore.com"]];
                //                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://prem.sumstore.com/shopping/product_view.php?goodsno=247"]];
                
            }
        }
        
        [shareBuilder open];
    }];
}
+ (BOOL)GPPURLHandelrWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GPPURLHandler handleURL:url
           sourceApplication:sourceApplication
                  annotation:annotation];
}

- (void)GPPLogin
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    //        signIn.shouldFetchGooglePlusUser = YES;
    //        signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientID;
    signIn.scopes = @[kGTLAuthScopePlusLogin];
    signIn.delegate = self;
    
    
    if ([signIn hasAuthInKeychain])
    {
        [signIn trySilentAuthentication];
    }
    else
    {
        [signIn authenticate];
        LogRed(@"Google Plus앱 로그인 후 이용 하세요!!");
    }
}

- (void)GPPLogout
{
    [[GPPSignIn sharedInstance] signOut];
}

// SigIn Delegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    LogGreen(@"finishedWithAuth");
    if (error) {
        LogRed(@"error : %@",error);
        
        [self GPPLogout];
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YHGoogleLoginSuccessNotification object:nil];
    
    if ([GPPSignIn sharedInstance].authentication)
    {
        // 로그인 정상 완료후 동작 처리
        if (self.completionForLoginSuccess) {
            self.completionForLoginSuccess();
            self.completionForLoginSuccess = nil;
        }
    }
    else
    {
        
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    LogGreen(@"didDisconnectWithError");
    if (error)
    {
        LogRed(@"error : %@", error);
    }
}

// Share Delegate
- (void)finishedSharing:(BOOL)shared
{
    LogGreen(@"- (void)finishedSharing:(BOOL)shared : %zd",shared);
    
    if (shared)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Posted successfully!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Post error.Please try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)finishedSharingWithError:(NSError *)error
{
    if (error) {
        LogRed(@"finishedSharingWithError : %@",error);
        self.completionForLoginSuccess = nil;
    }
}
#pragma mark - Facebook SDK
+ (void)FBSDKApplicationDelegateApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
}

+ (BOOL)FBSDKApplicationDelegateApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)FBSDKLoginFromViewController:(UIViewController *)fromViewController
                             success:(void(^)(NSString *accessToken))success
                             failure:(void(^)(NSError *error))failure
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        FBSDKAccessToken *fbToken = [FBSDKAccessToken currentAccessToken];
        
        if (success) {
            success(fbToken.tokenString);
            LogGreen(@"token String : %@",fbToken.tokenString);
        }
        
    }
    else
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        
        [loginManager logInWithReadPermissions:@[@"email"]
                            fromViewController:fromViewController
                                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                           FBSDKAccessToken *accessToken = result.token;
                                           LogGreen(@"accessToken : %@",accessToken.tokenString);
                                           if (error == nil)
                                           {
                                               if (success)
                                               {
                                                   FBSDKAccessToken *accessToken = result.token;
                                                   success(accessToken.tokenString);
                                               }
                                           }
                                           else
                                           {
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }
                                       }];
    }
}

#pragma mark - Twitter SDK
+ (void)initTwitterSDK
{
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
    [Fabric with:@[[Twitter sharedInstance]]];
}

+ (void)TWTLoginWithSuccess:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session)
        {
            NSDictionary *result = @{@"userName" : [session userName],
                                     @"userID" : [session userID],
                                     @"authtoken_token":[session authToken],
                                     @"authtoken_secret":[session authTokenSecret]};
            if (success) {
                success(result);
            }
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            if (failure) {
                failure(error);
            }
        }
    }];
}

@end
