//
//  LoginViewModel.h
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
           validationCode:(NSString *)validationCode
           firstLoginFlag:(BOOL)isFirstLogin
              handleBlcok:(void (^)(BOOL isSuccess,NSString *alert))block;

//找回密码认证
+ (void)judgeResetPwdWithText1:(NSString *)text1
                         text2:(NSString *)text2
                      withType:(RESET_TYPE)type
                         blobk:(void(^)(BOOL isOk, NSString *alertStr))block;
//登陆输入认证
+ (void)judgeLoginWithText1:(NSString *)text1
                      text2:(NSString *)text2
                      text3:(NSString *)text3
             firstLoginFlag:(BOOL)isFirstLogin
                      blobk:(void(^)(BOOL isOk, NSString *alertStr))block;

/** 获取验证码 */
+(void)requestValidateCodeWithMobileNumber:(NSString *)mobileNumber response:(void(^)(NSString *SessionId,NSString *errorStr))block;

//密码生成验证
+(BOOL)judgeUserPasswordFormat:(NSString *)password;


//登出
+ (void)loginOutResponse:(void(^)(NSInteger loginOutStatus))block;

@end
