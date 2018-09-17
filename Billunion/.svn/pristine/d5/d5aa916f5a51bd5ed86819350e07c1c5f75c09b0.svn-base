//
//  Hud.h
//  Billunion
//
//  Created by Waki on 2017/1/14.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Hud : UIView

/**
 *  菊花转圈,默认添加到window上
 */
+ (void)showActivityIndicator;
+ (void)showActivityIndicatorInView:(UIView *)view;

/**
 *  文本提示,默认添加到window上
 *
 *  @param text 文字内容
 */
+ (void)showTipsText:(NSString *)text;

/**
 *  显示进展进度,默认添加到window上
 *
 *  @param progressStyle 进度条样式:
 */
+ (void)showProgress:(MBProgressHUDMode)progressStyle;

+ (void)showProgress:(MBProgressHUDMode)progressStyle text:(NSString *)text;

/**
 *  设置进度,注意赋给hud的进度取值范围是0~1.
 *
 *  @param progress 进度
 */
+ (void)setHudProgress:(CGFloat)progress;

/**
 隐藏window上的hud
 */
+ (void)hide;
+ (void)hideFromView:(UIView *)view;
+ (void)hideHudFromView:(UIView *)view afterTime:(CGFloat)second;
/**
 *  底层实现方法
 *
 *  @param hubModel 样式
 *  @param text     文字
 *  @param view     view为nil,默认加在window上
 *  @param second   秒数:传0表示不自动消失
 *  @param isAbled  展示期间其他界面是否可以交互
 */
+ (void)showHubWithModel:(MBProgressHUDMode)hubModel
                    text:(NSString *)text
                  inView:(UIView *)view
                  during:(CGFloat)second
               userAbled:(BOOL)isAbled;

@end
