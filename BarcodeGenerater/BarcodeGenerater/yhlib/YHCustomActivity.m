//
//  YHCustomActivity.m
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 31..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import "YHCustomActivity.h"
#import <Social/Social.h>

@interface YHCustomActivity ()

@property (strong, nonatomic) NSString *serviceType;
@end

@implementation YHCustomActivity

- (instancetype)initWithServiceType:(NSString *)serviceType
{
    if (self = [super init]) {
        _serviceType = serviceType;
    }
    
    return self;
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    LogGreen(@"- (void)prepareWithActivityItems:(NSArray *)activityItems : %@",activityItems);
    
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.shareText = item;
        }
        
        if ([item isKindOfClass:[NSURL class]]) {
            self.shareURL = item;
        }
        
        if ([item isKindOfClass:[UIImage class]]) {
            self.shareImage = item;
        }
    }
}

- (UIViewController *)activityViewController
{
    LogGreen(@"- (UIViewController *)activityViewController");
    UIViewController *customVC = nil;
    
    if (self.serviceType == SLServiceTypeFacebook || self.serviceType == SLServiceTypeTwitter)
    {
        SLComposeViewController *snsPostVC = [SLComposeViewController composeViewControllerForServiceType:self.serviceType];
        snsPostVC.completionHandler = ^(SLComposeViewControllerResult result){
            LogGreen(@"result : %zd",result);
            if (result == SLComposeViewControllerResultCancelled) {
                
            }
            [self activityDidFinish:YES];
        };
        
        if (self.shareText != nil) {
            [snsPostVC setInitialText:self.shareText];
        }
        
        if (self.shareImage != nil) {
            [snsPostVC addImage:self.shareImage];
        }
        
        if (self.shareURL != nil) {
            [snsPostVC addURL:self.shareURL];
        }
        
        customVC = snsPostVC;
    }
    
    return customVC;
}

@end
