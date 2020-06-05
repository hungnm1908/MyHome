//
//  MyCustomView.m
//  BanChoKenh
//
//  Created by HuCuBi on 7/12/17.
//  Copyright © 2017 HuCuBi. All rights reserved.
//

#import "MyCustomView.h"


@implementation MyCustomView

-(instancetype)init
{
    if (self = [super init])
    {
        [self commonInit];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}

- (void)commonInit
{

}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGFloat)shadowOffset {
    self.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.layer.masksToBounds = false;
}

@end
