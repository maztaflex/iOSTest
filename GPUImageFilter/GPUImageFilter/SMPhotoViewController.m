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
{
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
}

@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;

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
    
//    filter = [[GPUImageGammaFilter alloc] init];
    
//    filter = [[GPUImageAlphaBlendFilter alloc] init];
    
//    filter = [[GPUImageBulgeDistortionFilter alloc] init];
    
    filter = [[GPUImageClosingFilter alloc] init];
    
    [self.stillCamera addTarget:filter];
    GPUImageView *filterView = self.gpuImageView;
    [filter addTarget:filterView];
    
    [self.stillCamera startCameraCapture];
}

#pragma mark - IBAction
- (IBAction)touchedShotButton:(id)sender
{
    
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
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
    return 25;
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
    CGSize cellSize = CGSizeMake(50.0f, 50.0f);
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectedRow = indexPath.row;
    
    LogGreen(@"selectedRow : %zd",selectedRow);
    [filter removeTarget:self.gpuImageView];
    [self.stillCamera removeTarget:filter];
    
    GPUImageLookupFilter *adf = nil;
    GPUImageRGBFilter *rgbFilter = nil;
    switch (selectedRow) {
        case 0:
            
            filter = [[GPUImageGammaFilter alloc] init];
            
            break;
        case 1:
            filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
            break;
        case 2:
            rgbFilter = [[GPUImageRGBFilter alloc] init];
            rgbFilter.red = 0.8;
            rgbFilter.blue = 0.4;
            rgbFilter.green = 0.4;
            filter = rgbFilter;
            break;
        case 3:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
            break;
        case 4:
            filter = [[GPUImageEmbossFilter alloc] init];
            break;
        case 5:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
            break;
        case 6:
            filter = [[GPUImageLaplacianFilter alloc] init];
            break;
        case 7:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
            break;
        case 8:
            filter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 9:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
            break;
        case 10:
            filter = [[GPUImageSketchFilter alloc] init];
            break;
        case 11:
            filter = [[GPUImageSmoothToonFilter alloc] init];
            break;
        case 12:
            filter = [[GPUImageSphereRefractionFilter alloc] init];
            break;
        case 13:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
            break;
        case 14:
            filter = [[GPUImageSwirlFilter alloc] init];
            break;
        case 15:
            filter = [[GPUImageThresholdSketchFilter alloc] init];
            break;
        case 16:
            filter = [[GPUImageToonFilter alloc] init];
            break;
        case 17:
            filter = [[GPUImageVignetteFilter alloc] init];
            break;
        case 18:
            filter = [[GPUImageSoftEleganceFilter alloc] init];
            break;
        case 19:
            adf = [[GPUImageLookupFilter alloc] init];
            adf.intensity = 0.5f;
            filter = adf;
            break;
        case 20:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
            break;
        case 21:
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
            break;
        default:
            break;
    }
    
    [self.stillCamera addTarget:filter];
    [filter addTarget:self.gpuImageView];
}
@end
