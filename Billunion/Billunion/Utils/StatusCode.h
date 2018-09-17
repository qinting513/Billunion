//
//  StatusCode.h
//  Billunion
//
//  Created by QT on 2017/3/24.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusCode : NSObject

+(NSString *)getErrorStrWithCode:(NSNumber*)code;

@end
