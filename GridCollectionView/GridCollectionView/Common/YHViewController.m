//
//  YHViewController.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHViewController.h"
#import "AppDelegate.h"

@interface YHViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) void(^alertViewCompletion)(void);

@end

@implementation YHViewController

#pragma mark - View Cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tools = [YHTools sharedInstance];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self registerLocalNotification];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self.tools == nil)
    {
        self.tools = [YHTools sharedInstance];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    [self confirgureLayout];
}

#pragma mark - Handler for Subviews
- (void)confirgureLayout{}
- (void)refreshAllUI{}
- (void)refreshAllWebView{}

#pragma mark - Handler ForUser Interaction
- (void)disableUI
{
    appDelegate.window.userInteractionEnabled = NO;
}

- (void)enableUI
{
    appDelegate.window.userInteractionEnabled = YES;
}

- (void)disableUIWithUsingProgressHud
{
    [ProgressHUD show:nil];
    [self disableUI];
}

- (void)enableUIWithUsingProgressHud
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        
        [ProgressHUD dismiss];
        
        [self enableUI];
    });
}

#pragma mark - Device Orientation
- (void)orientationChanged:(NSNotification *)notification {}

#pragma mark - Local Notification
- (void)registerLocalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCenter:) name:SMPShouldAllRefreshNotification object:nil];
}

- (void)unregisterLocalNotification
{
    LogGreen(@"- (void)unregisterLocalNotification");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handlerForNotificationCenter:(NSNotification *)notification
{
    NSString *notifyName = notification.name;
    
    if ([notifyName isEqualToString:SMPShouldAllRefreshNotification])
    {
        [self refreshAllUI];
    }
    
    if ([notifyName isEqualToString:SMPShouldAllWebViewRefreshNotification])
    {
        [self refreshAllWebView];
    }
}


#pragma mark - Animations Subviews
- (void)removeFromSuperViewWithDissolveAnimation:(UIView *)aView completion:(void (^)(void))completion
{
    [UIView animateWithDuration:1.0f animations:^{
        aView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        if(aView){
            [aView removeFromSuperview];
        }
        
        completion();
    }];
}

- (void)performAnimationCell:(UITableViewCell *)cell
{
    //1. Setup the CATransform3D structure
    CATransform3D translation;
//     translation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    translation = CATransform3DMakeTranslation(0, 480, 0);
    //rotation.m34 = 1.0/ -600;
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = translation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"translation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    
    [UIView commitAnimations];
}

- (void)performAnimationCell:(UITableViewCell *)cell isScrollUp:(BOOL)isScrollUp
{
    //1. Setup the CATransform3D structure
    CATransform3D translation;
    
    //=========================== Rotation Animation ====================================
//    translation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    translation.m34 = 1.0/ -600;
    //=========================== Rotation Animation ====================================
    
    //=========================== Fall Animation ====================================
    translation = CATransform3DMakeTranslation(0, (isScrollUp  == YES ? SCREEN_HEIGHT : -SCREEN_HEIGHT), 0);
    //=========================== Fall Animation ====================================
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = translation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"translation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    
    [UIView commitAnimations];
}


#pragma mark - Alert View
- (void)showDefaultAlertViewWithMessage:(NSString *)message confirmButtonTitle:(NSString *)buttonTitle
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:buttonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

- (void)showAlertViewWithMessage:(NSString *)message
              confirmButtonTitle:(NSString *)confirmTitle
               cancelButtonTitle:(NSString *)cancelTitle
                   confirmCompletion:(void(^)(void))confirmCompletion
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  if (confirmCompletion) {
                                                                      confirmCompletion();
                                                                  }
                                                              }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                               }];
        
        [alert addAction:cancelAction];
        [alert addAction:confirmAction];
        
        [self.parentViewController presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        self.alertViewCompletion = confirmCompletion;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:confirmTitle, nil];
        [alertView show];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.alertViewCompletion) {
            self.alertViewCompletion();
        }
    }
}

#pragma mark - Etc.
- (BOOL)isScrollUpWithScrollView:(UIScrollView *)scrollView
{
    BOOL result = NO;
    
    if([scrollView.panGestureRecognizer translationInView:scrollView.superview].y < 0) {
        result = YES;
    } else {

        result = NO;
    }
    
    return result;
}

@end
