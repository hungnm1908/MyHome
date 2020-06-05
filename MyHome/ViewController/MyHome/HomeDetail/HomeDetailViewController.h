//
//  HomeDetailViewController.h
//  MyHome
//
//  Created by Macbook on 8/10/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <InfinitePagingView.h>
#import <MessageUI/MessageUI.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDetailViewController : BaseViewController<UIScrollViewDelegate,WKNavigationDelegate, InfinitePagingViewDelegate, UIPopoverPresentationControllerDelegate,MFMailComposeViewControllerDelegate>

@property NSDictionary *dictHome;

@property (weak, nonatomic) IBOutlet UIView *viewSlideImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageCover;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelNameChuNha;
@property (weak, nonatomic) IBOutlet UILabel *labelEmailChuNha;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneChuNha;
@property (weak, nonatomic) IBOutlet WKWebView *webViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightWebViewContent;

@property (weak, nonatomic) IBOutlet UILabel *labelSoNguoiToiDa;
@property (weak, nonatomic) IBOutlet UILabel *labelSoGiuongNgu;
@property (weak, nonatomic) IBOutlet UILabel *labelMoTa;
@property (weak, nonatomic) IBOutlet UILabel *labelSoPhongNgu;

@property (weak, nonatomic) IBOutlet UILabel *labelPriceNormal;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceExtra;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceCleanRoom;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceMore;

@property (weak, nonatomic) IBOutlet UIView *viewDiscountNormal;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountNormal;
@property (weak, nonatomic) IBOutlet UIView *viewDiscountExtra;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscountExtra;
@property (weak, nonatomic) IBOutlet UILabel *labelNoticeDiscount;

@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberImage;

@property (weak, nonatomic) IBOutlet UILabel *labelPercentSale;
@property (weak, nonatomic) IBOutlet UIView *viewDiscount;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscount;

@end

NS_ASSUME_NONNULL_END
