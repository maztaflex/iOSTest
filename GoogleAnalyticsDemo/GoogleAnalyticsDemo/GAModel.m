//
//  GAModel.m
//  GoogleAnalyticsDemo
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "GAModel.h"
#import <Google/Analytics.h>

@implementation GAModel

- (void)initGA
{
    // 다운 받은 GoogleService-Info.plist. 파일로 부터 초기화
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
}

- (void)sendGAWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category       // 카테고리 (필수)
                                                          action:action         // 이벤트 (필수)
                                                           label:label          // 라벨 (선택)
                                                           value:nil] build]];

}

- (void)sendScreenName:(NSString *)screenName
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:screenName];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
