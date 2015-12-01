//
//  SecondViewController.m
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "SecondViewController.h"
#import "YHVolumeViewController.h"

@interface SecondViewController ()

@property (strong, nonatomic) YHVolumeViewController *volumeVC;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.volumeVC = [[YHVolumeViewController alloc] init];

//    self.volumeVC = [[YHVolumeViewController alloc] initWithFrame:CGRectMake(0, 0, 414, 20)];
//    self.volumeVC.hCellSpace = 3.0f;
//    self.volumeVC.vCellSpace = 2.0f;
//    self.volumeVC.opaqueBgColor = [UIColor redColor];
//    self.volumeVC.opaqueBgAlpha = 1.0f;
//    self.volumeVC.indicatorColor = [UIColor yellowColor];
    
    
    [self.view addSubview:self.volumeVC.view];
}


@end
