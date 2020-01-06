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
                
                [self.imageItem sd_setImageWithURL:[NSURL URLWithString:[Utils convertStringUrl:self.dictItem[@"IMAGE_COVER"]]] placeholderImage:[UIImage imageNamed:@"image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    UIImage *newImage = [Utils scaleImageFromImage:image scaledToSize:([UIScreen mainScreen].bounds.size.width - 32)];
                    self.imageItem.image = newImage;
                }];
                
                UIFont *font = [UIFont systemFontOfSize:17.0];
                NSString *htmlStr = [NSString stringWithFormat:@"%@<style>body{font-family: '%@'; font-size:%fpx;color:#000000;}</style>",self.dictItem[@"CONTENT"],font.fontName,font.pointSize];
                [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
            }
            break;
            
        case 1:
        {
            self.labelTitle.text = @"Thông báo";
            self.labelTime.text = self.dictItem[@"SENT_TIME"];
            self.imageItem.image = [UIImage imageNamed:@""];
            self.labelContent.hidden = NO;
            self.labelContent.text = self.dictItem[@"CONTENT"];
            self.webView.hidden = YES;
//            UIFont *font = [UIFont systemFontOfSize:17.0];
//            NSString *htmlStr = [NSString stringWithFormat:@"%@<style>body{font-family: '%@'; font-size:%fpx;color:#000000;}</style>",self.dictItem[@"CONTENT"],font.fontName,font.pointSize];
//            [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
        }
            break;
            
        default:
            break;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.heightWebview.constant = webView.scrollView.contentSize.height;
    if (!isWebFirstReload) {
        [self.webView reload];
        isWebFirstReload = YES;
    }
}

@end
