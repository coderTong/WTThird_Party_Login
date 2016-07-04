//
//  UIView+BDJExtension.m
//  budejie
//
//  Created by Mac on 16/6/24.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "UIView+BDJExtension.h"

@implementation UIView (BDJExtension)


- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}








- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (NSLayoutConstraint *)leftCon
{
    NSArray *array = self.superview.constraints;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeLeading){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeLeading){
    //            return con;
    //        }
    //    }
    //    return nil;
}

- (void)setLeftCon:(NSLayoutConstraint *)leftCon
{
    NSLayoutConstraint *con = self.leftCon;
    if(con){
        [self.superview removeConstraint:con];
    }
    [self.superview addConstraint:leftCon];
}

- (NSLayoutConstraint *)rightCon
{
    NSArray *array = self.superview.constraints;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeTrailing){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeTrailing){
    //            return con;
    //        }
    //    }
    //    return nil;
}

- (void)setRightCon:(NSLayoutConstraint *)rightCon
{
    NSLayoutConstraint *con = self.rightCon;
    if(con){
        [self.superview removeConstraint:con];
    }
    [self.superview addConstraint:rightCon];
}

- (NSLayoutConstraint *)topCon
{
    NSArray *array = self.superview.constraints;
    
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeTop){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeTop){
    //            return con;
    //        }
    //    }
    //    return nil;
}

- (void)setTopCon:(NSLayoutConstraint *)topCon
{
    NSLayoutConstraint *con = self.topCon;
    if(con){
        [self.superview removeConstraint:con];
    }
    [self.superview addConstraint:topCon];
}

- (NSLayoutConstraint *)bottomCon
{
    NSArray *array = self.superview.constraints;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeBottom){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if(con.secondItem == self && con.secondAttribute == NSLayoutAttributeBottom){
    //            return con;
    //        }
    //    }
    //    return nil;
}

- (void)setBottomCon:(NSLayoutConstraint *)bottomCon
{
    NSLayoutConstraint *con = self.bottomCon;
    if(con){
        [self.superview removeConstraint:con];
    }
    [self.superview addConstraint:bottomCon];
}


- (NSLayoutConstraint *)widthCon
{
    NSArray *array = self.constraints;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeWidth && con.secondItem == nil){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
    //            if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeWidth && con.secondItem == nil){
    //                return con;
    //            }
    //        }
    //    }
    //    return nil;
}

- (void)setWidthCon:(NSLayoutConstraint *)widthCon
{
    NSLayoutConstraint *con = self.widthCon;
    if(con){
        [self removeConstraint:con];
    }
    [self addConstraint:widthCon];
}

- (NSLayoutConstraint *)heightCon
{
    NSArray *array = self.constraints;
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL state = NO;
        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
            if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeHeight &&con.secondItem == nil){
                state = YES;
            }
        }
        return state;
    }];
    NSArray *filterArray = [array filteredArrayUsingPredicate:pre];
    if(filterArray.count > 0){
        return filterArray.firstObject;
    }
    return nil;
    
    //    for(NSLayoutConstraint *con in array){
    //        if([NSStringFromClass([con class]) isEqualToString:NSStringFromClass([NSLayoutConstraint class])]){
    //            if(con.firstItem == self && con.firstAttribute == NSLayoutAttributeHeight &&con.secondItem == nil){
    //                return con;
    //            }
    //        }
    //    }
    //    return nil;
}

- (void)setHeightCon:(NSLayoutConstraint *)heightCon
{
    NSLayoutConstraint *con = self.heightCon;
    if(con){
        [self removeConstraint:con];
    }
    [self addConstraint:heightCon];
}

#pragma mark - layer
- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CALayer * layer = self.layer;
    if(borderColor != nil){
        layer.borderColor = [borderColor CGColor];
    }
    if(borderWidth == 0){
        layer.borderWidth = 0.5;
    }else{
        layer.borderWidth = borderWidth;
    }
    if(cornerRadius == 0){
        layer.cornerRadius = 3.0;
    }else{
        layer.cornerRadius = cornerRadius;
    }
    layer.masksToBounds = YES;
}


@end
