//
//  ViewController.m
//  TestFacebookPop
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 17..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"

#import <POP.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *subviewContainer1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcLeadingOfSubview1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcTrailingOfSubview1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcTopOfsuvView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcWidthOfSubview1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcHeightOfSubview1;

@property (assign, nonatomic) BOOL isUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchedAnimation:(id)sender {
//    POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
//    layoutAnimation.springSpeed = 5.0f;
//    layoutAnimation.springBounciness = 20.0f;
//    layoutAnimation.toValue = @((self.isUp == YES) ? -54 : 0);
//    
//    [self.alcTopOfsuvView1 pop_addAnimation:layoutAnimation forKey:@"detailsContainerWidthAnimate"];
//    
//    POPSpringAnimation *layoutAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
//    layoutAnimation1.springSpeed = 15.0f;
//    layoutAnimation1.springBounciness = 12.0f;
//    layoutAnimation1.toValue = @((self.isUp == YES) ? 100 : 0);
//    
//    [self.alcLeadingOfSubview1 pop_addAnimation:layoutAnimation1 forKey:@"111"];
//    
//    POPSpringAnimation *layoutAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
//    layoutAnimation2.springSpeed = 5.0f;
//    layoutAnimation2.springBounciness = 20.0f;
//    layoutAnimation2.toValue = @((self.isUp == YES) ? 100 : 0);
//    
//    [self.alcTrailingOfSubview1 pop_addAnimation:layoutAnimation1 forKey:@"222"];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 54.0f;
    
    POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    layoutAnimation.springSpeed = 10.0f;
    layoutAnimation.springBounciness = 14.0f;
    layoutAnimation.toValue = @((self.isUp == YES) ? 0 : width);
    [self.alcWidthOfSubview1 pop_addAnimation:layoutAnimation forKey:@"w"];
    
    POPSpringAnimation *layoutAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    layoutAnimation1.springSpeed = 10.0f;
    layoutAnimation1.springBounciness = 14.0f;
    if (self.isUp == NO) {
        layoutAnimation1.dynamicsMass = 2.0f;
    }
    layoutAnimation1.toValue = @((self.isUp == YES) ? 0 : height);
    
    [self.alcHeightOfSubview1 pop_addAnimation:layoutAnimation1 forKey:@"h"];
    
    self.isUp = !self.isUp;
}

@end
