//
//  MyButton.h
//  NoiBaiAirPort
//
//  Created by HuCuBi on 7/18/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MyButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor * borderColor;

@end
