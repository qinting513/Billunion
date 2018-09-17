//
//  QTPlaceholderLabelTextView.m
//  PlaceholderTextView
//
//  Created by Qinting on 16/7/17.
//  Copyright © 2016年 Qinting. All rights reserved.
//

#import "QTPlaceholderLabelTextView.h"
//#import "UIView+Extension.h"

#define  QTNotiCenter  [NSNotificationCenter defaultCenter]

@interface QTPlaceholderLabelTextView()


@end

@implementation QTPlaceholderLabelTextView

/** scrollView里的子控件随着移动，故添加label 
 label的特点是永远是文字居中，所以设置label的size是文字的宽高
 */
-(UILabel *)placeholderLabel {
    if(_placeholderLabel == nil) {
        UILabel *label = [[UILabel alloc]init];
        label.x = 4;
        label.y = 7;
        label.numberOfLines = 0;
//        label.backgroundColor = [UIColor yellowColor];
        [self addSubview:label];
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}

/** 此方法才能拿到最真实的高度 */
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.placeholderLabel.width = self.width - 2*self.placeholderLabel.x;
//    self.placeholderLabel.height = self.height;
//}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self= [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.alwaysBounceVertical = YES;
    
    /** font默认是空的，需要设置个默认值 */
    self.font = [UIFont systemFontOfSize:13.0];
    
    [QTNotiCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:nil];
    
    /** 设置默认颜色，如果别人不设置 则用默认的,重写setter方法  */
    self.placeholderColor = [UIColor lightGrayColor];
}


-(void)dealloc{
    [QTNotiCenter removeObserver:self];
}

-(void)textDidChange
{
//    NSLog(@"textDidChange");
    self.placeholderLabel.hidden = self.hasText;
}

/** 重写setter方法，实时监听修改 */
-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

/**
 用此方法不用layoutSubviews,在改文字颜色和文字时需调用
 */
//-(void)updateSize
//{
//    /**  设置尺寸方法1 : */
////    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*self.placeholderLabel.x, MAXFLOAT);
////    self.placeholderLabel.size = [self.placeholder  boundingRectWithSize:maxSize
////                                                                 options:NSStringDrawingUsesLineFragmentOrigin
////                                                              attributes:@{NSFontAttributeName: self.font}  context:nil].size;
//    /**  设置尺寸方法2: */
//    self.placeholderLabel.width = [UIScreen mainScreen].bounds.size.width - 2*self.placeholderLabel.x;
//    [self.placeholderLabel sizeToFit];
//}


/** 更严谨的做法：    [UIScreen mainScreen].bounds.size.width 改为self.view */
-(void)layoutSubviews
{
       self.placeholderLabel.width = self.width- 2*self.placeholderLabel.x;
        [self.placeholderLabel sizeToFit];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
//    [self updateSize];
    [self setNeedsLayout];
}

-(void)setFont:(UIFont *)font{
    /** 这个属性是父类的，重写父类的 */
    [super setFont:font];
    self.placeholderLabel.font = font;
//    [self updateSize];
      [self setNeedsLayout];
}



/** 通过代码改文字 不会发通知 */
-(void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
     [self textDidChange];
}
@end

