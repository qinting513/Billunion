//
//  JMLog.h
//  Billunion
//
//  Created by Waki on 2017/2/21.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end


@interface JMLogEncryption : NSObject

+ (NSString *)encryptAES:(NSString *)string;


@end

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif

typedef enum
{
    LOG_TYPE_DEBUGLOG,
    LOG_TYPE_RELEASE,
}LOG_TYPE;

typedef enum
{
    JM_LOG_LEVEL_DEBUG,
    JM_LOG_LEVEL_INFO,
    JM_LOG_LEVEL_WARNING,
    JM_LOG_LEVEL_ERROR,
    
}JM_LOG_LEVEL_E;

typedef enum
{
    JM_LOG_OUTPUT_CONSOLE,
    JM_LOG_OUTPUT_FILE,
}JM_LOG_OUTPUT_E;

// 请优先使用下面的宏进行日志相关操作
#ifndef SETLOGPARAM
#define SETLOGPARAM(LOGLEVEL, OUTPUT)\
{\
[JMLog setLogParam:LOGLEVEL output:OUTPUT];\
}
#endif

#ifndef DEBUGLOG
#define DEBUGLOG(...) \
{\
[JMLog debug:[NSString stringWithUTF8String:__FILE__] function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef SAFE_DEBUGLOG
#define SAFE_DEBUGLOG(...) \
{\
[JMLog safeDebug:[NSString stringWithUTF8String:__FILE__] function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef INFOLOG
#define INFOLOG(...) \
{\
[JMLog info:[NSString stringWithUTF8String:__FILE__] function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef WARNINGLOG
#define WARNINGLOG(...) \
{\
[   JMLog warning:[NSString stringWithUTF8String:__FILE__] function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

#ifndef ERRLOG
#define ERRLOG(...) \
{\
[JMLog error:[NSString stringWithUTF8String:__FILE__] function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:__VA_ARGS__];\
}
#endif

@interface JMLog : NSObject

/**
 * function:设置全局默认输出日志级别
 * param logLevel 日志级别 output 输出位置
 * return 成功 TRUE 失败 FALSE
 * description:
 **/
+ (NSInteger)setLogParam:(JM_LOG_LEVEL_E)logLevel output:(JM_LOG_OUTPUT_E)output;

/**
 * function:打印debug级别日志
 * param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * return
 * description:
 **/
+ (void)debug:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * function:打印debug级别加密日志
 * param moduleTag 模块标志 format 打印字符串
 * return
 * @description:
 **/
+ (void)safeDebug:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * function:打印info级别日志
 * param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * return
 * description:
 **/
+ (void)info:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * function:打印warning级别日志
 * param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * return
 * description:
 **/
+ (void)warning:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;

/**
 * function:打印error级别日志
 * param moduleTag 模块标志 logEnable 是否允许输出 function 日志所在函数 line 日志所在行数 format 打印字符串
 * return
 * description:
 **/
+ (void)error:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...;
@end
