//
//  DashBoardViewController.h
//  MyHome
//
//  Created by Macbook on 8/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressBar.h"
#import <CCDropDownMenus/CCDropDownMenus.h>
#import "BaseTabbarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashBoardViewController : BaseTabbarViewController<CCDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewKieuHienThi;
@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThuTong;

@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiBanHang;
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleChiPhiBanHang;

@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiDichVu;
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleChiPhiDichVu;

@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiKhac;
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleChiPhiKhac;

@property (weak, nonatomic) IBOutlet UILabel *labelDoanhThuTong2;
@property (weak, nonatomic) IBOutlet UILabel *labelChiPhiTong;
@property (weak, nonatomic) IBOutlet UILabel *labelLoiNhuan;
@property (weak, nonatomic) IBOutlet UITextField *textFieldReportMonth;

@property (weak, nonatomic) IBOutlet UIView *viewSoLieu;
@property (weak, nonatomic) IBOutlet UIView *viewBieuDo;

@end

NS_ASSUME_NONNULL_END
