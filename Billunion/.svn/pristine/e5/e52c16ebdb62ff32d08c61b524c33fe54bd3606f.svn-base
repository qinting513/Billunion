//
//  ResetPwdViewModel.h
//  Billunion
//
//  Created by QT on 17/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewModel.h"

@interface ResetPwdViewModel : NSObject

+ (void)judgeResetPwdWithText1:(NSString *)text1
                         text2:(NSString *)text2
                  resetPwdType:(RESET_TYPE)type
                         blobk:(void(^)(BOOL isOk, NSString *alertStr))block;

+(void)resetPasswordWithMobileNumber:(NSString *)mobileNumber validationCode:(NSString *)code password:(NSString *)pwd response:(void(^)(BOOL isOK, NSString *errorStr))block;

@end
