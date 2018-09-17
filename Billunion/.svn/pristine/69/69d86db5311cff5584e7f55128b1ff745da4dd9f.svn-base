//
//  NetworkClient.h
//  SoundTranslate
//
//  Created by Lucas on 16/8/15.
//  Copyright © 2016年 ZhongRuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} HttpMethod;


@interface FGNetworking : NSObject


//取消所有请求
+ (void)cancelAllRequest;
//取消某个请求
+ (void)cancelRequestWithURL:(NSString *)url;

+ (void)requsetWithPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(HttpMethod)mothod
            handleBlcok:(void (^)(id response, NSError *error))block;


/**
 上传图片

 @param image     上传的那张图片
 @param path      上传URL
 @param imageName 上传的图片名  正面图片positiveImage  反面图片backImage 其他图片otherImage
 @param params    参数 为空
 @param progress  上传进度
 @param success   成功block
 @param failure   失败block
 */
+ (void)uploadImage:(UIImage *)image
               path:(NSString *)path
          imageName:(NSString *)imageName
             params:(NSDictionary *)params
           progress:(void (^)(CGFloat progressValue))progress
            success:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure;

@end
