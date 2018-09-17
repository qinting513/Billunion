//
//  UIView+HUD.h
//
//  Created by qt on 16/2/26.
//  Copyright © 2016年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIView (HUD)
//忙提示
- (void)showBusyHUD;
//文字提示
- (void)showWarning:(NSString *)warning;
- (void)showWarning:(NSString *)warning afterDelay:(NSTimeInterval)delay;
- (void)showWarning:(NSString *)warning completionBlock:(void(^)())completion;
- (void)showWarning:(NSString *)warning afterDelay:(NSTimeInterval)delay completionBlock:(void(^)())completion;
//隐藏提示
- (void)hideBusyHUD;
@end












