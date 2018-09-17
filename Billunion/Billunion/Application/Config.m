//
//  Config.m
//  
//
//  Created by Waki on 2016/12/27.
//
//

#import "Config.h"
#import "UserModel.h"

NSString * const TRADE_NOTIFICATION = @"TradeNotification";

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "JPUSHService.h"


@implementation Config


+ (NSString *)getUUID{
    return  [[NSUUID UUID] UUIDString];
}


// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (void)setCurrnetMobileNumber:(NSString *)mobileNumber{
    [[NSUserDefaults standardUserDefaults] setObject:mobileNumber forKey:@"CurrnetAccount"];
}

+ (NSString *)getCuttentMobileNumber{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrnetAccount"];
}

+ (void)saveAccountWithKeyValue:(NSDictionary *)keyValue{
    UserModel *model = [UserModel mj_objectWithKeyValues:keyValue];
    if (!model.MobileNumber) {
        return;
    }
    for (UserModel *userModel in [UserModel findAll]) {
        if ([userModel.MobileNumber isEqualToString:model.MobileNumber]) {
            model.pk = userModel.pk;
            [model update];
            [Config setCurrnetMobileNumber:model.MobileNumber];
            return;
        }
    }
    
//    [UserModel deleteObjects:[UserModel findAll]];
    [Config setCurrnetMobileNumber:model.MobileNumber];
    [model saveOrUpdate];
}

+ (UserModel *)getCurrentModel{
    for (UserModel *mdoel in [UserModel findAll]) {
        if ([mdoel.MobileNumber isEqualToString:[self getCuttentMobileNumber]]) {
            return mdoel;
        }
    }
    return nil;
}

+ (NSString *)getSessionId{
   UserModel *model = [self getCurrentModel];
    return  model.SessionId;
}

+ (NSNumber *)getCompanyType{
    UserModel *model =  [self getCurrentModel];
    return model.CompanyType;
//    return @2;
}

+ (NSNumber *)getCompanyId{
    UserModel *model =  [self getCurrentModel];
    return model.CompanyId;
}

+ (NSString *)getAccountName{
    UserModel *model =  [self getCurrentModel];
    return model.AccountName;
}

+ (NSString *)getMobileNumber{
    UserModel *model =  [self getCurrentModel];
    return model.MobileNumber;
}

+ (NSString *)getEmail{
    UserModel *model =  [self getCurrentModel];
    return model.Email;
}


+ (BOOL)judgeHasAccountWith:(NSString *)account{
    NSArray *arr =  [UserModel findAll];
    for (UserModel *mdoel in arr) {
        if ([mdoel.MobileNumber isEqualToString:account]) {
            return YES;
        }
    }
    return NO;
}

//  等于0 就是第一次登录
+(BOOL)juddgeFirstLogin{
  NSArray *arr =  [UserModel findAll];
    return arr.count == 0 ;
}

+ (void)setTags:(NSSet *)tags alias:(NSString *)alias{
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:nil];
}



@end
