
//
//  TradeViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "TradeViewModel.h"
#import "StockModel.h"
#import "AssetsViewModel.h"
#import "FGNetworking.h"
#import "StockModel.h"
#import "CounterPartyModel.h"

@interface TradeViewModel ()
{
    CounterPartyModel *_counterPartyModel;
}

@end

@implementation TradeViewModel


/** 询价卖出  指定卖出 */
- (void)tradeBuyerInquiryAddWithAskBuyDict:(NSMutableDictionary *)askBuyDict response:(void(^)(NSString  *message))block
{
    //    NSDictionary *dic= @{@"TradeType":@1,@"BillType":@1,@"AcceptorIdentityType":@1,@"AcceptorType":@1,@"HolderIdentityType":@0,@"HolderType":@0,@"DueTimeRange":@5,@"Address":@"北京",@"TotalAmount":@210,@"DiscountRate":@1.12,@"CounterPartyId":@45};
    
    
    DEBUGLOG(@"%@\n%@",TRADE_BUYER_INQUIRY_ADD,askBuyDict);
    [FGNetworking requsetWithPath:TRADE_BUYER_INQUIRY_ADD params:askBuyDict method:Post handleBlcok:^(id response, NSError *error) {
        if (!error) {
                DEBUGLOG(@"%@\n%@",TRADE_BUYER_INQUIRY_ADD,response);
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                !block ?: block(NSLocalizedString(@"SUBMIT_OK", nil) );
               
            }else{
                if (block) {
                    // block([NSString stringWithFormat:@"提交失败，请重试。statusCode:%d",statusCode]);
                    !block ?: block(NSLocalizedString(@"SUBMIT_FAIL", nil) );
                }
            }
        }else{
          !block ?: block( NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
}

//询价卖出
- (void)tradeSellerInquiryAddWithParams:(NSDictionary *)params response:(void(^)(NSString  *message))block
{
//    NSDictionary *dic= @{@"TradeType":@1,@"BillType":@1,@"AcceptorIdentityType":@1,@"AcceptorType":@1,@"HolderIdentityType":@0,@"HolderType":@0,@"DueTimeRange":@5,@"Address":@"北京",@"TotalAmount":@210,@"DiscountRate":@1.12,@"CounterPartyId":@45};
    DEBUGLOG(@"%@ \n %@",TRADE_SELLER_INQUIRY_ADD,params);
    [FGNetworking requsetWithPath:TRADE_SELLER_INQUIRY_ADD params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",TRADE_SELLER_INQUIRY_ADD,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                if (block) {
                  !block ?: block(NSLocalizedString(@"SUBMIT_OK", nil) );
                }
            }else{
                if (block) {
                 !block ?: block(NSLocalizedString(@"SUBMIT_FAIL", nil) );
                }
            }
        }else{
            // NSLog(@"网络请求出错：%@",error);
             block(NSLocalizedString(@"ERROR_NETWORK", nil));
            
        }
    }];
}

/** 询价卖出  指定卖出 */
- (void)selectToSell:(NSArray *)modelArray
          tradeMode:(NSNumber *)tradeMode
           tradeType:(NSNumber *)tradeType
      counterPartyId:(NSNumber *)counterPartyId
    needOrCanReceipt:(NSNumber *)needOrCanReceipt
        depositBanks:(NSArray *)depositBanks
            response:(void(^)(NSString  *message))block{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableArray *BillRecordsArray = [[NSMutableArray alloc] init];
    
    if (modelArray.count == 0 || !tradeMode || !tradeType) {
        return;
    }
    
    for (id model in modelArray) {
        NSMutableDictionary  *BillRecords = [[NSMutableDictionary alloc] init];
        if ([model valueForKey:@"DiscountRate"]) {
            [BillRecords setObject:@([[model valueForKey:@"DiscountRate"] floatValue]) forKey:@"DiscountRate"];
        }
        if ([model valueForKey:@"BillId"]) {
            [BillRecords setObject:[model valueForKey:@"BillId"] forKey:@"BillId"];
        }
        
        if (BillRecords) {
            [BillRecordsArray addObject:BillRecords];
        }

    }
    
    [params setObject:tradeMode forKey:@"TradeMode"];
    [params setObject:tradeType forKey:@"TradeType"];
    [params setObject:BillRecordsArray forKey:@"BillRecords"];

    if (counterPartyId) {
        [params setObject:counterPartyId forKey:@"CounterPartyId"];
    }
    
    if (needOrCanReceipt) {
        [params setObject:needOrCanReceipt forKey:@"NeedOrCanReceipt"];
    }
    if (depositBanks) {
        [params setObject:depositBanks forKey:@"DepositBanks"];
    }
    
//    NSDictionary *dic = @{@"TradeType":@0,@"TradeMode":@1,@"BillRecords":@[@{@"BillId":@100064,@"DiscountRate":@14.0}]};
    
    [self tradeSellerInquiryAddWithParams:params response:^(NSString *message) {
        if (block) {
            block(message);
        }
    }];
}


