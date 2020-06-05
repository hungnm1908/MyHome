//
//  BookingInfoCustomerViewController.h
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookingInfoCustomerViewController : BaseViewController

@property NSDictionary *dictRoom;
@property NSDictionary *dictBookingDate;

@property (weak, nonatomic) IBOutlet UIImageView *imageRoomCover;
@property (weak, nonatomic) IBOutlet UILabel *labelNameRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelAddressRoom;

@property (weak, nonatomic) IBOutlet UILabel *labelStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labelStartWeekDay;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndWeekDay;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberDay;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberGuest;
@property (weak, nonatomic) IBOutlet UIStepper *stepperNumberGuest;
@property (weak, nonatomic) IBOutlet UILabel *labelNotificationMoreGuest;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNameGuest;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldEmailGuest;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhoneNumberGuest;
@property (weak, nonatomic) IBOutlet TextFiledChoseDate *textFieldDobGuest;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldCMTGuest;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddressGuest;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPriceRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceNomarDay;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceSpeacialDay;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceMoreGuest;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalSubPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSubPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberDay2;

@property (weak, nonatomic) IBOutlet UIView *viewNormalDiscount;
@property (weak, nonatomic) IBOutlet UILabel *labelNormalDiscountPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewNormalDiscount;

@property (weak, nonatomic) IBOutlet UIView *viewSpeacilDiscount;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeacilDiscountPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewSpeacilDiscount;

@end

NS_ASSUME_NONNULL_END
