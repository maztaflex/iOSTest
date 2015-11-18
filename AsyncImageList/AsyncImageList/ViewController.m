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
    
//    [self.tools setImageToImageView:thumbnailPhoto placeholderImage:nil imageURLString:[self.flkRecentPhotos getThumbnailURLStringAtIndexPath:indexPath] isOnlyMemoryCache:YES completion:nil];
    
    EKRecentModel *ekModel = self.ekRecentList[indexPath.row];
    LogGreen(@"[ekModel getThumbnailURLString] : %@",[ekModel getThumbnailURLString]);
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
    
//    cellSize = [self.flkRecentPhotos getSizeOfThumbnailPhotoAtIndexPath:indexPath];
    
    EKRecentModel *ekModel = self.ekRecentList[indexPath.row];
    cellSize = [ekModel getThumbnailSize];
    
    
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
