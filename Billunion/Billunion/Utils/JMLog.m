

//
//  JMLog.m
//  Billunion
//
//  Created by Waki on 2017/2/21.
//  Copyright © 2017年 JM. All rights reserved.
//



#import "JMLog.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end


#define APP_PUBLIC_PASSWORD     @"PCStockLogEncryption"
@implementation JMLogEncryption


#pragma mark - AES加密
//将string转成带密码的data
+ (NSData*)encryptAESData:(NSString*)string {
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES256EncryptWithKey:APP_PUBLIC_PASSWORD];
    return encryptedData;
}

//将带密码的data转成string
+ (NSString*)decryptAESData:(NSData*)data {
    //使用密码对data进行解密
    NSData *decryData = [data AES256DecryptWithKey:APP_PUBLIC_PASSWORD];
    //将解了密码的nsdata转化为nsstring
    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return string;
}

//AES加密 传入字符串返回已经加密的字符串
+ (NSString *)encryptAES:(NSString *)string
{
    NSData *encData = [JMLogEncryption encryptAESData:string];
    NSInteger dataLength = [encData length];
    NSMutableString *encryptedText = [NSMutableString stringWithCapacity:2*dataLength];
    Byte *encryptedByte =(Byte *)[encData bytes];
    //加密后的数据
    for (int i = 0; i < dataLength; i ++)
    {
        [encryptedText appendFormat:@"%02x", encryptedByte[i]];
    }
    return encryptedText;
}




@end


static JM_LOG_LEVEL_E glocalLogLevel = JM_LOG_LEVEL_DEBUG;
static JM_LOG_OUTPUT_E glbalOutput = JM_LOG_OUTPUT_CONSOLE;

static LOG_TYPE logType = LOG_TYPE_DEBUGLOG;

static NSString *logFilePath;



@implementation JMLog


#define LOG_PRINT(logLevel,logLevelStr,file,function, line, format, ...) \
{\
if (glocalLogLevel <= logLevel) \
{\
va_list argList;\
va_start(argList, format);\
NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:argList];\
va_end(argList);\
NSString *logStr = [NSString stringWithFormat:@"%@ %@ %@ <%ld>: %@",logLevelStr, file, function, line,formatStr];\
NSLog(@"%@", logStr);\
}\
}

#define  SAFE_LOG_PRINT(logLevel,logLevelStr,file,function, line, format, ...) \
{\
if (glocalLogLevel <= logLevel) \
{\
va_list argList;\
va_start(argList, format);\
NSString *formatStr = [[NSString alloc] initWithFormat:format arguments:argList];\
NSString *encryptStr = [JMLogEncryption encryptAES:formatStr];\
va_end(argList);\
NSString *logStr = [NSString stringWithFormat:@"%@ %@ %@ <%ld>: %@",logLevelStr, file, function, line,encryptStr];\
NSLog(@"%@", logStr);\
}\
}



static void handleUncaughtException(NSException *exception)
{
    NSString* exceptionName = [exception name];
    NSString* exceptionReason = [exception reason];
    NSArray* symbols = [exception callStackSymbols];
    NSMutableString *strSymbols = [[NSMutableString alloc]init];
    for (NSString*item in symbols)
    {
        [strSymbols appendString:item];
        [strSymbols appendString:@"\r\n"];
    }
    // 打印到console或日志
    [JMLog error:@"Exception" function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:@"%@ %@", exceptionName, exceptionReason];
    [JMLog error:@"Exception" function:[NSString stringWithUTF8String:__FUNCTION__] line:__LINE__ format:@"%@", strSymbols];
}


/**
 * @function:设置全局默认输出日志级别
 * @param logLevel 日志级别 output 输出位置
 * @return 成功 TRUE 失败 FALSE
 * @description:
 **/
+ (NSInteger) setLogParam:(JM_LOG_LEVEL_E)logLevel output:(JM_LOG_OUTPUT_E)output
{
    if (logLevel > JM_LOG_LEVEL_ERROR || logLevel < JM_LOG_LEVEL_DEBUG
        || output < JM_LOG_OUTPUT_CONSOLE || output > JM_LOG_OUTPUT_FILE)
    {
        return -1;
    }
    
    @synchronized(self)
    {
        glocalLogLevel = logLevel;
        glbalOutput = output;
        if (output == JM_LOG_OUTPUT_FILE)
        {
            logType = LOG_TYPE_RELEASE;
            [self redirectNSlogToDocumentFolder];
            
        }
        else
        {
            logType = LOG_TYPE_DEBUGLOG;
        }
        // 设置系统异常捕获函数
        NSSetUncaughtExceptionHandler(handleUncaughtException);
    }
    return 0;
}




/**
 * @function:打印debug级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) debug:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    NSString * name = [file lastPathComponent];
    LOG_PRINT(JM_LOG_LEVEL_DEBUG, @"DEBUG",name,function, (long)line, format, ...);
}

/**
 * @function:打印safeDebug级别加密日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) safeDebug:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    NSString * name = [file lastPathComponent];
    
    //对于调试情况下，也就是不将log文件保存到文件时，不对输出进行加密
    if (logType == LOG_TYPE_DEBUGLOG) {
        LOG_PRINT(JM_LOG_LEVEL_DEBUG, @"SAFE_DEBUGLOG",name, function, (long)line, format, ...);
    }else{
        SAFE_LOG_PRINT(JM_LOG_LEVEL_DEBUG, @"SAFE_DEBUGLOG",name, function, (long)line, format, ...);
    }
    
}


/**
 * @function:打印info级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) info:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    NSString * name = [file lastPathComponent];
    LOG_PRINT(JM_LOG_LEVEL_INFO, @"INFO", name, function,(long)line, format, ...);
}

/**
 * @function:打印warning级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) warning:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    NSString * name = [file lastPathComponent];
    LOG_PRINT(JM_LOG_LEVEL_WARNING,@"WARNING",name,function, (long)line, format, ...);
}

/**
 * @function:打印error级别日志
 * @param moduleTag 模块标志 format 打印字符串
 * @return
 * @description:
 **/
+ (void) error:(NSString*)file function:(NSString*)function line:(NSInteger)line format:(NSString*)format, ...
{
    NSString * name = [file lastPathComponent];
    LOG_PRINT(JM_LOG_LEVEL_ERROR,@"ERROR",name,function,(long)line, format, ...);
}

+ (void)redirectNSlogToDocumentFolder
{
    
    //    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Billunion.log"];
    //
    //    freopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    //    freopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [filePath objectAtIndex:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"Billunion_%@.log",currentDate];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //    [[NSFileManager defaultManager] removeItemAtPath:logFilePath error:nil];
    
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
}




@end
