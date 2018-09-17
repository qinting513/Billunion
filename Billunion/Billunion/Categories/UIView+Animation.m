
//
//  UIView+Animation.m
//  Billunion
//
//  Created by Waki on 2017/2/28.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)


- (void)showView:(UIView *)view animated:(BOOL)animated {
    // 保存当前弹出的视图
    //    _currentView = view;
    CGFloat halfScreenWidth = self.frame.size.width * 0.5;
    CGFloat halfScreenHeight = self.frame.size.height * 0.5;
    // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    view.center = screenCenter;
    [self addSubview:view];
    
    if (animated) {
     //    第一步：将view宽高缩至无限小（点）
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                        0.8, 0.8);
        view.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 1;
            view.transform = CGAffineTransformIdentity;
        }];
        
    }
    
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
//                             view.transform =
//                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
//                         }
//                         completion:^(BOOL finished) {
//                             [UIView animateWithDuration:0.2
//                                              animations:^{
//                                                  // 第三步： 以动画的形式将view恢复至原始大小
//                                                  view.transform = CGAffineTransformIdentity;
//                                              }];
//                         }];
//    }
}


- (void)closeView:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        
        [UIView animateWithDuration:0.2 animations:^{
             view.alpha = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            self.hidden = YES;
        }];

//
//        [UIView animateWithDuration:0.2
//                         animations:^{
//                             // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
//                             view.transform =
//                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
//                         }
//                         completion:^(BOOL finished) {
//                             [UIView animateWithDuration:0.3
//                                              animations:^{
//                                                  // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
//                                                  view.transform = CGAffineTransformScale(
//                                                                                                      CGAffineTransformIdentity, 0.001, 0.001);
//                                              }
//                                              completion:^(BOOL finished) {
//                                                  // 第三步： 移除
//                                                  [view removeFromSuperview];
//                                                  self.hidden = YES;
//                                              }];
//                         }];
//    } else {
//        [view removeFromSuperview];
//    }
    }
}






+ (void)showInWindow:(UIView *)view animated:(BOOL)animated {
    // 保存当前弹出的视图
    //    _currentView = view;
    CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;
    // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    view.center = screenCenter;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:view];
    
    if (animated) {
        // 第一步：将view宽高缩至无限小（点）
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3
                         animations:^{
                             // 第二步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                             view.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  // 第三步： 以动画的形式将view恢复至原始大小
                                                  view.transform = CGAffineTransformIdentity;
                                              }];
                         }];
    }
}


+ (void)closeFromWindow:(UIView *)view animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                             view.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                                  view.transform = CGAffineTransformScale(
                                                                                          CGAffineTransformIdentity, 0.001, 0.001);
                                              }
                                              completion:^(BOOL finished) {
                                                  // 第三步： 移除
                                                  [view removeFromSuperview];
                                              }];
                         }];
    } else {
        [view removeFromSuperview];
    }
}


@end
