//
//  CommonWebViewController.h
//  Test365 Home
//
//  Created by HuCuBi on 7/30/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface CommonWebViewController : BaseViewController<UIScrollViewDelegate,WKNavigationDelegate>

@property NSString *stringUrl;
@property NSString *titleView;
@property NSString *stringContent;

@property (weak, nonatomic) IBOutlet UIView *viewWeb;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


@end
