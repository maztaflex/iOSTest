//
//  AppDelegate.m
//  GoogleAnalyticsDemo
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "AppDelegate.h"
#import "GAModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    GAModel *gaModel = [[GAModel alloc] init];
    [gaModel initGA];
    
    return YES;
}


@end
