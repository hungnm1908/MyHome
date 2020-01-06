//
//  CommonWebViewController.h
//  Test365 Home
//
//  Created by HuCuBi on 7/30/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CommonWebViewController : BaseViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
