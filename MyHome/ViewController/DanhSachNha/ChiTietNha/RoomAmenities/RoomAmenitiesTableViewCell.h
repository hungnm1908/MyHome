//
//  RoomAmenitiesTableViewCell.h
//  MyHome
//
//  Created by Macbook on 9/20/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomAmenitiesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconAmenities;
@property (weak, nonatomic) IBOutlet UILabel *labelAmentities;
@property (weak, nonatomic) IBOutlet UIImageView *iconCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeStatus;

@end

NS_ASSUME_NONNULL_END
