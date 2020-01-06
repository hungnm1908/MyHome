//
//  MyCustomView.h
//  BanChoKenh
//
//  Created by HuCuBi on 7/12/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

IB_DESIGNABLE
@interface MyCustomView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;

@property (nonatomic, strong) IBInspectable UIColor * shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGFloat shadowOffset;

@end
