//
//  YHVolumeViewController.h
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHVolumeViewController : UIViewController

/*
 * Initializes and returns a newly allocated view object with the specified frame rectangle.
 * 
 */
- (instancetype)initWithFrame:(CGRect)rect;


/* 
 * The value of between ecah indicator(cell) space
 * The default value is 1.0f
 */
@property (assign, nonatomic) CGFloat hCellSpace;


/*
 * The value of top and bottom of indicator(cell) space
 * The default value is 1.0f
 */
@property (assign, nonatomic) CGFloat vCellSpace;


/*
 * The indicator's container view background color
 * The default value is black color
 */
@property (strong, nonatomic) UIColor *opaqueBgColor;


/*
 * The indicator's container view alpha value
 * The default value is 0.5f
 */
@property (assign, nonatomic) CGFloat opaqueBgAlpha;

/*
 * The indicator color
 * The default value is white color
 */
@property (strong, nonatomic) UIColor *indicatorColor;


@end
