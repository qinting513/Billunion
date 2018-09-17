//
//  Hud.m
//  Billunion
//
//  Created by Waki on 2017/1/14.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "Hud.h"

#define kHudTag (1000+345)
#define kBezelViewWidth 200
#define kBezelViewHeigh 200

@implementation Hud

+ (void)showActivityIndicator{
    [Hud showHubWithModel:MBProgressHUDModeIndeterminate text:nil inView:nil during:10 userAbled:YES];
}

+ (void)showActivityIndicatorInView:(UIView *)view{
    [Hud showHubWithModel:MBProgressHUDModeIndeterminate text:nil inView:view during:0 userAbled:NO];
}

+ (void)showTipsText:(NSString *)text{
    if (text.length == 0) {
        return;
    }
    [Hud showHubWithModel:MBProgressHUDModeText text:text inView:nil during:1.0 userAbled:YES];
}

+ (void)showProgress:(MBProgressHUDMode)progressStyle{
    [Hud showHubWithModel:progressStyle text:@"加载中..." inView:nil during:0 userAbled:YES];
}

+ (void)showProgress:(MBProgressHUDMode)progressStyle text:(NSString *)text{
    [Hud showHubWithModel:progressStyle text:text inView:nil during:0 userAbled:YES];
}

+ (void)showHubWithModel:(MBProgressHUDMode)hubModel
                    text:(NSString *)text
                  inView:(UIView *)view
                  during:(CGFloat)second
               userAbled:(BOOL)isAbled;
{
    MBProgressHUD *hud = nil;
   
    if (!view)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        MBProgressHUD *hudView = ( MBProgressHUD *)[window viewWithTag:kHudTag];
        if (hudView != nil) {
            return;
        }
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        if (isAbled){
//            if (!text) {
//                hud.frame = CGRectMake((WIDTH-kBezelViewWidth)/2, (HEIGHT-kBezelViewHeigh)/2, kBezelViewWidth, kBezelViewHeigh);
                   hud.frame = CGRectMake(0, (HEIGHT-kBezelViewHeigh)/2, WIDTH, kBezelViewHeigh);
//            }
        }
    }else{
        MBProgressHUD *hudView = ( MBProgressHUD *)[view viewWithTag:kHudTag];
        if (hudView != nil) {
            return;
        }
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    hud.tag = kHudTag;
    hud.defaultMotionEffectsEnabled = YES;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = hubModel;
    hud.bezelView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];//UIColorFromRGB(0x505050);//改背景颜色属性
    
    switch (hud.mode)
    {
            //菊花
        case MBProgressHUDModeIndeterminate:
            if (text.length != 0) {
                 hud.label.text = text;
            }
            break;
            //只显示文本
        case MBProgressHUDModeText:{
            hud.label.text = text;
        }
            break;
            //实线圆形进度条
        case MBProgressHUDModeDeterminate: {
            //            for (UIView *subView in hud.bezelView.subviews) {
            //                if ([subView isKindOfClass:[MBRoundProgressView class]]) {
            //                    MBRoundProgressView *pgsView = (MBRoundProgressView *)subView;
            //                    pgsView.progressTintColor = [UIColor redColor];
            //                    break;
            //                }
            //            }
//            hud.label.text = @"加载中...";
            if (text.length != 0) {
                hud.label.text = text;
            }
        }
            break;
            //水平进度条
        case MBProgressHUDModeDeterminateHorizontalBar:{
//            hud.label.text = @"加载中...";
            if (text.length != 0) {
                hud.label.text = text;
            }
        }
            break;
            //圆形进度条--进度由暗淡变实
        case MBProgressHUDModeAnnularDeterminate:{
//            if (text == nil) {
//              hud.label.text = @"加载中...";
//            }
            if (text.length != 0) {
                hud.label.text = text;
            }
        }
            break;
            //自定义
        case MBProgressHUDModeCustomView:{
            
        }
            break;
        default:
            break;
    }
    if (second > 0) {
        [hud hideAnimated:NO afterDelay:second];
    }
    
}

+ (void)setHudProgress:(CGFloat)progress
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    MBProgressHUD *hud = [window viewWithTag:kHudTag];
    if (hud.mode == MBProgressHUDModeIndeterminate || hud.mode == MBProgressHUDModeText || hud.mode == MBProgressHUDModeCustomView) {
        return;
    }
    hud.progress = progress/100.0;
    if (hud.progress >= 1) {
        [hud hideAnimated:YES];
    }
}

+ (void)hideFromView:(UIView *)view
{
    MBProgressHUD *hudView = (MBProgressHUD *)[view viewWithTag:kHudTag];
    [hudView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
}

+ (void)hideHudFromView:(UIView *)view afterTime:(CGFloat)second
{
    if (view == nil)
    {
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        MBProgressHUD *hudView = (MBProgressHUD *)[window viewWithTag:kHudTag];
        [hudView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:second];
    }else{
        MBProgressHUD *hudView = (MBProgressHUD *)[view viewWithTag:kHudTag];
        [hudView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:second];
    }
}

+ (void)hide
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    MBProgressHUD *hudView = (MBProgressHUD *)[window viewWithTag:kHudTag];
    if (hudView) {
        [hudView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    }
}

@end
