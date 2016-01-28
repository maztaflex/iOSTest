//
//  YHCustomActivity.h
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 10. 31..
//  Copyright © 2015년 S.M Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCustomActivity : UIActivity

@property (strong, nonatomic) NSString *shareText;
@property (strong, nonatomic) NSURL *shareURL;
@property (strong, nonatomic) UIImage *shareImage;


- (instancetype)initWithServiceType:(NSString *)serviceType;

@end
