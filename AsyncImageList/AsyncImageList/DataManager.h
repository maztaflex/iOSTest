//
//  DataManager.h
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 18..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (strong, nonatomic) id flickrRecentList;
@property (strong, nonatomic) id ekRecentList;

+ (DataManager *)sharedInstance;

@end
