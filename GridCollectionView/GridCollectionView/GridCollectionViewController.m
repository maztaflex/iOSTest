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
#import "EKOriginImage.h"

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

@interface GridCollectionViewController () <UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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

@property (assign, nonatomic) BOOL isAddImage;

@end

@implementation GridCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSizeList = [NSMutableArray array];
    self.resizedList = [NSMutableArray array];
    
    [self reqEKRecent];
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
        
        for (NSInteger i = 0; i < list.count; i++) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:[list objectAtIndex:i]];
            [self.mappedList addObject:ek];
            
            [originImageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
        }
        self.imageSizeList = originImageSizeList;
        self.resizedList = [self getResizedListFromOriginSizes:originImageSizeList].mutableCopy;
        
        [self.collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
}

- (void)loadMoreImage
{
   
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    
    EKRecentModel *ekModel = self.mappedList.lastObject;
    NSString *recentKey = ekModel.key;
        
    [ekRecentModel requestRecentPhotosWithLastKey:recentKey Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *list = nil;
        if(self.isAddImage == YES)
        {
            list = @[[(NSArray *)responseObject firstObject]];
        }
        else
        {
            list = responseObject;
        }
        
        NSMutableArray *newSizeList = [NSMutableArray array];
            
        for (NSInteger i = 0; i < list.count; i++) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:list[i]];
            [self.mappedList addObject:ek];
            [self.imageSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
            [newSizeList addObject:[NSValue valueWithCGSize:CGSizeMake(ek.thumbnailImage.width.floatValue, ek.thumbnailImage.height.floatValue)]];
        }
        
        [self executeResizeImageWithData:newSizeList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];

}

- (void)executeResizeImageWithData:(NSMutableArray *)newSizeList
{
    // INPUT
    // 기존 이미지 사이즈 계산된 리스트 resizedList, 기존 이미지 원본 사이즈 리스트 : self.imageSizeList, 추가될 이미지 사이즈 리스트 : newSizeList
    // RETURN
    // NSDictionary : 재계산할 이미지 리스트 : totalCalculateList, 리로드할 collectionview의 indexPath : reloadIndexPaths, 더할 이미지의 indexPath : insertIndexPaths
    
    if(self.isAddImage)
    {
        newSizeList = @[[newSizeList firstObject]].mutableCopy;
    }
    NSDictionary *data = [self getDataForUpdateListWithResizedList:self.resizedList originSizeList:self.imageSizeList newOriginSizeList:newSizeList];
    
    NSArray *newResizedLlist = [self getResizedListFromOriginSizes:data[@"totalCalculateList"]];
    
    [self.resizedList addObjectsFromArray:newResizedLlist];
    
    [self updateListWithRecomputedSizeIndexPaths:data[@"reloadIndexPaths"] addedSizeIndexPaths:data[@"insertIndexPaths"]];

}

- (NSDictionary *)getDataForUpdateListWithResizedList:(NSMutableArray *)resizedList
                                       originSizeList:(NSMutableArray *)originSizeList
                                    newOriginSizeList:(NSMutableArray *)newOriginSizeList
{
    NSDictionary *result = nil;
    
    CGSize lastSize = [[resizedList lastObject] CGSizeValue];
    CGFloat commonHeight = kCriticalHeight;
    NSInteger resizedListCnt = resizedList.count;
    CGSize previousSize = CGSizeZero;
    
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSMutableArray *totalCalculateList = [NSMutableArray array];
    
    NSMutableArray *tempSizeList = [NSMutableArray array];
    
    // insert할 indexPath 리스트 구하기
    for(NSInteger i = resizedListCnt; i < resizedListCnt + newOriginSizeList.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [insertIndexPaths addObject:indexPath];
    }
    
    // reload할 indexPath 리스트 구하기
    if(lastSize.height > commonHeight)
    {
        for(NSInteger i = resizedListCnt - 1; i>0; i--)
        {
            previousSize = [resizedList[i] CGSizeValue];
            if(lastSize.height == previousSize.height)
            {
                [tempSizeList insertObject:originSizeList[i] atIndex:0];
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [reloadIndexPaths insertObject:reloadIndexPath atIndex:0];
                
                [resizedList removeObjectAtIndex:i];
            }
            else{
                break;
            }
            
        }
    }
    
    [totalCalculateList addObjectsFromArray:tempSizeList];
    [totalCalculateList addObjectsFromArray:newOriginSizeList];
    
    
    result = @{@"reloadIndexPaths" : reloadIndexPaths, @"insertIndexPaths" : insertIndexPaths, @"totalCalculateList" : totalCalculateList};
    
    
    
    return result;
}

// 각각 indexPath로 재계산한 이미지는 reload, 추가할 이미지는 insert
- (void)updateListWithRecomputedSizeIndexPaths:(NSArray *)recomputeSizeIndexPaths addedSizeIndexPaths:(NSArray *)addedSizeIndexPaths
{
    [self.collectionView performBatchUpdates:^{
        if(recomputeSizeIndexPaths.count != 0)
        {
            [self.collectionView reloadItemsAtIndexPaths:recomputeSizeIndexPaths];
        }
        [self.collectionView insertItemsAtIndexPaths:addedSizeIndexPaths];
        
    } completion:^(BOOL finished) {
        if(self.isAddImage == YES)
        {
        
            if(CGRectGetHeight(self.collectionView.frame) > self.collectionView.contentSize.height)
            {
                self.collectionView.contentOffset = CGPointMake(0, 0);
            }
            else
            {
                self.collectionView.contentOffset = CGPointMake(0, self.collectionView.contentSize.height - CGRectGetHeight(self.collectionView.frame));
            }
        }
        self.isAddImage = NO;
    }];
}

