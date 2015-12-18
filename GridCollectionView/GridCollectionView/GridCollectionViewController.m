//
//  GridCollectionViewController.m
//  GridCollectionView
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 16..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

#import "GridCollectionViewController.h"
#import "FLKRecentPhotos.h"
#import "EKRecentModel.h"
#import "EKThumbnailImage.h"

#import <FBLikeLayout.h>

@interface GridCollectionViewController () <UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) FLKRecentPhotos *flkModel;
@property (strong, nonatomic) EKRecentModel *ekModel;
@property (strong, nonatomic) NSMutableArray *mappedList;

@end

@implementation GridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reqEKRecent];
    
    FBLikeLayout *layout = [FBLikeLayout new];
    
    //in this case we want 3 cells per row, maximum. This is also the default value if you do not customize the layout.singleCellWidth property
    CGFloat cellWidth = (MIN(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)-self.collectionView.contentInset.left-self.collectionView.contentInset.right-8)/5.0;
    
    layout.minimumInteritemSpacing = 4;
    layout.singleCellWidth = cellWidth;
    layout.maxCellSpace = 3; //for full size cells, this parameter determines the max cell space
    
    //if you want the items size to be forced in order to have the minimumInteritemSpacing always respected. Otherwise the interitem spacing will be adapted in order to cover the complete row with cells
    layout.forceCellWidthForMinimumInteritemSpacing = YES;
    layout.fullImagePercentageOfOccurrency = 25; //this percent value determines how many times randomly the item will be full size.
    
    self.collectionView.collectionViewLayout = layout;
}

- (void)reqEKRecent
{
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    self.ekModel = ekRecentModel;
    [ekRecentModel requestRecentPhotosWithLastKey:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *list = responseObject;
        
        LogGreen(@"list : %@",list);
        
        self.mappedList = [NSMutableArray array];
        
        for (id obj in list) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
            [self.mappedList addObject:ek];
        }
        
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
}

- (void)reqFLKRecent
{
    self.flkModel = [[FLKRecentPhotos alloc] init];
    
    [self.flkModel reqRecentPhotosWithPageNo:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LogGreen(@"responseObject : %@",responseObject);
        
        self.flkModel = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.mappedList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    EKRecentModel *ekRecentModel = [self.mappedList objectAtIndex:indexPath.row];
    
    EKThumbnailImage *thumbImg = ekRecentModel.thumbnailImage;
    UIImageView *ivImg = [cell viewWithTag:300];
    
    [self.tools setImageToImageView:ivImg placeholderImage:nil imageURLString:thumbImg.url isOnlyMemoryCache:NO completion:nil];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeZero;
    
    EKRecentModel *ekRecentModel = [self.mappedList objectAtIndex:indexPath.row];
    
    EKThumbnailImage *thumbImg = ekRecentModel.thumbnailImage;
    
    cellSize = CGSizeMake(thumbImg.width.floatValue / 3, thumbImg.height.floatValue / 3);
    
    LogGreen(@"cellSize : %f, %f",cellSize.width, cellSize.height);
    
    return cellSize;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
