//
//  GridCollectionViewController.m
//  GridCollectionView
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 16..
//  Copyright © 2015년 doozerstage. All rights reserved....
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
@property (strong, nonatomic) NSMutableArray *resizedList;
//============================================================================================================================================
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alcBottomOfLoadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) BOOL isEndOfList;
@property (assign, nonatomic) BOOL isEndOfImageList;

@end

@implementation GridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSizeList = [NSMutableArray array];
    self.resizedList = [NSMutableArray array];
    
    [self reqEKRecent];
    LogGreen(@"contentOffset : %lf %lf", self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
}

- (void)reqEKRecent
{
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    self.ekModel = ekRecentModel;
    self.ekModel = self.imageSizeList.lastObject;
    NSString *recentKey = self.ekModel.key;
    [ekRecentModel requestRecentPhotosWithLastKey:recentKey Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *list = responseObject;
        self.mappedList = [NSMutableArray array];
        
        NSMutableArray *originImageSizeList = [NSMutableArray array];
//        for (id obj in list)
//        {
//            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
//            [self.mappedList addObject:ek];
//            [originImageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
//        }
        
        for (NSInteger i = 0; i < 31; i++) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:[list objectAtIndex:i]];
            [self.mappedList addObject:ek];
            
            [originImageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
        }
        self.imageSizeList = originImageSizeList;
        self.resizedList = [self getResizedListFromOriginSizes:originImageSizeList].mutableCopy;
        
        LogGreen(@"self.imageSizeList.lastObject.class : %@, self.resizedList.lastObject.class : %@, self.mappedList.lastObject.class : %@", [[self.imageSizeList lastObject] class], [[self.resizedList lastObject] class], [[self.mappedList lastObject] class]);
        
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
}

- (void)loadMoreImage
{
   
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    
    if(self.isEndOfList == YES)
    {
        EKRecentModel *ekModel = self.mappedList.lastObject;
        NSString *recentKey = ekModel.key;
        LogBlue(@"lastKey : %@",recentKey);
        [ekRecentModel requestRecentPhotosWithLastKey:recentKey Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//            LogBlue(@"responseObj : %@", responseObject);
            
            if(((NSArray *)responseObject).count == 0)
            {
                self.isEndOfImageList = YES;
                return ;
            }
            
            NSArray *list = responseObject;
        
            NSMutableArray *originImageSizeList = [NSMutableArray array];
        
            EKRecentModel *ek = nil;
            for (NSInteger i = 0; i < 1; i++) {
                ek = [EKRecentModel modelObjectWithDictionary:[list objectAtIndex:i]];
                [self.mappedList addObject:ek];
            
            [self.imageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
//                [originImageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
            }
            
            // 재계산할 이미지 리스트 가져오기, resizedList에서는 다시 지워줌
            NSArray *calculateList = [self getCaculateListWithAdditionalSize:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
            
            // 재계산할 이미지 리스트를 계산해서 리스트로 받음
             NSArray *newResizedList = [self getResizedListFromOriginSizes:calculateList];
            LogGreen(@"calculateList : %@ , newResizedList : %@", calculateList, newResizedList);
            
            // 재계산한 사이즈 정보를 resizedList에 저장
            [self.resizedList addObjectsFromArray:newResizedList];
            LogGreen(@"resizedList.count : %@ %zd", self.resizedList, self.resizedList.count);
            
            // 업데이트해줄 indexPath 리스트 저장
            NSArray *arrIndexPath = [self getIndexPathListOfAdditionalSizeList:calculateList AtResizedList:self.resizedList];
            LogGreen(@"arrIndexPath : %@", arrIndexPath);
            
            // indexPath 리스트로 업데이트
            [self updateObjectWithIndexPathList:arrIndexPath];
            
//            [self.resizedList addObjectsFromArray:[self getResizedListFromOriginSizes:originImageSizeList]];
//        
//            [self insertNewObject:originImageSizeList];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
            LogRed(@"error : %@",error);
        }];
    }
}

- (void)updateObjectWithIndexPathList:(NSArray *)indexArr
{
    NSMutableArray *muIndexArr = indexArr.mutableCopy;
    
    NSArray *lastObjectArr = @[[muIndexArr lastObject]];
    [muIndexArr removeLastObject];
    
    [self.collectionView performBatchUpdates:^{
        if(muIndexArr != nil)
        {
            [self.collectionView reloadItemsAtIndexPaths:muIndexArr];
        }
        [self.collectionView insertItemsAtIndexPaths:lastObjectArr];
        
    } completion:^(BOOL finished) {
        
        if(CGRectGetHeight(self.collectionView.frame) > self.collectionView.contentSize.height)
        {
            self.collectionView.contentOffset = CGPointMake(0, 0);
        }
        else
        {
            self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - CGRectGetHeight(self.collectionView.frame));
        }
        LogGreen(@"contentOffset.y : %lf, contentSize.height : %lf, collectionView.height : %lf", self.collectionView.contentOffset.y, self.collectionView.contentSize.height, CGRectGetHeight(self.collectionView.frame));
    }];
}

