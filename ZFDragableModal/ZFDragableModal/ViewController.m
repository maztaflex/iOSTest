//
//  ViewController.m
//  ZFDragableModal
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 24..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "ViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "ModalViewController.h"

@interface ViewController ()

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)touchedModalButton:(id)sender
{
    ModalViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stid-modal"];
    modalVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.7f;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    
    modalVC.transitioningDelegate = self.animator;
    [self presentViewController:modalVC animated:YES completion:nil];
}


@end
