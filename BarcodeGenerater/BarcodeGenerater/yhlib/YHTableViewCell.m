//
//  YHTableViewCell.m
//  SUMPreOrder
//
//  Created by DEV_TEAM1_IOS on 2015. 9. 15..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHTableViewCell.h"

@implementation YHTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _tools = [YHTools sharedInstance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
