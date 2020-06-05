//
//  RoomAmenitiesTableViewCell.m
//  MyHome
//
//  Created by Macbook on 9/20/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "RoomAmenitiesTableViewCell.h"

@implementation RoomAmenitiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeStatus:(id)sender {
    if ([self.iconCheckBox.image isEqual:[UIImage imageNamed:@"icon_check"]]) {
        self.iconCheckBox.image = [UIImage imageNamed:@"icon_uncheck"];
    }else{
        self.iconCheckBox.image = [UIImage imageNamed:@"icon_check"];
    }
}


@end
