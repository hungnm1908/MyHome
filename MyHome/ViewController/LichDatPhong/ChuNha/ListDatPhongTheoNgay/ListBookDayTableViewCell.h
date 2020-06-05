//
//  ListBookDayTableViewCell.h
//  MyHome
//
//  Created by Macbook on 10/3/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListBookDayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelNameGuset;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusBill;
@property (weak, nonatomic) IBOutlet UIButton *btnLock;


@end

NS_ASSUME_NONNULL_END
