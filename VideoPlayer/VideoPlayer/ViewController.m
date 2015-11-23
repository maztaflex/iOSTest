//
//  ViewController.m
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 23..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"

@import MediaPlayer;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoPlayContainer;

@property (strong, nonatomic) MPMoviePlayerController *player;

@end

@implementation ViewController

#pragma mark - View Cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureLayout];
}

#pragma mark - Handler for Subviews
- (void)configureLayout
{
    // Initialize video player
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self getContentURLInBundleWithFileName:@"PARTY_Music Video" ext:@"mp4"]];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    [self.player prepareToPlay];
    self.player.shouldAutoplay = YES;
    
    // Set video player view frame
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [self.player.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    [self.videoPlayContainer addSubview:self.player.view];
}

#pragma mark - Handler for Player
- (NSURL *)getContentURLInBundleWithFileName:(NSString *)fileName ext:(NSString *)ext
{
    // Get path of play file
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    NSURL *mUrl = [NSURL fileURLWithPath:urlStr];
    
    return mUrl;
}

@end
