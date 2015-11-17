//
//  ViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 17..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface ViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *clMain;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)confirgureLayout
{
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
