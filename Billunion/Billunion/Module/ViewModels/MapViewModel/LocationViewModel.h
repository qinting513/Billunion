//
//  LocationViewModel.h
//  Billunion
//
//  Created by QT on 17/2/16.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationViewModel : NSObject

+ (LocationViewModel *)shareInstance;

-(void)getCurrentCityCompletionBlock:(void(^)(NSString *address,NSString *city))block;

@end
