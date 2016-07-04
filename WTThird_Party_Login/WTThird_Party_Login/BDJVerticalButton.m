//
//  BDJVerticalButton.m
//  budejie
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "BDJVerticalButton.h"

@implementation BDJVerticalButton

- (void)setupTitleLabelAlignment
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTitleLabelAlignment];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupTitleLabelAlignment];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
