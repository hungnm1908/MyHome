//
//  TextFieldChoseMonth.h
//  EVNCPCCSKH
//
//  Created by Macbook on 7/9/19.
//  Copyright © 2019 EVNCPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDatePickerViewEx.h"

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldChoseMonth : UITextField<UITextFieldDelegate, CDatePickerViewExDelegate>

@property (nonatomic) IBInspectable CGFloat numberMonthAgo;

@end

NS_ASSUME_NONNULL_END
