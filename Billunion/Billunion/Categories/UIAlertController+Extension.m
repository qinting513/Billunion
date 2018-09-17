//
//  UIAlertController+Extension.m
//  SoundTranslate
//
//  Created by Waki on 16/9/7.
//  Copyright © 2016年 ZhongRuan. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

+ (void)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                                        okTitle:(NSString *)ok
                                    cancelTtile:(NSString *)cancel
                                          target:(id)target
                                        clickBlock:(void(^)(BOOL ok,BOOL cancel))clickBlock{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (ok && ok.length > 0) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickBlock) {
                clickBlock(YES,NO);
            }
        }];
      [alertCtl addAction:okAction];
    }
     if (cancel && cancel.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (clickBlock) {
                clickBlock(NO,YES);
            }
        }];
         [alertCtl addAction:cancelAction];
     }
    [target presentViewController:alertCtl animated:YES completion:nil];
}


+ (id)getTarget:(UIView *)currentView{
    for (UIView* next = [currentView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *ctl = (UIViewController*)nextResponder;
            return ctl;
        }
    }
    return nil;
}

@end
