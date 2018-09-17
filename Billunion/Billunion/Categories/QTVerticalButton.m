//
//  QTVerticalButton.m
//  BaiSiBuDeJie
//
//  Created by Qinting on 16/5/25.
//  Copyright © 2016年 Qinting. All rights reserved.
//

#import "QTVerticalButton.h"

@implementation QTVerticalButton

-(void) setup{
   self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        [self setup];
    }
    return  self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    /** adjust  image  */
    self.imageView.left = (self.width - self.imageView.width)*0.5;
    self.imageView.top = 0;
    //图片自有宽高
//    self.imageView.width = self.width;
//    self.imageView.height = self.height;
    
    // adjust word
    self.titleLabel.left = 0;
    self.titleLabel.top = self.imageView.height + 5;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
   
}

+ (instancetype)buttonTitle:(NSString *)title img:(NSString *)img selectImg:(NSString *)selectImg font:(CGFloat)size titleColor:(UIColor *)color target:(id)target action:(SEL)method
{
    QTVerticalButton *btn = [QTVerticalButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    [btn addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
