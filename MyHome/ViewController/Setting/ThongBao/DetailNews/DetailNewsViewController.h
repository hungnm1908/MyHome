//
//  DetailNewsViewController.h
//  HappyLuckySale
//
//  Created by Macbook on 7/17/19.
//  Copyright © 2019 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailNewsViewController : BaseViewController<UIWebViewDelegate>

@property NSDictionary *dictItem;
@property int type;
@property NSString *strTitleView;

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightWebview;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end

NS_ASSUME_NONNULL_END
