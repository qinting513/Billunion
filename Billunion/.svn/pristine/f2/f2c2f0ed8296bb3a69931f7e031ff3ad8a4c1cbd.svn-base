
//
//  BuyViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/8.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyViewModel.h"
#import "StockModel.h"
#import "FGNetworking.h"

@implementation BuyViewModel

//+ (NSArray *)getBuyInfoData{
//    StockModel *model = [[StockModel alloc] init];
//    model.ProductCode = @"28098345";
//    model.Amount = @1000;
//    model.DiscountRate = @(5.12);
//    model.AcceptorType = @2;
//    model.AcceptorIdentityType = @2;
//    
//    model.DueTimeRange = @20;
//    model.Address = @"广州";
//    model.TradeStatus = @2;
//    model.CounterPartyName = @"普创";
//    return  [NSArray arrayWithObject:model];
//}

/*TradeRole 1询价买入 3指定买入 5报价买入 8被指定卖出 **/
+ (NSNumber *)getBuyTradeRoleWithViewPage:(NSInteger)page{
    switch (page) {
        case 0: return @1;
        case 1: return @3;
        case 2: return @5;
        case 3: return @8;
        default: return @1;
    }
}



+ (void)requestTradeManualListWithParams:(NSDictionary *)params response:(void (^)(NSArray *, NSString *))block{
    NSNumber *TradeRole = [params objectForKey:@"TradeRole"];
    DEBUGLOG(@"%@ \n %@",TRADE_MANUAL_LIST,params);
   [FGNetworking requsetWithPath:TRADE_MANUAL_LIST params:params method:Post handleBlcok:^(id response, NSError *error) {
       DEBUGLOG(@"%@\n%@",TRADE_MANUAL_LIST,response);
       if (!error) {
           int statusCode = [[response objectForKey:@"Status"] intValue];
           if ( statusCode == 0 && [response[@"Data"] isKindOfClass:[NSArray class]]) {
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
                       !block ?: block(nil,NSLocalizedString(@"NO_MORE_DATA", nil)  );
                   }
       }else{
           !block ?: block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
//           NSLog(@"网络请求出错：%@",error);
       }

   }];
}

+ (StockAllType)getStockType:(NSNumber *)tradeRole{
    switch ([tradeRole intValue]) {
        case 1:  return StockAllType_MyBuying_askBuying; //询价买入
        case 3:  return StockAllType_MyBuying_specifiedBuying; //指定买入
        case 5:  return StockAllType_MyBuying_quoteBuying;  //报价买入
        case 8:  return StockAllType_MyBuying_beSpecifiedSell;  //被指定卖出
        default: return StockAllType_MyBuying_askBuying;
    }
}

@end
