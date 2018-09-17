//
//  MarketViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketViewModel : NSObject

//查询卖方市场行情列表 --> 有筛选条件
+(void)requestSellerInquiryListWithBillType:(NSArray*)billTypes
                                       page:(NSInteger)page
                                    itemNum:(NSInteger)itemNum
                               acceptorType:(NSArray*)acceptorType
                               dueTimeRange:(NSArray*)dueTimeRange
                                    address:(NSString *)address
                                   response:( void(^)(NSArray *dataArr,NSString *errorStr))block;
//查询买方市场行情列表 -- 有筛选条件
+(void)requestBuyerInquiryListWithBillType:(NSArray*)billType
                                      page:(NSInteger)page
                              acceptorType:(NSArray*)acceptorType
                              dueTimeRange:(NSArray*)dueTimeRange
                                   address:(NSString *)address
                                  response:( void(^)(NSArray *dataArr,NSString *errorStr))block;
@end
