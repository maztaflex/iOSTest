//
//  GAModel.h
//  GoogleAnalyticsDemo
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GAModel : NSObject

// GA 초기화
- (void)initGA;

// 이벤트 전송
- (void)sendGAWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label;

// 화면 이름 전송
- (void)sendScreenName:(NSString *)screenName;
@end