// 업데이트해야할 인덱스 구해서 리스트 형태로 전달
- (NSArray *)getIndexPathListOfAdditionalSizeList:(NSArray *)calculateList AtResizedList:(NSArray *)resizedList
{
    NSArray *result = nil;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    
    for(NSInteger i = resizedList.count - calculateList.count; i < resizedList.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [arrIndexPath addObject:indexPath];
    }
    
    result = arrIndexPath;
    

    return result;
}


// 다시 계산할 이미지 리스트 가져오기
- (NSArray *)getCaculateListWithAdditionalSize:(id)addtionalSize
{
    NSArray *result = [NSArray array];
    
    CGSize lastSize = [[self.resizedList lastObject] CGSizeValue];
    CGFloat commonHeight = kCriticalHeight;
    NSInteger resizedListCnt = self.resizedList.count;
    CGSize previousSize = CGSizeZero;
    
    NSMutableArray *tempSizeList = [NSMutableArray array];
    
    if(lastSize.height > commonHeight)
    {
        for(NSInteger i = resizedListCnt - 1; i>0; i--)
        {
            previousSize = [self.resizedList[i] CGSizeValue];
            if(lastSize.height == previousSize.height)
            {
                [tempSizeList insertObject:self.imageSizeList[i] atIndex:0];
                [self.resizedList removeObjectAtIndex:i];
            }
            else{
                break;
            }
            
        }
    }
    
    [tempSizeList addObject:(NSValue *)addtionalSize];
    result = tempSizeList;
    
    
    return result;
}

- (void)insertNewObject:(NSArray *)objs {
//    LogGreen(@"self.imageSizeList : %@", self.imageSizeList);
    NSMutableArray *muOpenList = [[NSMutableArray alloc] initWithArray:self.imageSizeList];
    
    [muOpenList addObjectsFromArray:objs];
    NSInteger lastRow = self.imageSizeList.count - 1;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];

    for (NSInteger i = 1; i <= objs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow+i inSection:0];
        
        [arrIndexPath addObject:indexPath];
//        LogGreen(@"indexPath : %@ row : %zd", indexPath, indexPath.row);
    }
    self.imageSizeList = muOpenList;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:arrIndexPath];
    } completion:nil];
    

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
    
    CGSize cellSize = [(NSValue *)[self.resizedList objectAtIndex:indexPath.row] CGSizeValue];
    
    EKRecentModel *rModel = [self.mappedList objectAtIndex:indexPath.row];
    EKThumbnailImage *originImg = rModel.thumbnailImage;
    
//    LogGreen(@"cellSize : %f, %f ,%f",originImg.width.floatValue, originImg.height.floatValue, originImg.width.floatValue / originImg.height.floatValue);
//    LogYellow(@"new cellSize : %f, %f, %f",cellSize.width, cellSize.height, cellSize.width / cellSize.height);
    
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
    CGFloat itemSpacing = kInterCellSpacing;
    
    return itemSpacing;
}


