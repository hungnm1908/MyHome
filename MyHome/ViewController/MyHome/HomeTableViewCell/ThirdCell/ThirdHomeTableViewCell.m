//
//  ThirdHomeTableViewCell.m
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "ThirdHomeTableViewCell.h"
#import "RateView.h"
#import "Utils.h"

@implementation ThirdHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    RateView *viewRate = [RateView rateViewWithRating:5];
    viewRate.frame = CGRectMake(0, 0, 15, 120);
    viewRate.canRate = NO;
    viewRate.step = 1.0;
    viewRate.starFillColor = RGB_COLOR(250, 171, 28);
    viewRate.starSize = 15;
    [self.viewRate addSubview:viewRate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
