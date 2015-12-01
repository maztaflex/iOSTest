//
//  YHVolumeViewController.h
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHVolumeViewController : UIViewController

@property (assign, nonatomic) CGFloat hCellSpace;

@property (assign, nonatomic) CGFloat vCellSpace;

@property (strong, nonatomic) UIColor *opaqueBgColor;

@property (assign, nonatomic) CGFloat opaqueBgAlpha;

@property (strong, nonatomic) UIColor *indicatorColor;

- (instancetype)initWithFrame:(CGRect)rect;

@end
