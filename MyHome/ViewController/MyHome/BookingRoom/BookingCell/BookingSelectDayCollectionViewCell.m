//
//  BookingSelectDayCollectionViewCell.m
//  MyHome
//
//  Created by Macbook on 9/27/19.
//  Copyright © 2019 NeoJSC. All rights reserved.
//

#import "BookingSelectDayCollectionViewCell.h"
#import "Utils.h"

@implementation BookingSelectDayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.leftAnchor constraintEqualToAnchor:self.contentView.superview.leftAnchor constant:0].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.contentView.superview.rightAnchor constant:0].active = YES;
    [self.contentView.topAnchor constraintEqualToAnchor:self.contentView.superview.topAnchor constant:0].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.contentView.superview.bottomAnchor constant:0].active = YES;
}

- (void)layoutSubviews {
    [self performSelector:@selector(settupView) withObject:nil afterDelay:0.1];
}

- (void)settupView {
    [self makeViewDisableFirstDate:self.viewDisableFirstDate];
    [self makeViewDisableEndDate:self.viewDisableEndDate];
}

- (void)makeViewDisableFirstDate : (UIView *)view {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height); //figure out your bounds
    
    CGPoint one = CGPointMake( bounds.origin.x , bounds.origin.y);
    CGPoint two = CGPointMake( bounds.origin.x + bounds.size.width, bounds.origin.y);
    CGPoint three = CGPointMake( bounds.origin.x + bounds.size.width/2 , bounds.origin.y + bounds.size.height/2);
    CGPoint four = CGPointMake( bounds.origin.x, bounds.origin.y + bounds.size.height);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,one.x, one.y);
    CGPathAddLineToPoint(path,NULL,two.x, two.y);
    CGPathAddLineToPoint(path,NULL,three.x, three.y);
    CGPathAddLineToPoint(path,NULL,four.x, four.y);
    CGPathAddLineToPoint(path,NULL,one.x, one.y);
    
    [maskLayer setFrame:bounds];
    CGPathRef p = path;
    maskLayer.path = p;
    view.layer.mask = maskLayer;
    view.clipsToBounds = YES;
}

- (void)makeViewDisableEndDate : (UIView *)view {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height); //figure out your bounds
    
    CGPoint one = CGPointMake( bounds.origin.x + bounds.size.width/2 , bounds.origin.y + bounds.size.height/2);
    CGPoint two = CGPointMake( bounds.origin.x + bounds.size.width, bounds.origin.y);
    CGPoint three = CGPointMake(bounds.origin.x + bounds.size.width  , bounds.origin.y + bounds.size.height);
    CGPoint four = CGPointMake( bounds.origin.x, bounds.origin.y + bounds.size.height);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,one.x, one.y);
    CGPathAddLineToPoint(path,NULL,two.x, two.y);
    CGPathAddLineToPoint(path,NULL,three.x, three.y);
    CGPathAddLineToPoint(path,NULL,four.x, four.y);
    CGPathAddLineToPoint(path,NULL,one.x, one.y);
    
    [maskLayer setFrame:bounds];
    CGPathRef p = path;
    maskLayer.path = p;
    view.layer.mask = maskLayer;
    view.clipsToBounds = YES;
}

@end
