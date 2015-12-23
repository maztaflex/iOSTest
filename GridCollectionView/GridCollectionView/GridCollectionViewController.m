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

//============================================================================================================================================
// 비율이 적용된 공통 이미지 셀의 높이, 해당 값을 기준으로 개행 결정
#define kCriticalHeight                             100.0f

// 동일 행에 최대 삽입 가능한 셀의 수 (!현재 미사용)
#define kMaxCellCountPerRow                         5

// 기본 여백값
#define kDefaultMargin                              2.0f

// 셀과 셀 사이 여백
#define kInterCellSpacing                           kDefaultMargin

// 좌측끝 셀 여백
#define kLeftCellMargin                             kDefaultMargin

// 우측끝 셀 여백
#define kRightCellMargin                            kDefaultMargin

// 셀 라인 여백
#define kCellLineSpacing                            kDefaultMargin
//============================================================================================================================================

@interface GridCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) FLKRecentPhotos *flkModel;
@property (strong, nonatomic) EKRecentModel *ekModel;
@property (strong, nonatomic) NSMutableArray *mappedList;

//============================================================================================================================================
@property (strong, nonatomic) NSMutableArray *imageSizeList;
@property (strong, nonatomic) NSMutableArray *calImageSizeList;
@property (assign, nonatomic) CGFloat sw;
//============================================================================================================================================

@end

@implementation GridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSizeList = [NSMutableArray array];
    
    [self reqEKRecent];
}

