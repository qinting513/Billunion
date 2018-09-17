//
//  UIView+Animation.h
//  Billunion
//
//  Created by Waki on 2017/2/28.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)


/**
 展示弹窗

 @param view 要弹出的View
 @param animated 是否动画
 */
- (void)showView:(UIView *)view animated:(BOOL)animated;

/**
 关闭弹窗

 @param view 要关闭的View
 @param animated 是否动画
 */
- (void)closeView:(UIView *)view animated:(BOOL)animated;


/**
 展示到Window的弹窗
 
 @param view 要弹出的View
 @param animated 是否动画
 */
+ (void)showInWindow:(UIView *)view animated:(BOOL)animated;


/**
 要从Window关闭弹窗
 
 @param view 要关闭的View
 @param animated 是否动画
 */
+ (void)closeFromWindow:(UIView *)view animated:(BOOL)animated;


@end
