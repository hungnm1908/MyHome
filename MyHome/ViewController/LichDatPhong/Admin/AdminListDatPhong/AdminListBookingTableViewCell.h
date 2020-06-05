//
//  AdminListBookingTableViewCell.h
//  MyHome
//
//  Created by Macbook on 10/24/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminListBookingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelNameGuest;
@property (weak, nonatomic) IBOutlet UILabel *labelDateBook;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeBook;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusBilling;
@property (weak, nonatomic) IBOutlet UIImageView *iconLock;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusService;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateStatusBill;
@property (weak, nonatomic) IBOutlet UIButton *btnUserBook;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeBook;

@end

NS_ASSUME_NONNULL_END
