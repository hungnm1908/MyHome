//
//  BookingPaymentViewController.m
//  MyHome
//
//  Created by Macbook on 9/21/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingPaymentViewController.h"

@interface BookingPaymentViewController ()

@end

@implementation BookingPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isPaymentClean) {
        self.labelTotalPrice.text = [NSString stringWithFormat:@"%@ VNĐ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",_totalPrice]]];
        self.labelNote.hidden = YES;
        self.labelNote.text = @"";
        
        if ([self.dictBookClean[@"KIND_OF_PAID"] intValue] == 0) {
            self.viewChangeKindOfPay.hidden = NO;
        }else{
            self.viewChangeKindOfPay.hidden = YES;
        }
    }else{
        self.labelTotalPrice.text = [NSString stringWithFormat:@"%@ VNĐ",[Utils strCurrency:[NSString stringWithFormat:@"%lld",_totalPrice*85/100]]];
        self.labelNote.hidden = NO;
        
        self.viewChangeKindOfPay.hidden = YES;
    }
    
    self.labelContent.text = self.content;
}

- (IBAction)completeBooking:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goback {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)copySTK:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.labelSTK.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (IBAction)copyContent:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.labelContent.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (IBAction)call:(id)sender {
    NSString *tel = @"tel://0981045225";
    NSURL *URL = [NSURL URLWithString:tel];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)changeKindOfPay:(id)sender {
    [Utils alert:@"Thông báo" content:@"Bạn chắc chắn muốn chuyển trạng thái thanh toán đơn đặt dọn dẹp sang TRẢ SAU?" titleOK:@"Đồng ý" titleCancel:@"Hủy bỏ" viewController:nil completion:^{
        [self selectKindOfPay];
    }];
}

- (void)selectKindOfPay {
    NSDictionary *param = @{@"USERNAME":[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"ID_BOOK_SERVICE":self.dictBookClean[@"ID_BOOK_SV"],
                            @"KD_PAID":@"1"
    };
    [CallAPI callApiService:@"book/kd_paid" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
