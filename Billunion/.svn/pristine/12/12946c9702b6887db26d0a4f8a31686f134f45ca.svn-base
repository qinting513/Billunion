//
//  UIView+HUD.m
//
//  Created by qt on 16/2/26.
//  Copyright © 2016年 qt. All rights reserved.
//

#import "UIView+HUD.h"
//超时
#define kTimeOut  10
//弹出提示时长
#define kDuration  1

#define kBezelViewWidth 200
#define kBezelViewHeigh 200

@implementation UIView (HUD)
- (void)showBusyHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.frame = CGRectMake((WIDTH-kBezelViewWidth)/2, (HEIGHT-kBezelViewHeigh)/2, kBezelViewWidth, kBezelViewHeigh);
        [hud hideAnimated:YES afterDelay:kTimeOut];
    });
}
- (void)showWarning:(NSString *)warning{
    [self showWarning:warning afterDelay:kDuration];
}

- (void)showWarning:(NSString *)warning afterDelay:(NSTimeInterval)delay{
    [self showWarning:warning afterDelay:delay completionBlock:nil];

}

- (void)showWarning:(NSString *)warning completionBlock:(void(^)())completion{
    [self showWarning:warning afterDelay:kDuration completionBlock:completion];
}


- (void)showWarning:(NSString *)warning afterDelay:(NSTimeInterval)delay completionBlock:(void(^)())completion{
    if (warning.length == 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = warning;
        [hud hideAnimated:YES afterDelay:delay];
        hud.completionBlock = ^{
            !completion ?: completion();
        };
    });
}


- (void)hideBusyHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
}
@end










