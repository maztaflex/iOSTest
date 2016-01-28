//
//  ViewController.m
//  BarcodeGenerater
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 27..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

#import "ViewController.h"
#import <PureLayout/PureLayout.h>
#import <ZXingObjC.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ivBarcode;

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ViewController


- (void)updateViewConstraints
{
    if (!self.didConfigrureLayout)
    {
        [self.ivBarcode autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0f];
        [self.ivBarcode autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
        [self.ivBarcode autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
//        [self.ivBarcode autoSetDimension:ALDimensionWidth toSize:414.0];
        [self.ivBarcode autoSetDimension:ALDimensionHeight toSize:70.0f];
        
        self.didConfigrureLayout = YES;
    }
    
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ivBarcode.image = [self generateBarcodeImage];
}

- (UIImage *)generateBarcodeImage
{
    UIImage *generatedBarcodeImage = nil;
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:@"88006604934543e2"
                                  format:kBarcodeFormatCode128
                                   width:[self.tools screenWidthWithConsideredOrientation] * 3 - 40
                                  height:70*3
                           
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
        generatedBarcodeImage = [UIImage imageWithCGImage:image];
        
    } else {
        NSString *errorMessage = [error localizedDescription];
        
        LogRed(@"error : %@",errorMessage);
    }
    
    return generatedBarcodeImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
