//
//  NewGridViewController.m
//  GridCollectionView
//
//  Created by ICT-Lab Dev.1 on 2016. 1. 11..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

#import "NewGridViewController.h"
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

@interface NewGridViewController () <UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) EKRecentModel *ekModel;
@property (strong, nonatomic) NSMutableArray *mappedList;

//============================================================================================================================================
@property (strong, nonatomic) NSMutableArray *imageSizeList;
@property (strong, nonatomic) NSMutableArray *resizedList;
//============================================================================================================================================
@property (strong, nonatomic) NSMutableArray *addMappedList;
@property (assign, nonatomic) BOOL isAddImage;
@end

@implementation NewGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSizeList = [NSMutableArray array];
    self.resizedList = [NSMutableArray array];
    self.mappedList = [NSMutableArray array];
    self.addMappedList = [NSMutableArray array];
    
    [self reqEKRecent];
}
static NSInteger idx = 0;
- (IBAction)touchedPlusButton:(id)sender {

    
    
    EKRecentModel *ekModel = [self.mappedList objectAtIndex:idx];
    EKThumbnailImage *thumbnailImg = ekModel.thumbnailImage;
    idx++;
    
    [self.imageSizeList insertObject:[NSValue valueWithCGSize:CGSizeMake(thumbnailImg.width.floatValue, thumbnailImg.height.floatValue)] atIndex:0];
    [self.addMappedList insertObject:ekModel atIndex:0];
    
    NSMutableArray *newSizeList = @[[NSValue valueWithCGSize:CGSizeMake(thumbnailImg.width.floatValue, thumbnailImg.height.floatValue)]].mutableCopy;
    
    [self executeResizeImageWithData:newSizeList];
    
    LogGreen(@"origin : %@ resizedList : %@, newSizeList : %@", self.imageSizeList, self.resizedList, newSizeList);
    
    
}

- (void)executeResizeImageWithData:(NSMutableArray *)newSizeList
{
    // INPUT
    // 기존 이미지 사이즈 계산된 리스트 resizedList, 기존 이미지 원본 사이즈 리스트 : self.imageSizeList, 추가될 이미지 사이즈 리스트 : newSizeList
    // RETURN
    // NSDictionary : 재계산할 이미지 리스트 : totalCalculateList, 리로드할 collectionview의 indexPath : reloadIndexPaths, 더할 이미지의 indexPath : insertIndexPaths
    
    newSizeList = @[[newSizeList firstObject]].mutableCopy;

    NSDictionary *data = [self getDataForUpdateListWithResizedList:self.resizedList originSizeList:self.imageSizeList newOriginSizeList:newSizeList];
    
    NSArray *newResizedList = [self getResizedListFromOriginSizes:data[@"totalCalculateList"]];
    
    for(NSValue *size in newResizedList)
    {
        [self.resizedList insertObject:size atIndex:0];
    }
    
    [self updateListWithRecomputedSizeIndexPaths:data[@"reloadIndexPaths"] addedSizeIndexPaths:data[@"insertIndexPaths"]];
    
}

- (NSDictionary *)getDataForUpdateListWithResizedList:(NSMutableArray *)resizedList
                                       originSizeList:(NSMutableArray *)originSizeList
                                    newOriginSizeList:(NSMutableArray *)newOriginSizeList
{
    NSDictionary *result = nil;
    
    CGSize firstSize = [[resizedList firstObject] CGSizeValue];
    CGFloat commonHeight = kCriticalHeight;
    NSInteger resizedListCnt = resizedList.count;
    CGSize nextSize = CGSizeZero;
    
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSMutableArray *totalCalculateList = [NSMutableArray array];
    
    NSMutableArray *tempSizeList = [NSMutableArray array];
    
    // insert할 indexPath 리스트 구하기
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [insertIndexPaths addObject:indexPath];
    
    // reload할 indexPath 리스트 구하기
    if(firstSize.height > commonHeight)
    {
        for(NSInteger i = 0; i < resizedListCnt; i++)
        {
            LogGreen(@"resizedList cnt : %zd", resizedListCnt);
            nextSize = [[resizedList firstObject] CGSizeValue];
            if(firstSize.height == nextSize.height)
            {
//                [tempSizeList addObject:originSizeList[i+1]];
                [tempSizeList insertObject:originSizeList[i+1] atIndex:0];
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [reloadIndexPaths addObject:reloadIndexPath];
                [reloadIndexPaths insertObject:reloadIndexPath atIndex:0];
                
                [resizedList removeObjectAtIndex:0];
            }
            else{
                break;
            }
            
        }
    }
    else
    {
        
    }
    [totalCalculateList addObjectsFromArray:tempSizeList];
    [totalCalculateList addObjectsFromArray:newOriginSizeList];

    
    result = @{@"reloadIndexPaths" : reloadIndexPaths, @"insertIndexPaths" : insertIndexPaths, @"totalCalculateList" : totalCalculateList};
    
    
    
    return result;
}

- (void)reqEKRecent
{
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    self.ekModel = ekRecentModel;
    self.ekModel = self.mappedList.firstObject;
    NSString *recentKey = self.ekModel.key;
    [ekRecentModel requestRecentPhotosWithLastKey:recentKey Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *list = responseObject;
        LogGreen(@"response : %@", responseObject);

        
        for (NSInteger i = 0; i < list.count; i++) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:[list objectAtIndex:i]];
            [self.mappedList addObject:ek];
//            [self.mappedList insertObject:ek atIndex:0];
        }
        
//        self.resizedList = [self getResizedListFromOriginSizes:self.imageSizeList].mutableCopy;
        
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointMake(0, 0);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
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
       
    }];
}


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

#pragma mark - UICollectionView Datasource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
//    return self.mappedList.count;
    
    return self.addMappedList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    LogGreen(@"indexPath.row : %zd", indexPath.row);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    EKRecentModel *ekRecentModel = [self.addMappedList objectAtIndex:indexPath.row];
    
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
    LogGreen(@"thumnail url : %@", thumbImg.url);
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = [(NSValue *)[self.resizedList objectAtIndex:indexPath.row] CGSizeValue];
    
        EKRecentModel *rModel = [self.addMappedList objectAtIndex:indexPath.row];
        EKThumbnailImage *originImg = rModel.thumbnailImage;
        LogGreen(@"cellSize : %f, %f ,%f",originImg.width.floatValue, originImg.height.floatValue, originImg.width.floatValue / originImg.height.floatValue);
        LogYellow(@"new cellSize : %f, %f, %f",cellSize.width, cellSize.height, cellSize.width / cellSize.height);
    
    
    
    
    return cellSize;
//    return CGSizeMake(100, 100);
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

@end
