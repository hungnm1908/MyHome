//
//  CommonWebViewController.m
//  Test365 Home
//
//  Created by HuCuBi on 7/30/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController ()

@end

@implementation CommonWebViewController {
    NSTimer *timer;
    int timeProcess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *stringUrl = @"https://test365.vn/dieu-khoan.html";
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTime];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *urlStr = url.absoluteString;
    NSLog(@"HungNmg %@",urlStr);
    return  [self processURL:urlStr];
}

- (BOOL) processURL:(NSString *) url {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"HungNmg bat dau load web");
    [SVProgressHUD show];
    [self startCallTime];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"HungNmg da load xong web");
    [SVProgressHUD dismiss];
    [self stopTime];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error : %@",error);
    [SVProgressHUD dismiss];
    [self stopTime];
}

- (void) reciveNotifi : (NSNotification *)notif {
    if ([notif.name isEqualToString:@"StationMapRefresh"]) {
        [self.webView goBack];
    }
}

- (void)startCallTime{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(showTimeProcess:)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)stopTime{
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    timeProcess = 0;
}

- (void)showTimeProcess:(NSTimer *)timer{
    timeProcess++;
    NSLog(@"thoi gian xu ly : %d",timeProcess);
    if (timeProcess > 30) {
        [self stopTime];
        [SVProgressHUD dismiss];
    }
}

@end
