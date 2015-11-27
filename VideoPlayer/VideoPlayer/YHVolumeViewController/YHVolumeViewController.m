//
//  YHVolumeViewController.m
//  VideoPlayer
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 27..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "YHVolumeViewController.h"
#import "YHVolumeCell.h"

@import MediaPlayer;
@import AVFoundation;

#define DEFAULT_VOLUME_VALUE                    0.062500f  // Default Value of System Volume
#define DEFAULT_CONTAINER_WIDTH                 [UIScreen mainScreen].bounds.size.width
#define DEFAULT_CONTAINER_HEIGHT                18.0f
#define DEFAULT_CELL_HSPACE                     1.0f
#define DEFAULT_CELL_VSPACE                     1.0f
#define DEFAULT_INDICATOR_COUNT                 8

@interface YHVolumeViewController ()

// IBOutlet
@property (weak, nonatomic) IBOutlet UIView *volumeContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ivOpaqueBackground;
@property (weak, nonatomic) IBOutlet UICollectionView *volumeIndicatorList;

// Object Instance
@property (weak, nonatomic) AVAudioSession *audioSession;

// Data
@property (assign, nonatomic) NSInteger volumeIndex;
@property (assign, nonatomic) CGRect viewRect;
@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat hCellSpace;
@property (assign, nonatomic) CGFloat vCellSpace;

@end

@implementation YHVolumeViewController

- (instancetype)init
{
    self.viewRect = CGRectMake(0.0f, 0.0f, DEFAULT_CONTAINER_WIDTH, DEFAULT_CONTAINER_HEIGHT);
    
    return [self initWithFrame:self.viewRect];
}

- (instancetype)initWithFrame:(CGRect)rect
{
    [self setDefaultWithRect:rect];
    
    return [self initWithNibName:@"YHVolumeViewController" bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.view.frame = self.viewRect;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.volumeIndicatorList registerNib:[UINib nibWithNibName:@"YHVolumeCell" bundle:nil] forCellWithReuseIdentifier:@"VolumeCell"];
    
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setActive:YES error:nil];
    [self.audioSession addObserver:self
                        forKeyPath:@"outputVolume"
                           options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                           context:nil];
    
    // 임시 볼륨뷰 서브뷰 등록
    MPVolumeView *volView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-2000, -2000, 0, 0)];
    [self.view addSubview:volView];
}

#pragma mark - Handler for Volume
- (void)setDefaultWithRect:(CGRect)rect
{
    self.viewRect = rect;
    self.cellWidth = (rect.size.width - (DEFAULT_CELL_HSPACE * DEFAULT_INDICATOR_COUNT + 1)) / DEFAULT_INDICATOR_COUNT;
    self.cellHeight = rect.size.height - (DEFAULT_CELL_VSPACE * 2);
    self.hCellSpace = DEFAULT_CELL_HSPACE;
    self.vCellSpace = DEFAULT_CELL_VSPACE;
    self.ivOpaqueBackground.backgroundColor = [UIColor blackColor];
    self.ivOpaqueBackground.alpha = 0.5f;
    self.indicatorColor = [UIColor whiteColor];
}

- (void)setOpaqueBgColor:(UIColor *)opaqueBgColor
{
    self.ivOpaqueBackground.backgroundColor = opaqueBgColor;
}

- (void)setOpaqueBgAlpha:(CGFloat)opaqueBgAlpha
{
    self.ivOpaqueBackground.alpha = opaqueBgAlpha;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"change : %@",change);
    float vol = self.audioSession.outputVolume;
    self.volumeIndex = vol / DEFAULT_VOLUME_VALUE;
    
    if ([keyPath isEqual:@"outputVolume"]) {
        
        self.volumeContainer.alpha = 1.0f;
        [self.volumeIndicatorList reloadData];
        
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
    NSInteger itemCount = DEFAULT_INDICATOR_COUNT;
    
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"VolumeCell";
    
    NSInteger row = indexPath.row;
    
    YHVolumeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.ivVolumeIndicator.backgroundColor = self.indicatorColor;
    NSInteger newVol = self.volumeIndex - 1;
    
    if (newVol < 0) {
        cell.hidden = YES;
        return cell;
    }
    
    if (row <= newVol / 2)
    {
        cell.hidden = NO;
        cell.ivVolumeIndicator.alpha = 1.0f;
        if (row == newVol / 2)
        {
            if (newVol % 2 == 0)
            {
                cell.ivVolumeIndicator.alpha = 0.5f;
            }
        }
    }
    else
    {
        cell.hidden = YES;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(self.cellWidth, self.cellHeight);
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets inset = UIEdgeInsetsMake(self.vCellSpace, 0, self.vCellSpace, 0);
    
    return inset;
}

@end
