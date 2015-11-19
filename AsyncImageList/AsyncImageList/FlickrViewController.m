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

@property (assign, nonatomic) NSInteger currentPageNo;

@end

@implementation FlickrViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.currentPageNo = 1;
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
//    layout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight;
    
    self.clMain.collectionViewLayout = layout;
    
    [self addRefreshCtrlToTargetView:self.clMain];
}



#pragma mark - Refresh Control View
- (void)addRefreshCtrlToTargetView:(UIView *)targetView
{
    self.refreshCtrl = [[UIRefreshControl alloc] init];
    [self.refreshCtrl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [targetView insertSubview:self.refreshCtrl atIndex:0];
}

#pragma mark - Request
- (void)refresh:(UIRefreshControl *)refreshControl
{
    if (self.isRefreshingList == YES) {
        LogYellow(@"Now Refreshing!!");
        return;
    }
    
    self.isRefreshingList = YES;
    
    [self disableUIWithUsingProgressHud];
    
    self.currentPageNo = 1;
    [self.flkRecentPhotos reqRecentPhotosWithPageNo:self.currentPageNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

- (void)reqLoadMore
{
    self.currentPageNo +=1;
    LogGreen(@"self.currentPageNo : %zd",self.currentPageNo);
    [self.flkRecentPhotos reqRecentPhotosWithPageNo:self.currentPageNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        FLKRecentPhotos *newData = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
        [self insertNewObjects:[newData getRecentList]];
        
        [DataManager sharedInstance].flickrRecentList = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}

#pragma mark - Load More
- (void)insertNewObjects:(NSArray *)objs {
    NSArray *currentList = [self.flkRecentPhotos getRecentList];
    NSMutableArray *muOpenList = [[NSMutableArray alloc] initWithArray:currentList];
    
    [muOpenList addObjectsFromArray:objs];
    NSInteger lastRow = currentList.count - 1;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    for (NSInteger i = 1; i <= objs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow+i inSection:0];
        
        [arrIndexPath addObject:indexPath];
    }
    
    [self.flkRecentPhotos setRecentList:muOpenList];
    
    NSInteger totalCount = [self.flkRecentPhotos getRecentList].count;
    LogGreen(@"totalCount : %zd",totalCount);
    
    [self.clMain performBatchUpdates:^{
        [self.clMain insertItemsAtIndexPaths:arrIndexPath];
    } completion:nil];
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
    
    cell.tag = 600 + indexPath.row;
    
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeZero;
    
    cellSize = [self.flkRecentPhotos getSizeOfThumbnailPhotoAtIndexPath:indexPath];
    
//    LogGreen(@"cell w : %f, h : %f",cellSize.width, cellSize.height);
    
    return cellSize;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView * _Nonnull)scrollView
{
    NSInteger y = scrollView.contentOffset.y;
    NSInteger contentHeight = scrollView.contentSize.height;
    NSInteger clMainHeight = CGRectGetHeight(self.clMain.frame);
    
    LogGreen(@"- (void)scrollViewDidEndDecelerating : %zd, %zd, %zd",y,contentHeight, clMainHeight);
    NSInteger compareValue = (contentHeight - y);
    LogGreen(@"compareValue : %zd",compareValue);
    
    if (clMainHeight >= compareValue - 5 && clMainHeight <= compareValue + 5)
    {
        LogGreen(@"마지막이다!!");
        [self reqLoadMore];
    }
    else
    {
        LogGreen(@"아직 마지막이 아니다!!");
    }
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    LogRed(@"- (void)didReceiveMemoryWarning");
}

@end
