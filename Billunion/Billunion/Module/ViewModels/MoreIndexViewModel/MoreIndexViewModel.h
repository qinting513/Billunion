//
//  MoreIndexViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/23.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreIndexViewModel : NSObject

- (void)requestMarketRateResultListWithResponse:(void(^)(NSArray *dataArray, NSString *errorStr))block;

+ (void)requestRateMarketTrendWithType:(K_RATE_MARKET_TYPE)type
                          acceptorType:(NSNumber *)acceptorType
                             billType:(NSNumber *)billType
                          dueTimeRange:(NSNumber *)dueTimeRange
                              response:(void(^)(NSArray *dataArray,NSString *errorStr))block;
@end
