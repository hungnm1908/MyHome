//
//  ThirdHomeTableViewCell.h
//  MyHome
//
//  Created by Macbook on 8/2/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThirdHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelNameItem;
@property (weak, nonatomic) IBOutlet UILabel *labelInforItem;
@property (weak, nonatomic) IBOutlet UILabel *labelCostItem;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentCostItem;
@property (weak, nonatomic) IBOutlet UIView *viewCurrentCostItem;
@property (weak, nonatomic) IBOutlet UIView *viewRate;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;

@property (weak, nonatomic) IBOutlet UIView *viewGAD;

@end

NS_ASSUME_NONNULL_END
