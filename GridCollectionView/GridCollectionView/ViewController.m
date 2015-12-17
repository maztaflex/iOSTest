//
//  ViewController.m
//  GridCollectionView
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 16..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

#import "ViewController.h"
#import <PureLayout.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *yelloView;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ViewController


- (void)updateViewConstraints{
    LogGreen(@"self.didSetupConstraints : %zd",self.didSetupConstraints);
//    LogGreen(@"self.subViwe trans : %zd",self.subView.translatesAutoresizingMaskIntoConstraints);
//    LogGreen(@"self.yellow trans : %zd",self.yelloView.translatesAutoresizingMaskIntoConstraints);
    if (!self.didSetupConstraints)
    {
        [self.subView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
        [self.subView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        [self.subView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [self.subView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        
        [self.yelloView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.subView withOffset:30.0f];
        [self.yelloView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.subView withOffset:-10.0f];
        [self.yelloView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.subView withOffset:10.0f];
        
        CGFloat yellowWidth = [self.tools screenWidthWithConsideredOrientation] / 2.0f;
        LogGreen(@"yellowWidth : %f",yellowWidth);
        [self.yelloView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.subView withOffset:-yellowWidth];
        
        LogGreen(@"[self.tools screenWidthWithConsideredOrientation] : %f",[self.tools screenWidthWithConsideredOrientation]);
        
        
//
//        [self.yelloView autoSetDimension:ALDimensionWidth toSize:yellowWidth];
        
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LogGreen(@"self.subViwe trans : %zd",self.subView.translatesAutoresizingMaskIntoConstraints);
    
    LogGreen(@"self.yellow trans : %zd",self.yelloView.translatesAutoresizingMaskIntoConstraints);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LogGreen(@"self.yellowView.width : %f",CGRectGetWidth(self.yelloView.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)orientationChanged:(NSNotification *)notification
{
    LogGreen(@"- (void)orientationChanged:(NSNotification *)notification");
    self.didSetupConstraints = NO;
    
    [self updateViewConstraints];
}

@end
