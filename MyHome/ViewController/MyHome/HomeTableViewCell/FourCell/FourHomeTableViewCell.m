//
//  FourHomeTableViewCell.m
//  MyHome
//
//  Created by Macbook on 3/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import "FourHomeTableViewCell.h"
#import "RateView.h"
#import "Utils.h"

@implementation FourHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    RateView *viewRate = [RateView rateViewWithRating:5];
    viewRate.frame = CGRectMake(0, 0, 15, 120);
    viewRate.canRate = NO;
    viewRate.step = 1.0;
    viewRate.starFillColor = RGB_COLOR(250, 171, 28);
    viewRate.starSize = 15;
    [self.viewRate1 addSubview:viewRate];
    
    RateView *viewRate2 = [RateView rateViewWithRating:5];
    viewRate2.frame = CGRectMake(0, 0, 15, 120);
    viewRate2.canRate = NO;
    viewRate2.step = 1.0;
    viewRate2.starFillColor = RGB_COLOR(250, 171, 28);
    viewRate2.starSize = 15;
    [self.viewRate2 addSubview:viewRate2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
