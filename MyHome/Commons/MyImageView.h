//
//  MyImageView.h
//  Test365 Home
//
//  Created by HuCuBi on 7/28/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MyImageView : UIImageView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;

@end
