//
//  MyImageView.m
//  Test365 Home
//
//  Created by HuCuBi on 7/28/18.
//  Copyright © 2018 NeoJSC. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
