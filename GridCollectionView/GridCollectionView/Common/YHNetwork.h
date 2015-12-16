//
//  YHNetwork.h
//
//  Created by DEV_TEAM1_IOS on 2015. 9. 14..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface YHNetwork : AFHTTPRequestOperationManager

+ (YHNetwork *)sharedInstance;

@end
