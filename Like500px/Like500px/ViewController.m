//
//  ViewController.m
//  Like500px
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 22..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSArray *)imageInfoList
{
    NSArray *list = nil;
    
    list = @[@{@"rw : ":@"320", @"rh":@"100"},
             @{@"rw : ":@"100", @"rh":@"70"}];
    
    return list;
}

@end
