//
//  DetailViewController.h
//  YHTest
//
//  Created by doozer on 2015. 10. 13..
//  Copyright © 2015년 DooZer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

