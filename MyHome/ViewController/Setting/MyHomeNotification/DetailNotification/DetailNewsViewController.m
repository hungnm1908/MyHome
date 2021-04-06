//
//  DetailNewsViewController.m
//  HappyLuckySale
//
//  Created by Macbook on 7/17/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController {
    BOOL isWebFirstReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.webView.scrollView.scrollEnabled = NO;
    
    self.webView.scrollView.delegate = self;
//    self.webView.navigationDelegate = self;
    
    if (self.strTitleView) {
        self.navigationItem.title = self.strTitleView;
    }else{
        self.navigationItem.title = @"Chi tiết";
    }
    
    switch (self.type) {
        case 0:
        {
            self.labelTitle.text = [self.dictItem[@"TITLE"] uppercaseString];
            self.labelTime.text = self.dictItem[@"CREATE_DATE"];
        }
            break;
            
        case 1:
        {
            self.labelTitle.text = @"Thông báo";
            self.labelTime.text = self.dictItem[@"SENT_TIME"];
        }
            break;
            
        default:
            break;
    }
    
    [self.imageItem sd_setImageWithURL:[NSURL URLWithString:[Utils convertStringUrl:self.dictItem[@"IMAGE_COVER"]]] placeholderImage:[UIImage imageNamed:@"image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *newImage = [Utils scaleImageFromImage:image scaledToSize:([UIScreen mainScreen].bounds.size.width - 32)];
        self.imageItem.image = newImage;
    }];
    
    NSString *strContentWeb = self.dictItem[@"CONTENT"];
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    NSString *htmlStr = [headerString stringByAppendingString:strContentWeb];
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.heightWebview.constant = webView.scrollView.contentSize.height;
    [self performSelector:@selector(reloadWebContent) withObject:nil afterDelay:2.0];
}

- (void)reloadWebContent {
    if (!isWebFirstReload) {
        NSString *strContentWeb = self.dictItem[@"CONTENT"];
        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
        NSString *htmlStr = [headerString stringByAppendingString:strContentWeb];
        [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        isWebFirstReload = YES;
    }
}

@end
