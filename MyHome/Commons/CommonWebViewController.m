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
    WKWebView *wkWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopTime];
}

- (void)settupWebView {
    self.labelTitle.text = self.titleView;
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    theConfiguration.allowsInlineMediaPlayback = YES;
    
    wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.viewWeb.frame.size.width, self.viewWeb.frame.size.height) configuration:theConfiguration];
    wkWebView.navigationDelegate = self;
    
    [self.viewWeb addSubview:wkWebView];
    
    wkWebView.scrollView.delegate = self;
    wkWebView.navigationDelegate = self;
    
    if (self.stringUrl) {
        NSURL *url = [NSURL URLWithString:self.stringUrl];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the WebView.
        [wkWebView loadRequest:requestObj];
    }else{
        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
        NSString *htmlStr = [headerString stringByAppendingString:self.stringContent];
        [wkWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    }
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goHome:(id)sender {
    [wkWebView goForward];
}

- (IBAction)refresh:(id)sender {
    [wkWebView reload];
}

#pragma mark WKWebView

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"HungNmg bat dau load wkWeb");
    [SVProgressHUD show];
    [self startCallTime];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"HungNmg da load xong wkWeb");
    [SVProgressHUD dismiss];
    [self stopTime];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Error wkWeb: %@",error);
    [SVProgressHUD dismiss];
    [self stopTime];
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
