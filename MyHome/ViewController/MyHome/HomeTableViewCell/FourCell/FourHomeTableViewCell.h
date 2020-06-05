//
//  FourHomeTableViewCell.h
//  MyHome
//
//  Created by Macbook on 3/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FourHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem1;
@property (weak, nonatomic) IBOutlet UILabel *labelNameItem1;
@property (weak, nonatomic) IBOutlet UILabel *labelInforItem1;
@property (weak, nonatomic) IBOutlet UILabel *labelCostItem1;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentCostItem1;
@property (weak, nonatomic) IBOutlet UIView *viewCurrentCostItem1;
@property (weak, nonatomic) IBOutlet UIView *viewRate1;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent1;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance1;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem2;
@property (weak, nonatomic) IBOutlet UILabel *labelNameItem2;
@property (weak, nonatomic) IBOutlet UILabel *labelInforItem2;
@property (weak, nonatomic) IBOutlet UILabel *labelCostItem2;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentCostItem2;
@property (weak, nonatomic) IBOutlet UIView *viewCurrentCostItem2;
@property (weak, nonatomic) IBOutlet UIView *viewRate2;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent2;
@property (weak, nonatomic) IBOutlet UILabel *labelBalance2;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail2;

@end

NS_ASSUME_NONNULL_END