#pragma mark - Calculate ImageSize
- (NSArray *)getResizedListFromOriginSizes:(NSArray *)originSizes
{
    /* 첫번째 아이템 비율 계산 - ex. 아이템이 3개일때
     *
     * sw : 동일행 전체 아이템 가로 길이 합
     * rw : 원본 가로 길이
     * rh : 원본 세로 길이
     * nw : 비율 적용 가로 길이
     * r0 : 첫번째 아이템의 계산된 비율
     * cch : 동일행의 공통 높이
     * 
     * 수식1 : sw = (rw0 * r0) + (rw1 * r1) + (rw2 * r2) ...
     * 수식2 : cch = (rh0 * r0) = (rh1 * r1) = (rh2 * r2) ...
     * 수식3 :
     *                                   sw * rh1 * rh2                                 r0 * rh0           r0 * rh0
     *        r0 = ------------------------------------------------------------ , r1 = ----------- , r2 = ----------- ...
     *              (rw0 * rh1 * rh2) + (rw1 * rh2 * rh0) + (rw2 * rh0 * rh1)              rh1                rh2
     *
     *
     */
    
    NSMutableArray *resizedList = [NSMutableArray array];               // 리사이즈 완료된 사이즈 저장 리스트
    NSMutableArray *sizeListForCalculate = [NSMutableArray array];      // 리사이즈 계산을 위한 사이즈 임시 리스트
    
    BOOL isCompleteCalculate = NO;                                      // 각 행의 계산 완료 상태값
    NSInteger itemIdx = 0;                                              // 각 행의 계산을 위한 원본 아이템의 시작 인덱스
    
    NSInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;  // sw
    CGFloat criticalHeight = kCriticalHeight;                           // ch
    CGFloat cal1 = 1.0f;                                                // sw * rh1 * rh2
    CGFloat cal2 = 0.0f;                                                // (rw0 * rh1 * rh2) + (rw1 * rh2 * rh0) + (rw2 * rh0 * rh1)
    CGFloat firstRatio = 1.0f;                                          // r0
    CGFloat nextRatio = 1.0f;                                           // r1, r2, r3 ...
    CGFloat commonHeightPerRow = 0.0f;                                  // cch
    
    // 임시 리스트에 첫번재 아이템 저장
    [sizeListForCalculate addObject:[originSizes objectAtIndex:itemIdx]];
    
    // 원본 아이템의 수와 리사이즈된 아이템의 수가 일치 할때 까지 반복
    while (resizedList.count != originSizes.count)
    {
        for (NSInteger i = 0; i < sizeListForCalculate.count; i++)
        {
            CGSize imgSize = CGSizeZero;
            CGSize firstSize = [(NSValue *)[sizeListForCalculate firstObject] CGSizeValue];
            
            cal1 = screenWidth - (kLeftCellMargin + ((sizeListForCalculate.count - 1) * kInterCellSpacing) + kRightCellMargin);
            for (NSInteger j = 1; j <= sizeListForCalculate.count - 1; j++)
            {
                imgSize = [(NSValue *)[sizeListForCalculate objectAtIndex:j] CGSizeValue];
                cal1 = cal1 * imgSize.height;
            }
            
            cal2 = CGFLOAT_MIN;
            for (NSInteger k = 0; k < sizeListForCalculate.count; k++)
            {
                imgSize = [(NSValue *)sizeListForCalculate[k] CGSizeValue];
                CGFloat widthForCalculate = imgSize.width;
                
                for (NSInteger p = 0; p < sizeListForCalculate.count; p++) {
                    imgSize = [(NSValue *)sizeListForCalculate[p] CGSizeValue];
                    
                    if (k != p) {
                        widthForCalculate = widthForCalculate * imgSize.height;
                    }
                }
                
                cal2 += widthForCalculate;
            }
        
            // r0 = (sw * rh1 * rh2) / (rw0 * rh1 * rh2) + (rw1 * rh2 * rh0) + (rw2 * rh0 * rh1)
            firstRatio = cal1 / cal2;
            
            // cch = r0 * rh0
            commonHeightPerRow = firstRatio * firstSize.height;
            
            if (commonHeightPerRow < criticalHeight)
            {
                isCompleteCalculate = YES;
            }
            else
            {
                if ([self isExistItem:originSizes atIndex:itemIdx+1] == NO)
                {
                    isCompleteCalculate = YES;
                }
                else
                {
                    isCompleteCalculate = NO;
                }
            }
            
            // 리사이즈된 정보 리스트에 저장
            if (isCompleteCalculate == YES)
            {
                NSInteger totalWidth = 0; // 각 아이템의 width 누적값
                for (NSInteger v = 0; v < sizeListForCalculate.count; v++)
                {
                    imgSize = [(NSValue *)[sizeListForCalculate objectAtIndex:v] CGSizeValue];
                    
                    if (v != 0) {
                        nextRatio = firstSize.height * firstRatio / imgSize.height;
                    }
                    else
                    {
                        nextRatio = firstRatio;
                    }
                    
                    NSInteger combinedCellWidth = screenWidth - (kLeftCellMargin + ((sizeListForCalculate.count - 1) * kDefaultMargin) + kRightCellMargin);
                    NSInteger resizedWidth = imgSize.width * nextRatio;
//                    LogGreen(@"idx : %zd, r : %f, cch : %f",v, nextRatio, commonHeightPerRow);
                    totalWidth += resizedWidth;
                    
                    // 소수점 계산으로 인해 자동 개행되는 것을 방지 하기 위해 누적 width 값과 screenWidth에서 마진을 제거한 값이 일치 하지 않을 경우 마지막 아이템의 width 값 수정 처리
                    if ((v == sizeListForCalculate.count - 1 ) && (totalWidth != combinedCellWidth))
                    {
                        resizedWidth = resizedWidth + (combinedCellWidth - totalWidth);
                    }
                    
                    [resizedList addObject:[NSValue valueWithCGSize:CGSizeMake(resizedWidth, commonHeightPerRow)]];
                }
                
                // 다음 행 계산을 위한 임시 리스트 초기화
                [sizeListForCalculate removeAllObjects];
            }
            
            if ([self isExistItem:originSizes atIndex:itemIdx+1] == YES)
            {
                itemIdx += 1;
                [sizeListForCalculate addObject:[originSizes objectAtIndex:itemIdx]];
            }
        }
    }
    
    return resizedList;
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

- (void)scrollViewDidEndDecelerating:(UIScrollView * _Nonnull)scrollView
{
//    [self showLoadingImage];
    
    if(self.isEndOfImageList == NO)
    {
        [self loadMoreImage];
    }
    
//    LogGreen(@"contentOffset : %lf %lf", self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(velocity.y > 0)
    {
        self.isEndOfList = YES;
    }else{
        self.isEndOfList = NO;
    }
}

//- (void)showLoadingImage
//{
//    self.alcBottomOfLoadingView.constant = 0;
//    
//    [self.activityIndicator startAnimating];
//}

@end
