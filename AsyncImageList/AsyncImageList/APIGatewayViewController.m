//
//  APIGatewayViewController.m
//  AsyncImageList
//
//  Created by DEV_TEAM1_IOS on 2015. 11. 19..
//  Copyright © 2015년 DEV_TEAM1_IOS. All rights reserved.
//

#import "APIGatewayViewController.h"
#import "TESTPholarztapiClient.h"
#import "TESTPholarztImagesRequest.h"

@interface APIGatewayViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tvList;

@property (strong, nonatomic) NSArray *result;

@end

@implementation APIGatewayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AWS API Gateway";
    
    [self initializeAPIGateway];
}

- (void)initializeAPIGateway
{
    [self disableUIWithUsingProgressHud];
    TESTPholarztapiClient *client = [TESTPholarztapiClient defaultClient];
    TESTPholarztImagesRequest *req = [[TESTPholarztImagesRequest alloc] init];
    req.lastEvaluateKey = nil;
    
    [[client rootPost:req] continueWithBlock:^id(AWSTask *task) {
        if (task)
        {
            self.result = task.result;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tvList reloadData];
                
                [self enableUIWithUsingProgressHud];
            });
        }
        
        return nil;
    }];
}

#pragma mark - UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.result.count;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    TESTPholarztImagesResponse *res = self.result[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"KEY : %@",res.key];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 44.0f;
    
    return cellHeight;
}
@end
