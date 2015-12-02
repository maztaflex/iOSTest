//
//  ViewController.m
//  VideoPlayer
//
//  Created by Yonghwi Nam on 2015. 11. 23..
//  Copyright © 2015년 Yonghwi Nam. All rights reserved.
//

#import "ViewController.h"

#define DEFAULT_VOLUME_VALUE                        0.062500f  // 시스템 볼륨값 단위

@import MediaPlayer;
@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoPlayContainer;

@property (weak, nonatomic) IBOutlet UIView *volumeContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *clvVolumeList;

@property (strong, nonatomic) MPMoviePlayerController *player;
@property (weak, nonatomic) AVAudioSession *audioSession;
@property (assign, nonatomic) NSInteger volumeIndex;

@end

@implementation ViewController

#pragma mark - View Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - Handler for Subviews
- (void)configureLayout
{
    // 비디오 플레이어 설정
    //
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self getContentURLInBundleWithFileName:@"sampleVideo" ext:@"mp4"]];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.shouldAutoplay = YES;
    self.player.repeatMode = MPMovieRepeatModeOne;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [self.player.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self.player prepareToPlay];
    
    // 비디오 플레이어 서브뷰 등록
    [self.videoPlayContainer addSubview:self.player.view];
    
    // 시스템 볼륨 HUD를 숨기기 위한 임시 볼륨뷰 등록 ( 해당 서브뷰가 없을 경우 시스템 볼륨 HUD 노출됨)
    self.audioSession = [AVAudioSession sharedInstance];
    NSLog(@"self.audioSession : %@",self.audioSession);
    [self.audioSession setActive:YES error:nil];
    [self.audioSession addObserver:self
                        forKeyPath:@"outputVolume"
                           options:0
                           context:nil];
    // 임시 볼륨뷰 서브뷰 등록
    MPVolumeView *volView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-2000, -2000, 0, 0)];
    [self.videoPlayContainer addSubview:volView];
}

#pragma mark - Handler for Player

// 번들 비디오 파일 URL
- (NSURL *)getContentURLInBundleWithFileName:(NSString *)fileName ext:(NSString *)ext
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    NSURL *mUrl = [NSURL fileURLWithPath:urlStr];
    
    return mUrl;
}

// 원격 비디오 파일 URL
- (NSURL *)getContentURLWithURLString:(NSString *)urlString
{
    NSURL *remoteURL = [NSURL URLWithString:urlString];
    
    NSLog(@"remoteURL : %@",remoteURL);
    
    return remoteURL;
}

#pragma mark - Handler for Volume
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    float vol = self.audioSession.outputVolume;
    
    self.volumeIndex = vol / DEFAULT_VOLUME_VALUE;
    
    NSLog(@"volumeIndex : %zd",self.volumeIndex);
    
    if ([keyPath isEqual:@"outputVolume"]) {
        
        self.volumeContainer.alpha = 1.0f;
        [self.clvVolumeList reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0f animations:^{
                self.volumeContainer.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
            }];
        });
    }
}

#pragma mark - UICollectionView Datasource, Delegate ( Custom Volume UI )
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = 8;
    
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"VolumeCell";
    
    NSInteger row = indexPath.row;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSInteger newVol = self.volumeIndex - 1;
    NSLog(@"newVol : %zd",newVol);
    
    if (newVol < 0) {
        cell.hidden = YES;
        return cell;
    }
    
    if (row <= newVol / 2)
    {
        cell.hidden = NO;
        UIImageView *indicator = [cell viewWithTag:500];
        indicator.alpha = 1.0f;
        if (row == newVol / 2)
        {
            if (newVol % 2 == 0)
            {
                indicator.alpha = 0.5f;
            }
        }
    }
    else
    {
        cell.hidden = YES;
    }
    
    return cell;
}

@end
