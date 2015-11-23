//
//  SMPhotoViewController.m
//  GPUImageFilter
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 20..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "SMPhotoViewController.h"
#import <GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMPhotoViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;

@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *filter;
@property (strong, nonatomic) GPUImageStillCamera *stillCamera;



@end

@implementation SMPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto//AVCaptureSessionPreset640x480
                                                           cameraPosition:AVCaptureDevicePositionBack];
    self.stillCamera = [[GPUImageStillCamera alloc] init];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    self.filter = [[GPUImageFilter alloc] init];
    [self.stillCamera addTarget:self.filter];
    GPUImageView *filterView = self.gpuImageView;
    [self.filter addTarget:filterView];
    
    [self.stillCamera startCameraCapture];
}

#pragma mark - IBAction
- (IBAction)touchedShotButton:(id)sender
{
    
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        UIImage *takenImage = [[UIImage alloc] initWithData:processedJPEG];
        LogGreen(@"image size :%f, %f",takenImage.size.width, takenImage.size.height);
        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        LogGreen(@"self.stillCamera.currentCaptureMetadata  : %@",self.stillCamera.currentCaptureMetadata );
        
        [library writeImageToSavedPhotosAlbum:[takenImage CGImage] orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
            LogGreen(@"assetURL : %@",assetURL);
        }];
        
    }];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    UILabel *lbFilterTitle = [cell viewWithTag:300];
    
    lbFilterTitle.text = [NSString stringWithFormat:@"F %zd",indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(70.0f, 70.0f);
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectedRow = indexPath.row;
    
    LogGreen(@"selectedRow : %zd",selectedRow);
    [self.filter removeTarget:self.gpuImageView];
    [self.stillCamera removeTarget:self.filter];
    
    NSString *filterName = [NSString stringWithFormat:@"sample_filter_%zd",indexPath.row];
    
    LogGreen(@"filterName : %@",filterName);
    
    self.filter = [[GPUImageToneCurveFilter alloc] initWithACV:filterName];
    
    if (indexPath.row == 55) {
        GPUImageEmbossFilter *emboss = [[GPUImageEmbossFilter alloc] init];
        emboss.intensity = 2.0f;
        self.filter = emboss;
    }
    
    if (indexPath.row == 56) {
        GPUImageThresholdSketchFilter *sketcher = [[GPUImageThresholdSketchFilter alloc] init];
        self.filter = sketcher;
        
    }
    
    if (indexPath.row == 57) {
        GPUImageSketchFilter *newFileter = [[GPUImageSketchFilter alloc] init];
        self.filter = newFileter;
    }
    
    if (indexPath.row == 58) {
        GPUImageToonFilter *newFilter = [[GPUImageToonFilter alloc] init];
        self.filter = newFilter;
    }
    
    if (indexPath.row == 59) {
        GPUImageVignetteFilter *newFilter = [[GPUImageVignetteFilter alloc] init];
        self.filter = newFilter;
    }
    
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.gpuImageView];
}
@end
