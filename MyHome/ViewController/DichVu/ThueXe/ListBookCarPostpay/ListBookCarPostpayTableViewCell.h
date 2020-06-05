//
//  ListBookCarPostpayTableViewCell.h
//  MyHome
//
//  Created by HuCuBi on 5/2/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListBookCarPostpayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCodeBooking;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelNameBooker;
@property (weak, nonatomic) IBOutlet UILabel *labelHanhTrinh;
@property (weak, nonatomic) IBOutlet UILabel *labelTypeCar;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCustomer;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneCustomer;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBtnAccept;

@end

NS_ASSUME_NONNULL_END
