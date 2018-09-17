//
//  SellViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellViewModel : NSObject

/**
 根据指定页面获取相应的交易信息

 @param page 页面的下标
 @return   2询价卖出  4指定卖出  6报价卖出  7被指定买入

 */
+ (NSNumber *)getSellTradeRoleWithViewPage:(NSInteger)page;

+ (void)requestManualListWithParams:(NSDictionary *)params response:(void (^)(NSArray *, NSString *))block;

@end
