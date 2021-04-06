//
//  NotificationTableViewCell.h
//  HappyLuckySale
//
//  Created by Macbook on 6/24/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end

NS_ASSUME_NONNULL_END
