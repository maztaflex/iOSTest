//
//  SplashViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 18..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "SplashViewController.h"
#import "FLKRecentPhotos.h"
#import "EKRecentModel.h"
#import "DataManager.h"

#define TOTAL_TASK_COUNT                                            2

@interface SplashViewController ()

@property (strong, nonatomic) FLKRecentPhotos *flkRecentPhotos;

@property (weak, nonatomic) DataManager *dataManager;

@property (assign, nonatomic) NSInteger completeTaskCount;

@end

@implementation SplashViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dataManager = [DataManager sharedInstance];
    
    [self reqFlickrRecent];
    
    [self reqEkRecent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self disableUIWithUsingProgressHud];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unregisterLocalNotification];
}

#pragma mark - Handler for Notification Center
- (void)registerLocalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerForNotificationCenter:) name:SMPSplashViewTaskDoneNotification object:nil];
}

- (void)handlerForNotificationCenter:(NSNotification *)notification
{
    NSString *notifyName = notification.name;
    
    if ([notifyName isEqualToString:SMPSplashViewTaskDoneNotification] == YES) {
        [self enableUIWithUsingProgressHud];
    }
}

#pragma mark - Request
- (void)reqFlickrRecent
{
    __block FLKRecentPhotos *flkRecentPhotos = [[FLKRecentPhotos alloc] init];
    
    [flkRecentPhotos reqRecentPhotosWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.dataManager.flickrRecentList = responseObject;
        
        [self checkTaskCount];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogRed(@"error : %@",error);
    }];
}

- (void)reqEkRecent
{
    EKRecentModel *ekRecentModel = [[EKRecentModel alloc] init];
    [ekRecentModel requestRecentPhotosWithLastKey:nil Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *list = responseObject;
        NSMutableArray *mappedList = [NSMutableArray array];
        for (id obj in list) {
            EKRecentModel *ek = [EKRecentModel modelObjectWithDictionary:obj];
            [mappedList addObject:ek];
        }
        
        self.dataManager.ekRecentList = mappedList;
        
        [self checkTaskCount];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogRed(@"error : %@",error);
    }];
}

#pragma mark - Check Task Done
- (void)checkTaskCount
{
    self.completeTaskCount +=1;
    
    if (self.completeTaskCount == TOTAL_TASK_COUNT)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SMPSplashViewTaskDoneNotification object:nil];
    }
}
@end
