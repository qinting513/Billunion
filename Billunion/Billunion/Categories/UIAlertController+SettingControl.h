//
//  UIAlertController+SettingControl.h
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SettingControl)
+ (UIAlertController *)alertControllerWithPreferredStyle:(UIAlertControllerStyle)style
                                                   title:(NSString *)title
                                                 message:(NSString *)message
                                              cancelText:(NSString *)cancel
                                                sureText:(NSString *)sure
                                    textFieldPlaceholder:(NSString *)placeholder
                                           textFieldText:(NSString *)text
                                   textFieldKeyboardType:(UIKeyboardType)keyboardType
                                            respondBlock:(void(^)(NSString *text))block;

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                                        btnName:(NSString *)buttonName
                                   respondBlock:(void(^)(void))block;


@end
