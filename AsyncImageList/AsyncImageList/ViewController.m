//
//  ViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 17..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"
#import <FBLikeLayout.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *clMain;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)confirgureLayout
{
    FBLikeLayout *layout = [FBLikeLayout new];
    
    //in this case we want 3 cells per row, maximum. This is also the default value if you do not customize the layout.singleCellWidth property
    CGFloat cellWidth = (MIN(self.clMain.bounds.size.width, self.clMain.bounds.size.height)-self.clMain.contentInset.left-self.clMain.contentInset.right-8)/3.0;
    
    layout.minimumInteritemSpacing = 4;
    layout.singleCellWidth = cellWidth;
    layout.maxCellSpace = 3; //for full size cells, this parameter determines the max cell space
    
    //if you want the items size to be forced in order to have the minimumInteritemSpacing always respected. Otherwise the interitem spacing will be adapted in order to cover the complete row with cells
    layout.forceCellWidthForMinimumInteritemSpacing = YES;
    layout.fullImagePercentageOfOccurrency = 50; //this percent value determines how many times randomly the item will be full size.
    
    self.clMain.collectionViewLayout = layout;
    
    self.clMain.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
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
    
    thumbnailPhoto.image = nil;
    
    return cell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i =  indexPath.row%7;
    LogGreen(@"i : %zd",i);
    CGSize cellSize = CGSizeZero;
    switch (i) {
        case 0:
            cellSize.width = 969;
            cellSize.height = 620;
            break;
        case 1:
            cellSize.width = 300;
            cellSize.height = 1024;
            break;
            
        case 2:
            cellSize.width = 640;
            cellSize.height = 651;
            break;
        case 3:
            cellSize.width = 800;
            cellSize.height = 900;
            break;
        case 4:
            cellSize.width = 640;
            cellSize.height = 770;
            break;
        case 5:
            cellSize.width = 500;
            cellSize.height = 1500;
            break;
        case 6:
            cellSize.width = 500;
            cellSize.height = 650;
            break;
        default:
            break;
    }
    
    return cellSize;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    LogRed(@"- (void)didReceiveMemoryWarning");
}


@end
