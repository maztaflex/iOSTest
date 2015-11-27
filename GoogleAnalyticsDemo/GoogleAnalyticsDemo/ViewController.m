//
//  ViewController.m
//  GoogleAnalyticsDemo
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"
#import "GAModel.h"

@interface ViewController ()

@property (strong, nonatomic) GAModel *gaModel;

@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gaModel = [[GAModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.gaModel sendScreenName:@"Main Screen"];
    
    [self.gaModel sendGAWithCategory:@"main_action" action:@"LaunchFirstView" label:nil];
}

#pragma mark - IBActon
- (IBAction)touchedButton1:(id)sender {
    
    [self.gaModel sendScreenName:@"Main Screen"];
    
    [self.gaModel sendGAWithCategory:@"main_action" action:@"touch_button1" label:@"user_play"];
}


- (IBAction)touchedButton2:(id)sender {
    
    [self.gaModel sendScreenName:@"Main Screen"];
    
    [self.gaModel sendGAWithCategory:@"Main" action:@"touch_button2" label:@"user_play"];
    
}
@end
