//
//  NewReportViewController.h
//  MyHome
//
//  Created by HuCuBi on 3/4/20.
//  Copyright © 2020 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelHome;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelReport;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthReport;
@property (weak, nonatomic) IBOutlet UIImageView *imageReport;

@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThuThang;
@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThuThangSoVoiThangTruoc;
@property (weak, nonatomic) IBOutlet UIImageView *imageDoanhThuThang;

@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiThang;
@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiSoThangTruoc;
@property (weak, nonatomic) IBOutlet UIImageView *iamgeChiPhiThang;

@property (weak, nonatomic) IBOutlet UILabel *labelDuNo;
@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThuTronDoi;

@property (weak, nonatomic) IBOutlet MyCustomView *viewReportDayHome;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewReportDayHome;

@end

NS_ASSUME_NONNULL_END
