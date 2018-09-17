//
//  AssetsViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/14.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetsViewModel : NSObject

//做票据管理时的票据列表
+(void)requestPropertyBillListWithParams:(NSDictionary *)parems stockAllType:(StockAllType)stockType response:( void(^)(NSArray *dataArr,NSString *errorStr))block;

//询价卖出时可选的票据
+(void)requestTradeBillListWithPage:(NSInteger)page
                           billType:(NSInteger)billType
                           response:( void(^)(NSArray *dataArr,NSString *errorStr))block;

//报价卖出时可选的票据
+(void)requestTradeBillListWithPage:(NSInteger)page
                          inquiryId:(NSNumber*)inquiryId
                           response:( void(^)(NSArray *dataArr,NSString *errorStr))block;

+(void)requestDeleteStockWithBillId:(NSInteger)billId response:( void(^)(NSString *errorStr))block;

+(NSInteger)getBillIdWithModel:(id)model;

+(NSInteger)getBillStatusWithModel:(id)model;
@end