+ (void)tradeSelectWithInquiryId:(NSNumber *)inquiryId
                         offerId:(NSNumber *)offerId
                    tradeRecords:(NSArray *)tradeRecords
                        response:( void(^)(BOOL isSeccess,NSString *message))block{
    if (!inquiryId || !offerId || tradeRecords.count == 0) {
        block(NO, NSLocalizedString(@"TRADE_FAIL", nil));
        return;
    }
    NSDictionary *params = @{@"InquiryId":inquiryId,@"OfferId":offerId,@"TradeRecords":tradeRecords};
    DEBUGLOG(@"%@ \n %@",TRADE_DEAL_SELECT,params);
  [FGNetworking requsetWithPath:TRADE_DEAL_SELECT params:params method:Post handleBlcok:^(id response, NSError *error) {
      DEBUGLOG(@"%@ \n %@",TRADE_DEAL_SELECT,response);
      if (!error) {
          if ([response[@"Status"] intValue] == 0) {
              block(YES, NSLocalizedString(@"TRADE_OK", nil));
          }else{
              block(NO,NSLocalizedString(@"TRADE_FAIL", nil));
          }
      }
  }];
}

+ (void)searchAcceptorWithBillType:(NSNumber *)billType
                           keyWord:(NSArray *)keyWord
                              page:(NSInteger)page
                          response:(void(^)(NSArray  *array))block{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (keyWord.count == 0) {
        return;
    }
    
    if (!billType) {
        return;
    }
    params[@"KeyWord"] = keyWord;
    params[@"BillType"] = billType;
    params[@"Page"] = @(page);
    params[@"ItemNum"] = @(20);
     DEBUGLOG(@"%@\n%@",ACCEPTOR_LIST,params);
  [FGNetworking requsetWithPath:ACCEPTOR_LIST params:params method:Post handleBlcok:^(id response, NSError *error) {
        DEBUGLOG(@"%@\n%@",ACCEPTOR_LIST,response);
      if ([response[@"Status"] integerValue] == 0) {
          NSMutableArray *array = [[NSMutableArray alloc] init];
          for (NSDictionary *dataDic in response[@"Data"] ) {
              if (dataDic[@"EntityName"] && ![dataDic[@"EntityName"] isKindOfClass:[NSNull class]]) {
                  [array addObject: dataDic[@"EntityName"]];
              }
          }
          block(array);
      }
  }];
}

+ (void)searchVisitorWithKeyWord:(NSString *)keyWord
                        response:(void(^)(NSArray  *array))block{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"OperType"] = @206;
    if (keyWord && keyWord.length > 0) {
        params[@"Param"] = @{@"KeyWord":keyWord};
    }
    DEBUGLOG(@"%@\n%@",VISITOR_SEARCH,params);
    [FGNetworking requsetWithPath:VISITOR_SEARCH params:params method:Post handleBlcok:^(id response, NSError *error) {
        DEBUGLOG(@"%@\n%@",VISITOR_SEARCH,response);
        if ([response[@"Status"] integerValue] == 0) {
            NSArray *CounterPartyarray = [CounterPartyModel mj_objectArrayWithKeyValuesArray:response[@"Data"][@"CompanyList"]];
            block(CounterPartyarray);
        }
    }];
}


+ (BOOL)judgeHaveDiscountRate:(NSArray *)selectArray{
    for (StockModel *model in selectArray) {
        if (!model.DiscountRate) {
            return NO;
        }
    }
    return YES;
}

+ (NSArray *)changeToTradeWithArray:(NSArray *)array{
    NSMutableArray *modelDicArray = [[NSMutableArray alloc] init];
    for (StockModel *model in array) {
      StockModel *newModel = [StockModel mj_objectWithKeyValues:model.mj_keyValues];
        newModel.stockType = StockAllType_BillDetail;
        [modelDicArray addObject:newModel];
    }
    return modelDicArray;

}

+ (void)resetDiscountRate:(NSNumber *)discountRate stockModel:(id)model{
    StockModel *stockModel = (StockModel *)model;
    stockModel.DiscountRate = discountRate;
    stockModel.stockType = StockAllType_BillDetail;
}

+ (BOOL)judgeTheSameOfBillList:(NSArray *)billList{
    StockModel *model = [billList firstObject];
    for (StockModel *stockModel in billList) {
        if (stockModel.AcceptorIdentityType != model.AcceptorIdentityType) {
            return NO;
        }else{
            if (stockModel.AcceptorType != model.AcceptorType) {
                return NO;
            }else{
                if (stockModel.DueTimeRange != model.DueTimeRange) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

+ (NSNumber *)getDiscountRateWithStockModel:(id)model{
    StockModel *stockModel = (StockModel *)model;
    return  stockModel.DiscountRate;
}


- (void)setCurrentCounterPartyModel:(id)counterPartyModel{
    if ([counterPartyModel isKindOfClass:[CounterPartyModel class]]) {
          _counterPartyModel = counterPartyModel;
    }
}

- (NSNumber *)getCurrentCounterPartyId{
    return  _counterPartyModel.Id;
}

+ (NSString *)getCounterPartyNameWithModel:(id)counterPartyModel{
    if ([counterPartyModel isKindOfClass:[CounterPartyModel class]]) {
        CounterPartyModel *model = counterPartyModel;
        return model.Name;
    }
    return nil;
}


@end
