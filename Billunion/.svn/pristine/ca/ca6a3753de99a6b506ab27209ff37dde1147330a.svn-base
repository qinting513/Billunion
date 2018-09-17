//
//  ResetPwdViewModel.m
//  Billunion
//
//  Created by QT on 17/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "ResetPwdViewModel.h"
#import "FGNetworking.h"

@implementation ResetPwdViewModel


+ (void)judgeResetPwdWithText1:(NSString *)text1
                         text2:(NSString *)text2
                  resetPwdType:(RESET_TYPE)type
                         blobk:(void(^)(BOOL isOk, NSString *alertStr))block{
    if (type == Reset_verify) {
        if (![text1 isPhone]) {
            block(NO,NSLocalizedString(@"ERROR_PHONE_NUM", nil) );
            return;
        }
        
        if (text2.length == 0) {
            block(NO,NSLocalizedString(@"ERROR_VERIFY_CODE", nil) );
            return;
        }
    }else if(type == Reset_pwd)
    {
        if (text1.length == 0 || text2.length == 0) {
            block(NO,NSLocalizedString(@"ERROR_PWD_NONE", nil) );
            return;
        }
        if (text1 != text2 ) {
            block(NO,NSLocalizedString(@"ERROR_PWD_NOT_SAME", nil) );
            return ;
        }
    }
    
    block(YES,nil);
}


/** 找回密码  测试成功 返回0 */
//    params = @{@"OperType":@203,@"Param":@{@"MobileNumber":@"18502562645",@"CompanyId":@51300,@"ValidationCode":@"1111",@"Password":@"123456"}};

+(void)resetPasswordWithMobileNumber:(NSString *)mobileNumber validationCode:(NSString *)code password:(NSString *)pwd response:(void(^)(BOOL isOK, NSString *errorStr))block{
    NSDictionary *params = @{@"OperType":@203,
                             @"Param":@{@"MobileNumber":mobileNumber,
//                                        @"CompanyId":@51300,   // 要企业ID吗？ 统一的还是每次都不同？
                                        @"ValidationCode":code,
                                        @"Password":pwd
                                        }};
    [FGNetworking requsetWithPath:VISITOR_URL params:params method:Post handleBlcok:^(id response, NSError *error) {
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                !block ?: block(YES,nil);
            }else{
                !block ?: block(NO,NSLocalizedString(@"ERROR_PWD_RESET_FAIL", nil) );
            }
        }else{
//             NSLog(@"网络请求出错：%@",error);
             !block ?: block(NO,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
}

@end











