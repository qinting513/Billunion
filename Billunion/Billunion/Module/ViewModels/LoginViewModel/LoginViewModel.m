
//
//  LoginViewModel.m
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//



#import "LoginViewModel.h"
#import "FGNetworking.h"
#import "StatusCode.h"


@implementation LoginViewModel


+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
           validationCode:(NSString *)validationCode
           firstLoginFlag:(BOOL)isFirstLogin
              handleBlcok:(void (^)(BOOL isSuccess,NSString *alert))block{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Username"] = userName;
    params[@"Password"] = password;
    params[@"ValidationCode"] = validationCode;
    params[@"FirstLoginFlag"] = isFirstLogin ? @"true" : @"false";
    params[@"ClientType"] = @"3";
    if ([Config getIPAddress]) {
        params[@"IpAddress"] = [Config getIPAddress];
    }
    if ([Config getUUID]) {
        params[@"UniqueIdentifier"] = [Config getUUID];
    }

    DEBUGLOG(@"%@\n%@",LOGIN_URL,params);
    [FGNetworking requsetWithPath:LOGIN_URL params:params method:Post handleBlcok:^(id response, NSError *error) {
     DEBUGLOG(@"%@\n%@",LOGIN_URL,response);
      if (!error) {
          int statusCode = [[response objectForKey:@"Status"] intValue];
          if ( statusCode == 0) {
            [Config saveAccountWithKeyValue:response];
            block(YES,nil);
          }else{
              block(NO,[StatusCode getErrorStrWithCode:@(statusCode)]);
          }
      }else{
          block(NO,NSLocalizedString(@"ERROR_NETWORK", nil));
      }
  }];
}


+ (void)judgeResetPwdWithText1:(NSString *)text1
                         text2:(NSString *)text2
                      withType:(RESET_TYPE)type
                         blobk:(void(^)(BOOL isOk, NSString *alertStr))block{
    if (type == Reset_verify) {
        if (![text1 isPhone]) {
            block(NO, NSLocalizedString(@"ERROR_PHONE_NUM", nil) );
            return;
        }
        // 获取验证码 不需要判断是否已经输入验证码
//        if (text2.length == 0) {
//            block(NO,@"验证码不能为空!");
//            return;
//        }
    }else{
        if (text1.length == 0 || text2.length == 0) {
            block(NO,  NSLocalizedString(@"ERROR_PWD_NONE", nil));
            return;
        }
        if (text1 != text2 ) {
            block(NO, NSLocalizedString(@"ERROR_PWD_NOT_SAME", nil));
            return ;
        }
    }
    
    block(YES,nil);
}

+ (void)judgeLoginWithText1:(NSString *)text1
                      text2:(NSString *)text2
                      text3:(NSString *)text3
             firstLoginFlag:(BOOL)isFirstLogin
                      blobk:(void(^)(BOOL isOk, NSString *alertStr))block{
    if (![text1 isPhone]) {
        block(NO, NSLocalizedString(@"ERROR_PHONE_NUM", nil) );
        return;
    }
    if (text2.length == 0) {
        block(NO, NSLocalizedString(@"ERROR_PWD_NONE", nil));
        return;
    }
    if (!isFirstLogin) {
        if (text3.length == 0 || ![text3 mj_isPureInt]) {
            block(NO, NSLocalizedString(@"ERROR_VERIFY_CODE", nil));
            return;
        }
    }
 
    block(YES,nil);
}


/**
 向后台请求验证码，通过短信的形式发送到手机
 
 @param mobileNumber 手机号码
 @param block        回调
 */
+(void)requestValidateCodeWithMobileNumber:(NSString *)mobileNumber response:(void(^)(NSString *SessionId,NSString *errorStr))block{
    
    // 	获取验证码  返回 status 是 0； 测试成功 ok
    NSDictionary* params = @{@"OperType":@207,
                             @"Param":@{
                                     @"MobileNumber":@(mobileNumber.integerValue),
//                                     @"CompanyId":@1002 //固定的还是每次都变化？？
                                     }};
    DEBUGLOG(@"%@ \n %@",VISITOR_URL, params);
    [FGNetworking requsetWithPath:VISITOR_URL params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",VISITOR_URL, response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                !block ?: block(nil,nil);
            }else{
              !block ?: block(nil,[NSString stringWithFormat:@"获取验证码失败！statusCode:%d",statusCode]);
            }
        }else{
            !block ?: block( nil,NSLocalizedString(@"ERROR_NETWORK", nil));
        }
    }];
}

+(BOOL)judgeUserPasswordFormat:(NSString *)password
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}


+ (void)loginOutResponse:(void(^)(NSInteger loginOutStatus))block{
    [FGNetworking requsetWithPath:LOGIN_OUT params:nil method:Post handleBlcok:^(id response, NSError *error) {
        DEBUGLOG(@"%@",response);
        if (!error) {
            NSInteger status = [response[@"Status"] integerValue];
            block(status);
        }else{
            block(1);
        }
    }];

}

@end
