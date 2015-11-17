//
//  ViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 17..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "DataModels.h"

@interface ViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *clMain;

@property (strong, nonatomic) FLKRecentPhotos *flkRecentPhotos;

@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.flkRecentPhotos = [[FLKRecentPhotos alloc] init];
    
    [self.flkRecentPhotos reqRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.flkRecentPhotos = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
        [self.clMain reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)confirgureLayout
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    layout.headerHeight = 15;
    layout.footerHeight = 10;
    layout.minimumColumnSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    
    self.clMain.collectionViewLayout = layout;
}

#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *thumbnailPhoto = [cell viewWithTag:501];
    CGFloat redValue = (arc4random() % 100) / 255.0f;
    CGFloat greenValue = (arc4random() % 150) / 255.0f;
    CGFloat blueValue = (arc4random() % 250) / 255.0f;
    thumbnailPhoto.backgroundColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1];
    
    [self.tools setImageToImageView:thumbnailPhoto placeholderImage:nil imageURLString:[self.flkRecentPhotos getThumbnailURLStringAtIndexPath:indexPath] isOnlyMemoryCache:NO completion:nil];
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = [self.flkRecentPhotos getSizeOfThumbnailPhotoAtIndexPath:indexPath];
    
    LogGreen(@"cell w : %f, h : %f",cellSize.width, cellSize.height);
    
    return cellSize;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    LogRed(@"- (void)didReceiveMemoryWarning");
}


@end
