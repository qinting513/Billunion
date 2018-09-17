//
//  QTPlaceholderLabelTextView.h
//  PlaceholderTextView
//
//  Created by Qinting on 16/7/17.
//  Copyright © 2016年 Qinting. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
封装的好处：
 1. 对外接口不变，外部修改什么，内部都可以随着改变而改变
 2.控件内部修改了，仍然不影响外部的使用
 */

@interface QTPlaceholderLabelTextView : UITextView
/** 占位文字 */
@property (nonatomic ,copy) NSString   *placeholder;
/** 占位文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;

@property (nonatomic,strong) UILabel *placeholderLabel;
@end
