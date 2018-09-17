
//
//  SellViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "SellViewModel.h"
#import "StockModel.h"
#import "FGNetworking.h"

@implementation SellViewModel


+ (NSNumber *)getSellTradeRoleWithViewPage:(NSInteger)page{
    switch (page) {
        case 0: return @2;
        case 1: return @4;
        case 2: return @6;
        case 3: return @7;
        default: return @2;
    }
}


+ (void)requestManualListWithParams:(NSDictionary *)params response:(void (^)(NSArray *, NSString *))block{
    NSNumber *TradeRole = [params objectForKey:@"TradeRole"];
    DEBUGLOG(@"%@\n%@",TRADE_MANUAL_LIST,params);
    [FGNetworking requsetWithPath:TRADE_MANUAL_LIST params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@\n%@",TRADE_MANUAL_LIST,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                if ([response[@"Data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [response[@"Data"] count]; i++) {
                        StockModel *model = [StockModel mj_objectWithKeyValues:response[@"Data"][i]];
                        model.DueTimeRange = model.DueTime;
                        model.stockType = [self getStockType:TradeRole];
                        [modelArr addObject:model];
                    }
                    //                NSArray *modelArr = [MarketModel mj_objectArrayWithKeyValuesArray:response[@"Data"]];
                    !block ?: block(modelArr,nil);
                }else{
                    !block ?: block(nil,NSLocalizedString(@"NO_MORE_DATA", nil) );
                
                }
            }else{
                 !block ?: block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
        }else{
         !block ?: block(nil, NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
        
    }];
}

+ (StockAllType)getStockType:(NSNumber *)tradeRole{
    switch ([tradeRole intValue]) {
        case 2:  return  StockAllType_MySell_askSell;     //询价卖出
        case 4:  return  StockAllType_MySell_specifiedSell;     //指定卖出
        case 6:  return  StockAllType_MySell_quoteSell;        //报价卖出
        case 7:  return  StockAllType_MySell_beSpecifiedBuying;  //被指定买入
       default:  return  StockAllType_MySell_askSell;
    }
}




@end
