//
//  RentCarViewController.h
//  MyHome
//
//  Created by HuCuBi on 3/22/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CKCalendarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RentCarViewController : BaseViewController<CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldJourney;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldCar;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldName;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddDon;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldAddDen;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldNote;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldCost;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTypePay;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldDate;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldTime;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textFieldExtraPrice;

@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewNavigation;
@property BOOL isPresentView;

@end

NS_ASSUME_NONNULL_END
