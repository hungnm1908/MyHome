//
//  RoomPriceListViewController.h
//  MyHome
//
//  Created by Macbook on 8/28/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomPriceListViewController : UIViewController

@property NSDictionary *dictRoom;
@property BOOL isCreate;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldGiaNgayThuong;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldGiaDacBiet;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhiDonDep;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldSoKhachTieuChuan;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldSoKhachToiDa;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhiThemNguoi;
@property (weak, nonatomic) IBOutlet UISwitch *swithAllowCancel;
@property (weak, nonatomic) IBOutlet MyButton *btnUpdate;

@property (weak, nonatomic) IBOutlet MyCustomView *viewDiscount;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldDiscountValue;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldDiscountPercent;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldStartDate;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldEndDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewDiscount;

@end

NS_ASSUME_NONNULL_END
