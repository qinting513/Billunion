//
//  BuyViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyViewModel : NSObject

// + (NSArray *)getBuyInfoData;


/**
 根据指定页面获取相应的交易信息
 
 @param page 页面的下标
 @return   1询价买入 3指定买入 5报价买入 8被指定卖出
 
 */
+ (NSNumber *)getBuyTradeRoleWithViewPage:(NSInteger)page;

+ (void)requestTradeManualListWithParams:(NSDictionary *)params response:( void(^)(NSArray *dataArr,NSString *errorStr))block;
@end
