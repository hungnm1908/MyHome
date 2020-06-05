//
//  AdminListBookingCleanRoomTableViewCell.h
//  MyHome
//
//  Created by Macbook on 10/25/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminListBookingCleanRoomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelNameBook;
@property (weak, nonatomic) IBOutlet UILabel *labelCheckIn;
@property (weak, nonatomic) IBOutlet UILabel *labelCheckOut;

@property (weak, nonatomic) IBOutlet UILabel *labelGuyUpdate;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeUpdate;

@property (weak, nonatomic) IBOutlet UILabel *labelStatusService;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusBilling;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIButton *btnUpdateStatusService;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdateStatusBill;

@property (weak, nonatomic) IBOutlet UIButton *btnUserBook;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeBook;
@property (weak, nonatomic) IBOutlet UIButton *btnAssign;
@property (weak, nonatomic) IBOutlet UILabel *labelNote;

@end

NS_ASSUME_NONNULL_END
