//
//  TextFiledChoseDate.h
//  mBCCS
//
//  Created by HuCuBi on 7/24/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface TextFiledChoseDate : UITextField<UITextFieldDelegate>

@property (nonatomic) IBInspectable CGFloat numberDayAgo;

@end