- (void)reqEKRecent
{
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    self.ekModel = ekRecentModel;
    [ekRecentModel requestRecentPhotosWithLastKey:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *list = responseObject;
        self.mappedList = [NSMutableArray array];
        
        for (id obj in list)
        {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
            [self.mappedList addObject:ek];
            
            [self.imageSizeList addObject:ek.thumbnailImage];
        }
        
        [self gernerateResizedCell];
        
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

#pragma mark - UICollectionView Datasource & Delegate
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
    
    EKThumbnailImage *thumbImg = [self.calImageSizeList objectAtIndex:indexPath.row];
    EKRecentModel *rModel = [self.mappedList objectAtIndex:indexPath.row];
    EKThumbnailImage *originImg = rModel.thumbnailImage;
    
    cellSize = CGSizeMake(thumbImg.width.integerValue, thumbImg.height.integerValue);
    
    LogGreen(@"cellSize : %zd, %zd / new cellSize : %f, %f",originImg.width.integerValue, originImg.height.integerValue, cellSize.width, cellSize.height);
    
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(kDefaultMargin, kDefaultMargin, kDefaultMargin, kDefaultMargin);
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat lineSpacing = kCellLineSpacing;
    
    return lineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemSpacing = kDefaultMargin;
    
    return itemSpacing;
}


#pragma mark - Calculate ImageSize
- (void)gernerateResizedCell
{
    self.calImageSizeList = [NSMutableArray array];
    self.sw = [self.tools screenWidthWithConsideredOrientation];
    
    NSMutableArray *tempImageSizeList = [NSMutableArray array];
    LogGreen(@"self.imageSizeList : %@",self.imageSizeList);
    LogGreen(@"self.sw : %f",self.sw);
    
    NSInteger itemIdx = 0;
    
    [tempImageSizeList addObject:[self.imageSizeList objectAtIndex:itemIdx]];
    
    CGFloat cal1 = 1.0f;
    CGFloat cal2 = 0.0f;
    CGFloat r = 1.0f;
    CGFloat cch = 0.0f;
    
    while (self.calImageSizeList.count != self.imageSizeList.count)
    {
        for (NSInteger i = 0; i < tempImageSizeList.count; i++)
        {
            
            EKThumbnailImage *th = nil;
            if (tempImageSizeList.count == 1)
            {
                th = [tempImageSizeList objectAtIndex:i];
                cal1 = self.sw - (kLeftCellMargin + kRightCellMargin);
                cal2 = th.width.floatValue;
            }
            else
            {
                cal1 = self.sw - (kLeftCellMargin + ((tempImageSizeList.count - 1) * kInterCellSpacing) + kRightCellMargin);
                cal2 = 0;
                for (NSInteger j = 1; j <= tempImageSizeList.count - 1; j++) {
                    th = [tempImageSizeList objectAtIndex:j];
                    cal1 = cal1 * th.height.floatValue;
                }
                
                for (NSInteger k = 0; k < tempImageSizeList.count; k++)
                {
                    th = tempImageSizeList[k];
                    CGFloat rw = th.width.floatValue;
                    
                    for (NSInteger p = 0; p < tempImageSizeList.count; p++) {
                        th = tempImageSizeList[p];
                        
                        if (k != p) {
                            rw = rw * th.height.floatValue;
                        }
                    }
                    
                    cal2 += rw;
                }
            }
            
            LogGreen(@"idx : %zd, rw : %f, rh : %f",i,th.width.floatValue, th.height.floatValue );
            r = cal1 / cal2;
            LogGreen(@"cal1 : %f, cal2 : %f",cal1, cal2);
            LogGreen(@"r : %f",r);
            cch = r * th.height.floatValue;
            LogGreen(@"cch : %f",cch);
            
            if (cch < kCriticalHeight)
            {
                NSInteger totalWidth = 0;
                EKThumbnailImage *firstTh = [tempImageSizeList firstObject];
                for (NSInteger v = 0; v < tempImageSizeList.count; v++)
                {
                    CGFloat nr = 1.0f;
                    th = [tempImageSizeList objectAtIndex:v];
                    
                    if (v != 0) {
                        nr = firstTh.height.floatValue * r / th.height.floatValue;
                    }
                    else
                    {
                        nr = r;
                    }
                    LogGreen(@"nr : %f",nr);
                    EKThumbnailImage *resizedTh = [[EKThumbnailImage alloc] init];
                    NSInteger deviceWidth = self.sw - (kLeftCellMargin + ((tempImageSizeList.count - 1) * kDefaultMargin) + kRightCellMargin);
                    NSInteger resizedWidth = th.width.floatValue * nr;
                    NSInteger resizedHeight = th.height.floatValue * nr;
                    totalWidth += resizedWidth;
                    if ((v == tempImageSizeList.count - 1 ) && (totalWidth != deviceWidth)) {
                        resizedWidth = resizedWidth + (deviceWidth - totalWidth);
                    }
                    resizedTh.width = [NSString stringWithFormat:@"%zd",resizedWidth];
                    resizedTh.height = [NSString stringWithFormat:@"%zd",resizedHeight];
                    
                    [self.calImageSizeList addObject:resizedTh];
                }
                
                if ([self isExistItem:self.imageSizeList atIndex:itemIdx+1] == YES)
                {
                    itemIdx += 1;
                    [tempImageSizeList removeAllObjects];
                    [tempImageSizeList addObject:[self.imageSizeList objectAtIndex:itemIdx]];
                }
            }
            else
            {
                LogGreen(@"itemIdx : %zd",itemIdx);
                if ([self isExistItem:self.imageSizeList atIndex:itemIdx+1] == YES)
                {
                    itemIdx += 1;
                    [tempImageSizeList addObject:[self.imageSizeList objectAtIndex:itemIdx]];
                }
                else
                {
                    NSInteger totalWidth = 0;
                    EKThumbnailImage *firstTh = [tempImageSizeList firstObject];
                    for (NSInteger v = 0; v < tempImageSizeList.count; v++)
                    {
                        CGFloat nr = 1.0f;
                        th = [tempImageSizeList objectAtIndex:v];
                        
                        if (v != 0) {
                            nr = firstTh.height.floatValue * r / th.height.floatValue;
                        }
                        else
                        {
                            nr = r;
                        }
                        LogGreen(@"nr : %f",nr);
                        EKThumbnailImage *resizedTh = [[EKThumbnailImage alloc] init];
                        
                        NSInteger deviceWidth = self.sw - (kLeftCellMargin + ((tempImageSizeList.count - 1) * kDefaultMargin) + kRightCellMargin);
                        NSInteger resizedWidth = th.width.floatValue * nr;
                        NSInteger resizedHeight = th.height.floatValue * nr;
                        totalWidth += resizedWidth;
                        if ((v == tempImageSizeList.count - 1 ) && (totalWidth != deviceWidth)) {
                            resizedWidth = resizedWidth + (deviceWidth - totalWidth);
                        }
                        resizedTh.width = [NSString stringWithFormat:@"%zd",resizedWidth];
                        resizedTh.height = [NSString stringWithFormat:@"%zd",resizedHeight];
                        
                        [self.calImageSizeList addObject:resizedTh];
                    }
                }
            }
        }
    }
}

- (BOOL)isExistItem:(NSArray *)arr atIndex:(NSInteger)idx
{
    BOOL result = NO;
    @try {
        [arr objectAtIndex:idx];
        result = YES;
    }
    @catch (NSException *exception) {
        result = NO;
    }
    
    return result;
}

@end
