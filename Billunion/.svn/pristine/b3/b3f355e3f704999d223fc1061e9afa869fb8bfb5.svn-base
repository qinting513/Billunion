
//
//  TradeRecordViewModel.m
//  Billunion
//
//  Created by QT on 17/3/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "TradeRecordViewModel.h"
#import "FGNetworking.h"
#import "StockModel.h"

@implementation TradeRecordViewModel

+(void)requestTradeRecordsWithMarketType:(NSInteger)marketType
                                BillType:(NSInteger)billType
                                  page:(NSInteger)page
                               itemNum:(NSInteger)itemNum
                              response:( void(^)(NSArray *dataArr,NSString *errorStr))block
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /** 交易结果  1-交易完成   0-交易异常  */
//    params[@"TradeResult"] = @1;
    params[@"BillType"] = @[@(billType)];
    params[@"Page"]     = @(page);
    params[@"ItemNum"]  = @(itemNum);
    // tradeRole  /*TradeRole 1询价买入 3指定买入 5报价买入 8被指定卖出 **/
    if (marketType == 1) {
        params[@"TradeRole"] = @[@1,@3,@5,@8];
    }else if (marketType == 2){
        params[@"TradeRole"] = @[@2,@4,@6,@7];
    }else{
       params[@"TradeRole"] = @[@1,@2,@3,@4,@5,@6,@7,@8];
    }
    NSDictionary *paramsDict = @{
                                 @"OperType":@800,
                                  @"Param":params
                               };

    DEBUGLOG(@"%@\n%@",TRADE_RECORD,params);
    [FGNetworking requsetWithPath:TRADE_RECORD params:paramsDict method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@\n%@",TRADE_RECORD,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0 && [response[@"Data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *modelArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < [response[@"Data"] count]; i++) {
                    StockModel *model = [StockModel mj_objectWithKeyValues:response[@"Data"][i]];
                    if (marketType == 1) {
                         model.stockType = StockAllType_TradingRecord_Buyer_Market;
                    }else{
                         model.stockType = StockAllType_TradingRecord_Seller_Market ;
                    }
                    [modelArr addObject:model];
                }
                !block ?: block(modelArr,nil);
            }else{
                !block ?: block(nil,NSLocalizedString(@"NO_MORE_DATA", nil)  );
            }
        }else{
            !block ?: block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
//            NSLog(@"网络请求出错：%@",error);
        }
    }];

}

@end
