//
//  UIAlertController+SettingControl.m
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "UIAlertController+SettingControl.h"

@implementation UIAlertController (SettingControl)

+ (UIAlertController *)alertControllerWithPreferredStyle:(UIAlertControllerStyle)style
                                                   title:(NSString *)title
                                                 message:(NSString *)message
                                              cancelText:(NSString *)cancel
                                                sureText:(NSString *)sure
                                    textFieldPlaceholder:(NSString *)placeholder
                                           textFieldText:(NSString *)text
                                   textFieldKeyboardType:(UIKeyboardType)keyboardType
                                            respondBlock:(void(^)(NSString *text))block{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    [alertCtl addTextFieldWithConfigurationHandler:nil];
    [alertCtl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:nil]];
    
    UITextField *textField = (UITextField *)alertCtl.textFields.firstObject;
    textField.placeholder = placeholder;
    textField.text = text;
    textField.keyboardType = keyboardType;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 30, 30);
    label.text = @" % " ;
    textField.rightView = label;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [alertCtl addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (textField.text.length > 0)
        {
            block(textField.text);
        }
    }]];
    return alertCtl;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title
                                        message:(NSString *)message
                                        btnName:(NSString *)buttonName
                                   respondBlock:(void(^)(void))block;
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }]];
    return alert;
}
@end