- (IBAction)touchedAddPhotoBtn:(id)sender {
    
    self.isAddImage = YES;
    [self loadMoreImage];
//    UIImagePickerController *imagePickController = [[UIImagePickerController alloc] init];
//    imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePickController.delegate = self;
//    imagePickController.allowsEditing = TRUE;
//    
//    [self presentViewController:imagePickController animated:YES completion:nil];
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
    
    if([thumbImg.url class] == [NSURL class])
    {
        NSString *imagePath = ((NSURL *)thumbImg.url).absoluteString;
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [ivImg setImage:image];
    }
    else
    {
        [self.tools setImageToImageView:ivImg placeholderImage:nil imageURLString:thumbImg.url isOnlyMemoryCache:NO completion:nil];
    }
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize cellSize = [(NSValue *)[self.resizedList objectAtIndex:indexPath.row] CGSizeValue];
    
//    EKRecentModel *rModel = [self.mappedList objectAtIndex:indexPath.row];
//    EKThumbnailImage *originImg = rModel.thumbnailImage;
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
    // collectionView의 contentOffset의 y좌표
    NSInteger y = scrollView.contentOffset.y;
    // collectionView의 전체 content size의 높이
    NSInteger contentHeight = scrollView.contentSize.height;
    
    // collectionView의 높이
    NSInteger clMainHeight = CGRectGetHeight(self.collectionView.frame);
    
    // 전체 content size 높이에서 collection view의 content offset의 y값을 빼면 현재 visible 영역의 y좌표 값이 나온다.
    NSInteger compareValue = (contentHeight - y);
    
    // compareValue가 collectionView의 높이와 같을 경우 스크롤이 완료됨. ex) 오차 범위는 +5, -5
    if (clMainHeight >= compareValue - 5 && clMainHeight <= compareValue + 5)
    {
        self.isAddImage = NO;
        [self loadMoreImage];
    }
}





#pragma mark - NOT USING METHOD

- (void)updateObjectWithIndexPathList:(NSArray *)indexArr
{
    NSMutableArray *muIndexArr = indexArr.mutableCopy;
    
    NSArray *lastObjectArr = @[[muIndexArr lastObject]];
    
    [muIndexArr removeLastObject];
    //    [muIndexArr removeObjectAtIndex:muIndexArr.count-2];
    //    [muIndexArr removeObjectAtIndex:muIndexArr.count-1];
    
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
    
    if([addtionalSize isKindOfClass:[NSArray class]])
    {
        
        [tempSizeList addObjectsFromArray:addtionalSize];
    }
    else
    {
        [tempSizeList addObject:(NSValue *)addtionalSize];
    }
    result = tempSizeList;
    
    
    return result;
}

- (void)insertNewObject:(NSArray *)objs {
    NSMutableArray *muOpenList = [[NSMutableArray alloc] initWithArray:self.imageSizeList];
    
    [muOpenList addObjectsFromArray:objs];
    NSInteger lastRow = self.imageSizeList.count - 1;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    
    for (NSInteger i = 1; i <= objs.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow+i inSection:0];
        
        [arrIndexPath addObject:indexPath];
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
        
        self.flkModel = [FLKRecentPhotos modelObjectWithDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}


- (NSArray *)getTotalCalculateListWithRecomputeSizeList:(NSArray *)recomputeSizeList addedSizeList:(NSArray *)addedSizeList
{
    NSArray *result = nil;
    NSMutableArray *totalCalculateSizeList = recomputeSizeList.mutableCopy;
    [totalCalculateSizeList addObjectsFromArray:addedSizeList];
    
    result = totalCalculateSizeList;
    
    return result;
    
}


- (NSMutableArray *)getRecomputeSizeListWithResizedList:(NSMutableArray *)resizedList originImageSizeList:(NSMutableArray *)imageSizeList
{
    NSMutableArray *result = [NSMutableArray array];
    
    CGSize lastSize = [[resizedList lastObject] CGSizeValue];
    CGFloat commonHeight = kCriticalHeight;
    NSInteger resizedListCnt = resizedList.count;
    CGSize previousSize = CGSizeZero;
    
    NSMutableArray *tempSizeList = [NSMutableArray array];
    
    if(lastSize.height > commonHeight)
    {
        for(NSInteger i = resizedListCnt - 1; i>0; i--)
        {
            previousSize = [resizedList[i] CGSizeValue];
            if(lastSize.height == previousSize.height)
            {
                [tempSizeList insertObject:imageSizeList[i] atIndex:0];
                [resizedList removeObjectAtIndex:i];
            }
            else{
                break;
            }
            
        }
    }
    
    result = tempSizeList;
    
    return result;
}

- (NSArray *)getIndexPathsOfRecomputeSizeList:(NSArray *)recomputeSize resizedList:(NSArray *)resizedList
{
    NSArray *result;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    
    for(NSInteger i = resizedList.count; i < resizedList.count + recomputeSize.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [arrIndexPath addObject:indexPath];
    }
    
    result = arrIndexPath;
    
    return result;
    
}

- (NSArray *)getIndexPathsOfAddedSizeList:(NSArray *)addedSizeList resizedList:(NSArray *)resizedList
{
    NSArray *result;
    
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    
    for(NSInteger i = resizedList.count; i < resizedList.count + addedSizeList.count; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [arrIndexPath addObject:indexPath];
    }
    result = arrIndexPath;
    
    return result;
}


@end
