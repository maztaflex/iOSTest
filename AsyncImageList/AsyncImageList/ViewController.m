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
#import "EKRecentModel.h"
#import "DataManager.h"

@interface ViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *clMain;

@property (weak, nonatomic) DataManager *dataManager;
@property (strong, nonatomic) FLKRecentPhotos *flkRecentPhotos;
@property (strong, nonatomic) EKRecentModel *ekRecentModel;

@property (strong, nonatomic) UIRefreshControl *refreshCtrl;
@property (assign, nonatomic) BOOL isRefreshingList;


@property (strong, nonatomic) NSArray *ekRecentList;

@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dataManager = [DataManager sharedInstance];
    
    self.ekRecentList = self.dataManager.ekRecentList;
    
    self.ekRecentModel = [[EKRecentModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"EK Recent Photos";
}

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

#pragma mark - Refresh Control View
- (void)addRefreshCtrlToTargetView:(UIView *)targetView
{
    self.refreshCtrl = [[UIRefreshControl alloc] init];
    [self.refreshCtrl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [targetView insertSubview:self.refreshCtrl atIndex:0];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    if (self.isRefreshingList == YES) {
        LogYellow(@"Now Refreshing!!");
        return;
    }
    
    self.isRefreshingList = YES;
    
    [self disableUIWithUsingProgressHud];
    
    [self.ekRecentModel requestRecentPhotosWithLastKey:nil
                                               Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   NSArray *list = responseObject;
                                                   NSMutableArray *mappedList = [NSMutableArray array];
                                                   for (id obj in list) {
                                                       EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
                                                       [mappedList addObject:ek];
                                                   }
                                                   
                                                   self.ekRecentList = mappedList;
                                                   self.dataManager.ekRecentList = self.ekRecentList;
                                                   [self.refreshCtrl endRefreshing];
                                                   [self.clMain reloadData];
                                                   [self enableUIWithUsingProgressHud];
                                                   self.isRefreshingList = NO;
                                                   
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   
                                                   LogRed(@"error : %@", error);
                                               }];
    
}

- (void)reqLoadMore
{
    EKRecentModel *lastModel = [self.ekRecentList lastObject];
    NSString *lastKey = lastModel.key;
    LogGreen(@"lastKey : %@",lastKey);
    [self.ekRecentModel requestRecentPhotosWithLastKey:lastKey
                                               Success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   NSArray *list = responseObject;
                                                   NSMutableArray *mappedList = [NSMutableArray array];
                                                   for (id obj in list) {
                                                       EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
                                                       [mappedList addObject:ek];
                                                   }
                                                   
                                                   [self insertNewObjects:mappedList];
                                                   
                                                   self.dataManager.ekRecentList = self.ekRecentList;
                                                   [self.refreshCtrl endRefreshing];
                                                   [self.clMain reloadData];
                                                   [self enableUIWithUsingProgressHud];
                                                   self.isRefreshingList = NO;
                                                   
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   
                                                   LogRed(@"error : %@", error);
                                               }];
}

#pragma mark - Load More
- (void)insertNewObjects:(NSArray *)objs {

    NSMutableArray *muOpenList = [[NSMutableArray alloc] initWithArray:self.ekRecentList];
    
    [muOpenList addObjectsFromArray:objs];
    NSInteger lastRow = self.ekRecentList.count - 1;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    for (NSInteger i = 1; i <= objs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow+i inSection:0];
        
        [arrIndexPath addObject:indexPath];
    }
    
    self.ekRecentList = muOpenList;
    
    [self.clMain performBatchUpdates:^{
        [self.clMain insertItemsAtIndexPaths:arrIndexPath];
    } completion:nil];
}

#pragma mark - Request
- (void)reqEkRecent
{
    [self.ekRecentModel requestRecentPhotosWithLastKey:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *list = responseObject;
        NSMutableArray *mappedList = [NSMutableArray array];
        for (id obj in list) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
            [mappedList addObject:ek];
        }
        
        self.ekRecentList = mappedList;
        
        self.dataManager.ekRecentList = self.ekRecentList;
        
        [self.clMain reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
}

#pragma mark - UICollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.ekRecentList.count;
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
    
    EKRecentModel *ekModel = self.ekRecentList[indexPath.row];

    [self.tools setImageToImageView:thumbnailPhoto
                   placeholderImage:nil
                     imageURLString:[ekModel getThumbnailURLString]
                  isOnlyMemoryCache:YES
                         completion:nil];
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeZero;
    
    EKRecentModel *ekModel = self.ekRecentList[indexPath.row];
    cellSize = [ekModel getThumbnailSize];
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    LogRed(@"- (void)didReceiveMemoryWarning");
}


@end
