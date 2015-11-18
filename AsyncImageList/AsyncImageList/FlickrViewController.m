//
//  FlickrViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 18..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "FlickrViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "FLKRecentPhotos.h"
#import "DataManager.h"

@interface FlickrViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *clMain;

@property (strong, nonatomic) FLKRecentPhotos *flkRecentPhotos;
@property (weak, nonatomic) NSArray *flkRecentList;
@property (strong, nonatomic) UIRefreshControl *refreshCtrl;
@property (assign, nonatomic) BOOL isRefreshingList;

@end

@implementation FlickrViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSDictionary *resObj = (NSDictionary *)[DataManager sharedInstance].flickrRecentList;
    self.flkRecentPhotos = [FLKRecentPhotos modelObjectWithDictionary:resObj];
    LogGreen(@"[DataManager sharedInstance].flickrRecentList : %@",[DataManager sharedInstance].flickrRecentList);
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Flickr Recent Photos";
}

#pragma mark - Hadler for Subviews
- (void)confirgureLayout
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.headerHeight = 15;
    layout.footerHeight = 10;
    layout.minimumColumnSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.footerHeight = 0.0f;
    layout.headerHeight = 0.0f;
    
    self.clMain.collectionViewLayout = layout;
    
    [self addRefreshCtrlToTargetView:self.clMain];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    if (self.isRefreshingList == YES) {
        LogYellow(@"Now Refreshing!!");
        return;
    }
    
    self.isRefreshingList = YES;
    
    [self disableUIWithUsingProgressHud];
    
    [self.flkRecentPhotos reqRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.flkRecentPhotos = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
        [DataManager sharedInstance].flickrRecentList = responseObject;
        
        [self.clMain reloadData];
        
        [refreshControl endRefreshing];
        
        self.isRefreshingList = NO;
        
        [self enableUIWithUsingProgressHud];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}

#pragma mark - Refresh Control View
- (void)addRefreshCtrlToTargetView:(UIView *)targetView
{
    self.refreshCtrl = [[UIRefreshControl alloc] init];
    [self.refreshCtrl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [targetView insertSubview:self.refreshCtrl atIndex:0];
}

#pragma mark - Request
- (void)reqFlickrRecent
{
    [self.flkRecentPhotos reqRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.flkRecentPhotos = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
        [DataManager sharedInstance].flickrRecentList = [self.flkRecentPhotos getRecentList];
        
        [self.clMain reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}

#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSInteger rowCount = [self.flkRecentPhotos getRecentList].count;
    LogGreen(@"rowCount : %zd",rowCount);
    
    return rowCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *thumbnailPhoto = [cell viewWithTag:501];
    CGFloat redValue = (arc4random() % 100) / 255.0f;
    CGFloat greenValue = (arc4random() % 150) / 255.0f;
    CGFloat blueValue = (arc4random() % 250) / 255.0f;
    thumbnailPhoto.backgroundColor = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:0.7];
    
    [self.tools setImageToImageView:thumbnailPhoto
                   placeholderImage:nil
                     imageURLString:[self.flkRecentPhotos getThumbnailURLStringAtIndexPath:indexPath]
                  isOnlyMemoryCache:YES
                         completion:nil];
    
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeZero;
    
    cellSize = [self.flkRecentPhotos getSizeOfThumbnailPhotoAtIndexPath:indexPath];
    
    LogGreen(@"cell w : %f, h : %f",cellSize.width, cellSize.height);
    
    return cellSize;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    LogRed(@"- (void)didReceiveMemoryWarning");
}

@end
