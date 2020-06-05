//
//  HistoryPaymentRentCarTableViewCell.h
//  MyHome
//
//  Created by HuCuBi on 4/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryPaymentRentCarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UILabel *labelCreateDate;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelAfterMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelNote;

@end

NS_ASSUME_NONNULL_END
