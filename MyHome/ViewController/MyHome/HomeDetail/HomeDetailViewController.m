//
//  HomeDetailViewController.m
//  MyHome
//
//  Created by Macbook on 8/10/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "ListImagesDetailViewController.h"
#import "BookingSelectDateViewController.h"

@interface HomeDetailViewController ()

@end

@implementation HomeDetailViewController {
    NSDictionary *dictDetail;
    NSArray *arrayImagesSlide;
    BOOL isWebFirstReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webViewContent.scrollView.delegate = self;
    self.webViewContent.navigationDelegate = self;
    
    [self getDetailHome];
    
    [self getListImageHome];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)share:(id)sender {
    NSString *strAff = [NSString stringWithFormat:@"http://onmyhome.vn/myhome.xhtml?genlink=%@",self.dictHome[@"GENLINK"]];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = strAff;
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc] initWithActivityItems:@[strAff] applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    controller.excludedActivityTypes = excludeActivities;
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:controller animated:YES completion:nil];
    }else {
        // Change Rect to position Popover
        
        // present the controller
        // on iPad, this will be a Popover
        // on iPhone, this will be an action sheet
        controller.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:controller animated:YES completion:nil];
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [controller popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popController.delegate = self;
        
        // in case we don't have a bar button as reference
        popController.sourceView = self.view;
        popController.sourceRect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0);
    }
}

- (IBAction)showImagesDetail:(id)sender {
    ListImagesDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListImagesDetailViewController"];
    vc.arrayImages = arrayImagesSlide;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)booking:(id)sender {
    [self checkThisRoom];
}

- (IBAction)sendEmail:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;

        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:self.labelEmailChuNha.text]];
        [mailCont setMessageBody:@"MyHome" isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];

    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controlle didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
 
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)phoneCall:(id)sender {
    [Utils callSupport:self.labelPhoneChuNha.text];
}

- (void)fillInfomation : (NSDictionary *)dict {
    NSDictionary *dictItem = [Utils converDictRemoveNullValue:dict];
    self.navigationItem.title = [dictItem[@"NAME"] uppercaseString];
    
    NSString *link = [dictItem[@"IMG"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    link = [Utils convertStringUrl:link];
    link = [NSString stringWithFormat:@"%@%@",kImageLink,link];
    NSURL *urlImage = [NSURL URLWithString:link];
    [self.imageCover sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *newImage = [Utils scaleImageFromImage:image scaledToSize:[UIScreen mainScreen].bounds.size.width];
        self.imageCover.image = newImage;
    }];
    
    self.labelName.text = [dictItem[@"NAME"] uppercaseString];
    self.labelAddress.text = dictItem[@"ADDRESS"];
    self.labelNameChuNha.text = dictItem[@"HOST_NAME"];
    self.labelEmailChuNha.text = dictItem[@"EMAIL"];
    self.labelPhoneChuNha.text = dictItem[@"MOBILE"];
    
    NSString *strContentWeb = dictItem[@"INFOMATION"];
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    NSString *htmlStr = [headerString stringByAppendingString:strContentWeb];
    [self.webViewContent loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    self.webViewContent.scrollView.scrollEnabled = NO;
    
    self.labelSoNguoiToiDa.text = [NSString stringWithFormat:@"%@",dictItem[@"MAX_GUEST"]];
    self.labelSoGiuongNgu.text = [NSString stringWithFormat:@"%@",dictItem[@"MAX_BED"]];
    self.labelSoPhongNgu.text = [NSString stringWithFormat:@"%@",dictItem[@"MAX_ROOM"]];
    
    self.labelPriceNormal.text = [NSString stringWithFormat:@"%@ vnđ",[Utils getPrice:dictItem]];
    self.labelPriceExtra.text = [NSString stringWithFormat:@"%@ vnđ",[Utils getPriceSpeacil:dictItem]];
    self.labelPriceMore.text = [[Utils strCurrency:dictItem[@"PRICE_EXTRA"]] stringByAppendingString:@" vnđ"];
    self.labelPriceCleanRoom.text = [[Utils strCurrency:dictItem[@"CLEAN_ROOM"]] stringByAppendingString:@" vnđ"];
   
    self.labelDiscount.text = [NSString stringWithFormat:@"%@ vnđ",[Utils strCurrency:dictItem[@"PRICE"]]];
    self.labelPrice.text = [NSString stringWithFormat:@"%@ vnđ",[Utils getPrice:dictItem]];
    
    if ([Utils isShowPromotion:dictItem]) {
        self.labelPercentSale.hidden = NO;
        self.labelPercentSale.text = [NSString stringWithFormat:@"  sale %@%c  ",dictItem[@"PERCENT"],'%'];
        self.viewDiscount.hidden = NO;
        
        self.viewDiscountExtra.hidden = NO;
        self.labelDiscountExtra.text = [[Utils strCurrency:dictItem[@"PRICE_SPECIAL"]] stringByAppendingString:@" vnđ"];
        
        self.viewDiscountNormal.hidden = NO;
        self.labelDiscountNormal.text = [[Utils strCurrency:dictItem[@"PRICE"]] stringByAppendingString:@" vnđ"];
        
        NSString *startDate = [Utils getDateFromDate:[Utils getDateFromStringDate:dictItem[@"PROMO_ST_TIME"]]];
        NSString *endDate = [Utils getDateFromDate:[Utils getDateFromStringDate:dictItem[@"PROMO_ED_TIME"]]];
        
        self.labelNoticeDiscount.text = [NSString stringWithFormat:@"\nGiảm %@%c cho các đơn đặt phòng có checkin-checkout từ %@ đến %@\n",dictItem[@"PERCENT"],'%',startDate,endDate];
    }else{
        self.labelPercentSale.hidden = YES;
        self.viewDiscount.hidden = YES;
        self.viewDiscountExtra.hidden = YES;
        self.viewDiscountNormal.hidden = YES;
        self.labelNoticeDiscount.text = @"";
    }
    self.labelMoTa.text = dictItem[@"DESCRIPTION"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    float newHeight = webView.scrollView.contentSize.height;
    self.heightWebViewContent.constant = newHeight;
    
    [self performSelector:@selector(reloadWebContent) withObject:nil afterDelay:2.0];
}

- (void)reloadWebContent {
    if (!isWebFirstReload) {
        NSString *strContentWeb = dictDetail[@"INFOMATION"];
        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
        NSString *htmlStr = [headerString stringByAppendingString:strContentWeb];
        [self.webViewContent loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        isWebFirstReload = YES;
    }
}

#pragma mark CallAPI

- (void)checkThisRoom {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"/book/check_lock" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        if ([dictData[@"STATUS"] intValue] == 0) {
            BookingSelectDateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingSelectDateViewController"];
            vc.dictRoom = self->dictDetail;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [Utils alertError:@"Thông báo" content:@"Bạn không được book nhà này" viewController:nil completion:^{
                
            }];
        }
    }];
}

- (void)getDetailHome {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/get_room_detail" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->dictDetail = dictData;
        [self fillInfomation:dictData];
    }];
}

- (void)getListImageHome {
    NSDictionary *param = @{@"USERNAME" : [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserName],
                            @"GENLINK" : self.dictHome[@"GENLINK"]
                            };
    
    [CallAPI callApiService:@"room/get_album_image" dictParam:param isGetError:NO viewController:nil completeBlock:^(NSDictionary *dictData) {
        self->arrayImagesSlide = dictData[@"INFO"];
        self.labelNumberImage.text = [NSString stringWithFormat:@"%d",(int)self->arrayImagesSlide.count];
    }];
}

@end
