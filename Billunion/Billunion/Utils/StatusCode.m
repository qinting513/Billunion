//
//  StatusCode.m
//  Billunion
//
//  Created by QT on 2017/3/24.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StatusCode.h"

@implementation StatusCode


+(NSString *)getErrorStrWithCode:(NSNumber*)code{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"StatusCode.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *codeStr = [NSString stringWithFormat:@"%@",code];
    return  dict[codeStr];
}

@end
