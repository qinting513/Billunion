
//
//  KLineViewModel.m
//  Billunion
//
//  Created by Waki on 2017/1/18.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "KLineViewModel.h"
#import "FGNetworking.h"
#import "KlineModel.h"
#import "LocationViewModel.h"
#import "SellDetailModel.h"
#import "BuyerDetailModel.h"
#import "StockModel.h"
#import "MapModel.h"

//询价方model
#import "OfferModel.h"


@interface KLineViewModel (){
  
    NSNumber *_inquiryId;
    
    NSArray *_sellerBillList;// 询价方要买的票的数组  里面都是票的数据
    NSArray *_offerList; // 报价方列表
    SellDetailModel *_sellDetailModel;
    BuyerDetailModel *_buyDetailModel;
}


@end
@implementation KLineViewModel


- (void)requestDetailWithsType:(KLINE_TYPE)type response:(void(^)(BOOL isSuccess,NSString *message,id data))block{
    NSString *path;
    NSNumber *operType;
    NSNumber *InquiryId;
    if (type == KLine_buyerInquiry ||
        type == KLine_buyerSpecify ||
        type == KLine_sellerOffer ||
        type == KLine_beBuyerSpecify ||
        type == KLine_buyerMarket) {
        //查询买方市场询价详情
        path = BUYER_INQUIRY_DETAIL;
        operType = @303;
    }else{
        //查询卖方市场询价详情
        path = SELLER_INQUIRY_DETAIL;
        operType = @302;
    }
    
    InquiryId = _inquiryId;
    if (!InquiryId) {
        block(NO,NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) ,nil);
        return;
    }
    NSDictionary *params = @{@"OperType":operType,
                             @"Param":@{@"Id":InquiryId}
                             };
    DEBUGLOG(@"%@\n%@",path,params);
    [FGNetworking requsetWithPath:path params:params method:Post handleBlcok:^(id response, NSError *error) {
             DEBUGLOG(@"%@ \n %@",path,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                if (response[@"Data"] && ![response[@"Data"] isKindOfClass:[NSNull class]]) {
                    if (path == BUYER_INQUIRY_DETAIL) {
                        _buyDetailModel = [BuyerDetailModel mj_objectWithKeyValues:response[@"Data"]];
                    }else{
                        _sellDetailModel = [SellDetailModel mj_objectWithKeyValues:response[@"Data"]];
                        NSMutableArray *mArray = [[NSMutableArray alloc] init];
                        NSArray *arr = response[@"Data"][@"BillList"];
                        if ( ![response[@"Data"][@"BillList"] isKindOfClass:[NSNull class]] && arr.count > 0) {
                            for (NSDictionary *dataDic in arr) {
                                StockModel *model = [StockModel mj_objectWithKeyValues:dataDic];
                                model.BillType = _sellDetailModel.BillType;
                                model.AcceptorIdentityType = _sellDetailModel.AcceptorIdentityType;
                                model.AcceptorType = _sellDetailModel.AcceptorType;
                                model.DiscountRate = model.TradeRate;
                                model.stockType = StockAllType_Select_Trade;
                                [mArray addObject:model];
                            }
 
                        }
                       _sellerBillList = mArray;
                    }
                    !block ?: block(YES,NSLocalizedString(@"ERROR_GET_DATA_OK", nil),response[@"Data"]);
                }
            }else{
                !block ?: block(NO,NSLocalizedString(@"ERROR_DATA", nil) ,nil);
            }
        }else{
            block(NO,NSLocalizedString(@"ERROR_NETWORK", nil)  ,nil);
//            NSLog(@"网络请求出错：%@",error);
        }
    }];
}



///** 获取询价方 */
//-(id)getAskBuyerDataWithType:(KLINE_TYPE)type{
//    if (type == KLine_buyerInquiry ||
//        type == KLine_buyerSpecify ||
//        type == KLine_buyerOffer ||
//        type == KLine_beSellerSpecify ||
//        type == KLine_buyerMarket) {
//        return [_buyDetailModel mj_keyValues];
//    }else{
//        return [_sellerBillList mj_keyValues];
//    }
//}

//[0]	(null)	@"Amount" : (long)999999	
//[1]	(null)	@"BillAdress" : @"广东广州天河"	
//[2]	(null)	@"ProductType" : (no summary)	
//[3]	(null)	@"BillType" : (long)1	
//[4]	(null)	@"DueTime" : (long)1	
//[5]	(null)	@"DiscountRate" : (no summary)	
//[6]	(null)	@"BillList" : @"1 element"	
//[7]	(null)	@"ProductCode" : @"101010400020170218095920"	
//[8]	(null)	@"AcceptorType" : (long)1	
//[9]	(null)	@"Address" : @"广东广州天河"	
//[10]	(null)	@"OfferName" : @"交通银行"	
//[11]	(null)	@"OfferId" : (long)10079	
//[12]	(null)	@"Holder" : @"任南川"	
//[13]	(null)	@"InquiryId" : (long)1107	
//[14]	(null)	@"HolderType" : (long)1	
//[15]	(null)	@"HolderIdentityType" : (long)1	
//[16]	(null)	@"AcceptorIdentityType" : (long)1

- (void)requestRateMarketTrendWithType:(K_RATE_MARKET_TYPE)type
                             kLineType:(KLINE_TYPE)klineType
                              response:(void(^)(NSArray *dataArray,NSString *errorStr))block{
    
    NSNumber *BillType;
    NSNumber *AcceptorType;
    NSNumber *DueTimeRange;
    if (klineType == KLine_buyerInquiry ||
        klineType == KLine_buyerSpecify ||
        klineType == KLine_buyerOffer ||
        klineType == KLine_beSellerSpecify ||
        klineType == KLine_buyerMarket) {
        BillType = _buyDetailModel? _buyDetailModel.BillType : nil;
        AcceptorType = _buyDetailModel? _buyDetailModel.AcceptorType : nil;
        DueTimeRange = _buyDetailModel? _buyDetailModel.DueTimeRange : nil;
    }else{
        BillType = _sellDetailModel? _sellDetailModel.BillType : nil;
        AcceptorType = _sellDetailModel? _sellDetailModel.AcceptorType : nil;
        DueTimeRange = _sellDetailModel? _sellDetailModel.DueTimeRange : nil;
    }
    if (!BillType || !AcceptorType || !DueTimeRange) {
        block(nil, NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) );
        return;
    }
    
    NSDictionary *params = @{
                              @"OperType":@308,
                              @"Param":@{
                                      @"ChartType":[NSNumber numberWithInteger:type],
                                      @"AcceptorType":AcceptorType,
                                      @"BillType":BillType,
                                      @"DueTimeRange":DueTimeRange
                                      }
                              };
     DEBUGLOG(@"%@\n%@",RATE_MARKET_TREND,params);
    [FGNetworking requsetWithPath:RATE_MARKET_TREND params:params method:Post handleBlcok:^(id response, NSError *error) {
        if (!error) {
            DEBUGLOG(@"%@\n%@",RATE_MARKET_TREND,response);
            if ([response[@"Status"] intValue] == 0) {
                if (response[@"Data"] && ![response[@"Data"] isKindOfClass:[NSNull class]]) {
                    if ( [response[@"Data"][@"Time"] count] == [response[@"Data"][@"Value"] count]) {
                        NSMutableArray *array = [[NSMutableArray alloc] init];
                        for (int i = 0; i < [response[@"Data"][@"Time"] count]; i++) {
                            KlineModel *model = [[KlineModel alloc] init];
                            model.timeDate = response[@"Data"][@"Time"][i];
                            NSNumber *value = response[@"Data"][@"Value"][i];
                            model.percent = [NSString stringWithFormat:@"%.3f",[value floatValue]];
                            [array addObject:model];
                        }
                        block(array,nil);
                    }
                }
                
            }
        }
    }];
}

// 报价方信息请求
- (void)requestOfferListWithType:(KLINE_TYPE)type response:(void (^)(NSArray *, NSString *))block{
   
    NSString *path;
    NSNumber *operType;
    if (type == KLine_buyerInquiry ||
        type == KLine_buyerSpecify ||
        type == KLine_sellerOffer ||
        type == KLine_beBuyerSpecify ||
        type == KLine_buyerMarket) {
        path = BUYER_OFFER_LIST;
        operType = @305;
    }else{
        path = SELLER_OFFER_LIST;
        operType = @304;
    }
    
    if (!_inquiryId) {
//        block(nil,@"报价列表获取失败");
        block(nil, NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) );
        return;
    }
    
    NSDictionary *params = @{@"OperType":operType,
                             @"Param":@{@"Id":_inquiryId}};
    DEBUGLOG(@"%@\n%@",path,params);
//    __weak typeof(self) weakSelf = self;
   [FGNetworking requsetWithPath:path params:params method:Post handleBlcok:^(id response, NSError *error) {
       if (!error) {
           DEBUGLOG(@"%@\n%@",path,response);
           if ([response[@"Status"] intValue] == 0 && ![response[@"Data"] isKindOfClass:[NSNull class]]) {
               NSMutableArray *offerModelArr = [[NSMutableArray alloc] init];
               for (int i = 0; i < [response[@"Data"] count]; i++) {
                   OfferModel *model = [OfferModel mj_objectWithKeyValues:response[@"Data"][i]];
                   model.InquiryId = _inquiryId;
                   //如果此报价方是自己 顶置处理
                   if ([[Config getCompanyId] intValue] == [model.CompanyId intValue]) {
                        model.isMe = YES;
                        [offerModelArr insertObject:model atIndex:0];
                   }else{
                        [offerModelArr addObject:model];
                   }
               }
               _offerList = offerModelArr;
               block(offerModelArr,nil);
           }
       }
   }];
}

#pragma mark - 点击买入 进行报价 
+ (void)tradeBuyerOfferWithBillRecords:(NSArray *)billRecords
                           isAnonymous:(NSNumber *)isAnonymous
                             inquiryId:(NSNumber *)inquiryId
                              tradeTime:(NSNumber *)tradeTime
                      needOrCanReceipt:(NSNumber *)needOrCanReceipt
                        targetCustomer:(NSNumber *)targetCustomer
                               address:(NSString *)address
                              response:(void(^)(NSString *message,BOOL isFailLocation))block{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (inquiryId) {
        params[@"InquiryId"] = inquiryId;
    }else{
        return block( NSLocalizedString(@"QUOTE_FAIL", nil) ,NO);
    }
    if (billRecords.count != 0) {
        [params setObject:billRecords forKey:@"BillRecords"];
    }
    
    if (tradeTime) {
        params[@"TradeTime"] = tradeTime;
    }
    if (needOrCanReceipt) {
        params[@"NeedOrCanReceipt"] = needOrCanReceipt;
    }
    
    if (isAnonymous) {
         [params setObject:isAnonymous forKey:@"IsAnonymous"];
    }
   
    if (address == nil) {
        
                //获取当前的询价买入的地址
                __weak typeof(self) weakSelf = self;
                [[LocationViewModel shareInstance] getCurrentCityCompletionBlock:^(NSString *location,NSString*city) {
                    if (!location) {
                        block(@"定位失败,填写地址后自动报价",YES);
                    }else{
                        [params setObject:location forKey:@"Address"];
                        DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_ADD,params);
                        [weakSelf requestWithParams:params response:block];
                    }
                }];
    }else{
        [params setObject:address forKey:@"Address"];
        DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_ADD,params);
        [self requestWithParams:params response:block];
    }
  
}

+(void)requestWithParams:(NSDictionary*)params  response:(void(^)(NSString *message,BOOL isFailLocation))block {
    [FGNetworking requsetWithPath:TRADE_BUYER_OFFER_ADD params:params method:Post handleBlcok:^(id response, NSError *error) {
        if (!error) {
            DEBUGLOG(@"%@ \n %@",TRADE_BUYER_OFFER_ADD,response);
            if ([response[@"Status"] intValue] == 0) {
                block( NSLocalizedString(@"QUOTE_OK", nil) ,NO);
            }else{
                block( nil ,NO);
            }
        }
    }];
}

// 卖出
+ (void)tradeSellerOfferWithBillRecords:(NSArray *)billRecords
                            isAnonymous:(NSInteger)isAnonymous
                              inquiryId:(NSNumber *)inquiryId
                              tradeMode:(NSInteger)tradeMode
                       needOrCanReceipt:(NSNumber *)needOrCanReceipt
                               response:(void(^)(BOOL isSecceed , NSString *message))block{
    if (inquiryId && billRecords.count != 0) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

        if (billRecords.count != 0) {
            params[@"BillRecords"] = billRecords;
        }
        if (inquiryId) {
            params[@"InquiryId"] = inquiryId;
        }
        if (needOrCanReceipt) {
            params[@"NeedOrCanReceipt"] = needOrCanReceipt;
        }
        params[@"IsAnonymous"] = [NSNumber numberWithInteger:isAnonymous];
        params[@"TradeMode"] = [NSNumber numberWithInteger:tradeMode];
        

        
        DEBUGLOG(@"%@\n%@",TRADE_SELLER_OFFER_ADD,params);
        [FGNetworking requsetWithPath:TRADE_SELLER_OFFER_ADD params:params method:Post handleBlcok:^(id response, NSError *error) {
            if(!error){
                 DEBUGLOG(@"%@ \n %@",TRADE_SELLER_OFFER_ADD,response);
                if ([response[@"Status"] intValue] == 0) {
                    block(YES, NSLocalizedString(@"QUOTE_OK", nil) );
                }else{
                    block(NO,nil );
                }
            }else{
                block(NO, NSLocalizedString(@"ERROR_NETWORK", nil) );
            }
        }];
    }
}


- (void)tradeDeleteWithType:(KLINE_TYPE)type response:(void(^)(BOOL isSecceed, NSString *message))block{
    NSNumber *Id;
    NSString *path;
   
    if (type == KLine_buyerInquiry || type == KLine_buyerSpecify) { //询价买入删除
        Id = _inquiryId;
        path = TRADE_BUYER_INQUIRY_DELETE;
    }else if (type == KLine_sellerInquiry || type == KLine_sellerSpecify){ //询价卖出删除
         Id = _inquiryId;
        path = TEADE_SELLER_INQUIRY_DELETE;
    }else if (type == KLine_buyerOffer || type == KLine_beSellerSpecify){ //报价买入删除
        Id = [self getOfferId];
        path  = TRADE_BUYER_OFFER_DELETE;
    }else if (type == KLine_sellerOffer || type == KLine_beBuyerSpecify){ //报价卖出删除
        Id = [self getOfferId];
        path = TRADE_SELLER_OFFER_DELETE;
    }else{
        return ;
    }

    if (!Id) {
         block(NO, NSLocalizedString(@"UNDO_FAIL", nil));
         DEBUGLOG(@"%@  Id不存在",path);
         return;
    }

    NSDictionary *params = @{@"Id":Id};
    DEBUGLOG(@"%@\n%@",path,params);
         [FGNetworking requsetWithPath:path params:params method:Post handleBlcok:^(id response, NSError *error) {
             if (!error) {
                 DEBUGLOG(@"%@\n%@",path,response);
                 int statusCode = [[response objectForKey:@"Status"] intValue];
                 if ( statusCode == 0) {
                     block(YES, NSLocalizedString(@"UNDO_OK", nil) );
                 }else{
                     block(NO, NSLocalizedString(@"UNDO_FAIL", nil) );
                 }
             }
        }];
  
}

- (void)resetBuyerInquiryWithInquiryId:(NSNumber *)inquiryId
                          discountRate:(NSNumber *)discountRate
                              response:(void(^)(BOOL isSecceed,NSString *message))block{
//    "InquiryId":1, //询价id
//    "BillType":1, //票据类型
//    "AcceptorIdentityType":1, //承兑人大类
//    "AcceptorType":1, //承兑人小类
//    "HolderIdentityType":1, //持票人大类
//    "HolderType":1, //持票人小类
//    "DueTime":1, //票据期限类型
//    "Address":"xxx", //票据地址
//    "TotalAmount":1000000, //金额
//    "DiscountRate":3.5, //贴现率
    if (!inquiryId || !discountRate || !_buyDetailModel.Amount) {
         block(NO, NSLocalizedString(@"QUOTE_RESET_FAIL", nil) );
        return;
    }
    
    NSDictionary *params = @{ @"InquiryId":inquiryId,
                              @"DiscountRate":discountRate,
                              @"TotalAmount":_buyDetailModel.Amount
                              };
    DEBUGLOG(@"%@ \n %@",TRADE_BUYER_INQUIRY_MODIFY,params);
    [FGNetworking requsetWithPath:TRADE_BUYER_INQUIRY_MODIFY params:params method:Post handleBlcok:^(id response, NSError *error) {
        if(!error){
            DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_MODIFY,response);
            if ([response[@"Status"] intValue] == 0) {
                block(YES, NSLocalizedString(@"QUOTE_RESET_OK", nil) );
            }else{
                block(NO, NSLocalizedString(@"QUOTE_RESET_FAIL", nil) );
            }
        }else{
            block(NO, NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
    
    
}

+ (void)resetSellerInquiryWithInquiryId:(NSNumber *)inquiryId
                            billRecords:(NSArray *)billRecords
                               response:(void(^)(BOOL isSecceed,NSString *message))block{
    
//        "InquiryId":1, //询价id
//        "BillRecords":[{"BillId":1001,"DiscountRate":5.5}] //票据列表
    if (billRecords.count <= 0 || !inquiryId) {
        block(NO, NSLocalizedString(@"QUOTE_RESET_FAIL", nil) );
        return;
    }
     NSDictionary *params = @{@"InquiryId":inquiryId,@"BillRecords":billRecords};
    DEBUGLOG(@"%@\n%@",TEADE_SELLER_INQUIRY_MODIFY,params);
    [FGNetworking requsetWithPath:TEADE_SELLER_INQUIRY_MODIFY params:params method:Post handleBlcok:^(id response, NSError *error) {
        if(!error){
            DEBUGLOG(@"%@\n%@",TEADE_SELLER_INQUIRY_MODIFY,response);
            if ([response[@"Status"] intValue] == 0) {
                block(YES,  NSLocalizedString(@"QUOTE_RESET_OK", nil));
            }else{
                block(NO,  NSLocalizedString(@"QUOTE_RESET_FAIL", nil));
            }
        }else{
            block(NO,  NSLocalizedString(@"ERROR_NETWORK", nil));
        }

    }];
}


#pragma mark - 报价买入 修改报价
+ (void)resetBuyerOfferWithBillRecords:(NSArray *)billRecords
                                offerId:(NSNumber *)offerId
                                address:(NSString *)address
                               response:( void(^)(NSString *message,BOOL isFailLocation) )block{
//    "OfferId":1000, //报价id
//    "IsAnonymous":1, //0不匿名 1匿名
//    "Address":"xxx", //报价方地址
//    "BillRecords":[{"BillId":1000,"DiscountRate":5.5}] //报价信息
    if (billRecords.count <= 0 || !offerId) {
            block( NSLocalizedString(@"QUOTE_RESET_FAIL", nil),NO);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"OfferId"] = offerId;
    params[@"BillRecords"] = billRecords;
    if (address == nil) {

            //获取当前的询价买入的地址
            __weak typeof(self) weakSelf = self;
            [[LocationViewModel shareInstance] getCurrentCityCompletionBlock:^(NSString *location,NSString*city) {
                if (!location) {
                    block(@"定位失败,填写地址后即可修改报价",YES);
                }else{
                    [params setObject:location forKey:@"Address"];
                    DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_MODIFY,params);
                    [weakSelf resetBuyerOfferWithParams:params response:block];
                }
            }];
    }else{
        [params setObject:address forKey:@"Address"];
        DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_MODIFY,params);
        [self resetBuyerOfferWithParams:params response:block];
    }

}
// 上一个方法调用
+(void)resetBuyerOfferWithParams:(NSDictionary*)params  response:(void(^)(NSString *message,BOOL isFailLocation))block{
    DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_MODIFY,params);
    [FGNetworking requsetWithPath:TRADE_BUYER_OFFER_MODIFY params:params method:Post handleBlcok:^(id response, NSError *error) {
        if(!error){
            DEBUGLOG(@"%@\n%@",TRADE_BUYER_OFFER_MODIFY,response);
            if ([response[@"Status"] intValue] == 0) {
                block(NSLocalizedString(@"QUOTE_RESET_OK", nil), NO);
            }else{
                block(NSLocalizedString(@"QUOTE_RESET_FAIL", nil), NO);
            }
        }else{
            block(NSLocalizedString(@"ERROR_NETWORK", nil), NO);
        }
    }];

}

#pragma mark - 报价卖出 修改报价
+ (void)resetSellerOfferWithBillRecords:(NSArray *)billRecords
                              TradeMode:(NSNumber *)tradeMode
                                 offerId:(NSNumber *)offerId
                                response:(void(^)(BOOL isSecceed,NSString *message))block{
//    "OfferId":1000, //报价id
//    "IsAnonymous":1, //0不匿名 1匿名
//    "TradeMode":1, //交易模式（挑票或整批）
//    "BillRecords":[{"BillId":1000,"DiscountRate":5.5}] //报价信息
    
    if (billRecords.count <= 0 || !offerId) {
        // 修改报价失败
        block(NO,  NSLocalizedString(@"QUOTE_RESET_FAIL", nil));
        return;
    }
    
    if (!tradeMode &&  (![tradeMode isEqual:@1] || ![tradeMode isEqual:@2])) {
        block(NO,  NSLocalizedString(@"QUOTE_RESET_FAIL", nil));
        return;
    }

     NSDictionary *params = @{@"OfferId":offerId,@"TradeMode":tradeMode,@"BillRecords":billRecords };
    
     DEBUGLOG(@"%@\n%@",TRADE_SELLER_OFFER_MODIFY,params);
    [FGNetworking requsetWithPath:TRADE_SELLER_OFFER_MODIFY params:params method:Post handleBlcok:^(id response, NSError *error) {
        if(!error){
            DEBUGLOG(@"%@\n%@",TRADE_SELLER_OFFER_MODIFY,response);
            if ([response[@"Status"] intValue] == 0) {
                 block(YES,  NSLocalizedString(@"QUOTE_RESET_OK", nil));
            }else{
                 block(NO,  NSLocalizedString(@"QUOTE_RESET_FAIL", nil));
            }
        }else{
                block(NO,  NSLocalizedString(@"ERROR_NETWORK", nil));
        }
    }];
}




- (void)getOfferItemListWithKlineType:(KLINE_TYPE)klineType response:(void (^)(BOOL isOffered, NSArray *))block{
    //    self.kLineType == KLine_beSellerSpecify || //被指定卖出 修改报价
    //    self.kLineType == KLine_sellerSpecify || //指定卖出 修改报价
    //    self.kLineType == KLine_sellerOffer || //报价卖出 修改报价
    //    self.kLineType == KLine_beBuyerSpecify 被指定买入 修改报价
    //    self.kLineType == KLine_buyerOffer ||  //报价买入 修改报价
    //    self.kLineType == KLine_sellerInquiry)    //询价卖出 修改报价
    
    NSMutableArray *billArray = [[NSMutableArray alloc] init];
    if (klineType == KLine_sellerSpecify) {   //指定卖出 修改报价
        block(NO,[self getBillDetailList]);
    }else if (klineType == KLine_beSellerSpecify){  //被指定卖出 修改报价
        if (_offerList.count == 0) { //没有报价方，证明没有进行报价
            block(NO,[self getBillDetailList]);
        }else{
            for (OfferModel *model in _offerList) {
                for (NSDictionary *billDic in model.OfferItemList) {
                    StockModel *stockModel = [StockModel mj_objectWithKeyValues:billDic];
                    stockModel.stockType = StockAllType_BillDetail;
                    [billArray addObject:stockModel];
                }
            }
            block(YES,billArray);
        }
    }else if (klineType == KLine_beBuyerSpecify){  //被指定买入 修改报价
        
        if (_offerList.count == 0){
            block(NO,nil);
        }else{
            for (OfferModel *model in _offerList) {
                for (NSDictionary *billDic in model.OfferItemList) {
                    StockModel *stockModel = [StockModel mj_objectWithKeyValues:billDic];
                    stockModel.stockType = StockAllType_BillDetail;
                    [billArray addObject:stockModel];
                }
            }
            block(YES,billArray);
        }
    }else if ( klineType == KLine_sellerOffer ||  //报价卖出 修改报价
              klineType == KLine_buyerOffer){   // 报价买入 修改报价
        for (OfferModel *model in _offerList) {
            if ([model.CompanyId intValue] == [[Config getCompanyId] intValue]) { //先找出属于我的报价信息
                for (NSDictionary *billDic in model.OfferItemList) {
                    StockModel *stockModel = [StockModel mj_objectWithKeyValues:billDic];
                    stockModel.stockType = StockAllType_BillDetail;
                    [billArray addObject:stockModel];
                }
                block(YES,billArray);
                break;
            }
        }
    
    }else if (klineType == KLine_sellerInquiry){  //询价卖出  修改报价
        block(NO,[self getBillDetailList]);
    }else if (klineType == KLine_sellerMarket || klineType == KLine_nearStock){
        block(NO,[self getBillDetailList]);
    }
}



- (void)setCurrentModel:(id)model type:(KLINE_TYPE)klienType{
    if ([model isKindOfClass:[StockModel class]]) {
        if (klienType == KLine_buyerMarket ||  klienType == KLine_sellerMarket) {
            _inquiryId = ((StockModel *)model).InquiryId;
        }else{
            _inquiryId = ((StockModel *)model).Id;
        }
    }else{
        if(klienType == KLine_nearStock){
            _inquiryId = ((MapModel *)model).InquiryId;
        }
    }
}

#pragma mark - 获取地址 作票源地址
-(NSArray *)getBillAddressWithKlineType:(KLINE_TYPE)klineType{
    if ( _sellDetailModel) { // 询价方 想卖票 多个人想买
        NSLog(@"-------------- CompanyId: %@-%@",_sellDetailModel.OfferId,[Config getCompanyId]);
        if (_sellDetailModel.OfferId.integerValue == [Config getCompanyId].integerValue) {
    // isMe(isMe的意义 就是这张票是不是我发布的,是我发布的我就可以看到多个报价方)  获取多个报价方 _quoteList 一对多关系
          return [self getMapModelListWithKlineType:klineType];
        }else {
    // notIsMe 这票不是我发布的，地图定位到我跟这张票的距离 一对一关系
            MapModel *mapModel = [[MapModel alloc]init];
            mapModel.CompanyName = _sellDetailModel.OfferName;
            mapModel.DiscountRate = _sellDetailModel.DiscountRate;
            mapModel.Amount = _sellDetailModel.Amount;
            mapModel.InquiryId = _inquiryId;
            mapModel.Remarks = [_sellerBillList.firstObject Remarks];
            mapModel.kLineType = klineType;
            mapModel.TradeMode = _sellDetailModel.TradeMode;
            return @[mapModel];
        }
    }else if( _buyDetailModel ){
        // 询价方想买票 多个人想卖给我
       NSLog(@"-------------- CompanyId: %@-%@",_buyDetailModel.OfferId,[Config getCompanyId]);
        if (_buyDetailModel.OfferId.integerValue == [Config getCompanyId].integerValue) {
            return [self getMapModelListWithKlineType:klineType];
        }else {
            MapModel *mapModel = [[MapModel alloc]init];
            mapModel.Remarks = _buyDetailModel.Address;
            mapModel.DiscountRate = _buyDetailModel.DiscountRate;
            mapModel.InquiryId = _inquiryId;
            mapModel.Amount =    _buyDetailModel.Amount;
            mapModel.CompanyName = _buyDetailModel.OfferName;
            mapModel.kLineType = klineType;
           // mapModel.TradeMode = _buyDetailModel.TradeMode;
            return @[mapModel];
        }
    }
    return nil;
}

-(NSArray *)getMapModelListWithKlineType:(KLINE_TYPE)klineType{
    NSMutableArray *arr = [NSMutableArray array];
    for (OfferModel*mm in _offerList) {
        MapModel *mapModel = [[MapModel alloc]init];
        mapModel.CompanyId = mm.CompanyId;
        mapModel.OfferId = mm.Id;
        mapModel.CompanyName = mm.OfferName;
        mapModel.Amount = mm.Amount;
        mapModel.DiscountRate = mm.DiscountRate;
        mapModel.InquiryId = _inquiryId;
        mapModel.OfferItemList = mm.OfferItemList;
        mapModel.kLineType = klineType;
        mapModel.TradeMode = mm.TradeMode;
        if(klineType == KLine_sellerInquiry || klineType == KLine_sellerSpecify){
            mapModel.Remarks = mm.Address;
        }else{
            mapModel.Remarks = [mm.OfferItemList.firstObject Remarks];
        }
        [arr addObject:mapModel];
    }
    return arr;
}

+ (NSArray *)getBillRecordsWithBillList:(NSArray *)billList{
    NSMutableArray *Marray = [[NSMutableArray alloc] init];
    for (StockModel *model in billList) {
        if (model.BillId && model.DiscountRate) {
            [Marray addObject:@{@"BillId":model.BillId,@"DiscountRate":model.DiscountRate}];
        }
    }
    return  Marray;
}

- (NSNumber *)getInquiryId{
    return _inquiryId;
}

- (NSNumber *)getOfferId{
    for (OfferModel *model in _offerList) {
        if ([model.CompanyId intValue] == [[Config getCompanyId] intValue]) {
            return model.Id;
        }
    }
    return nil;
}


-(NSNumber *)getInquiryCompanyId {
    if (_buyDetailModel) { // 询价买入 指定买入的时候
        return _buyDetailModel.OfferId;
    }else if (_sellDetailModel ){  //询价卖出 指定卖出的时候
        return _sellDetailModel.OfferId;
    }
    return nil;
}

- (BOOL)judgeInquiry{
    NSNumber *offerId;
    if (_sellDetailModel) {
        offerId = _sellDetailModel.OfferId;
    }else{
        offerId = _buyDetailModel.OfferId;
    }
    if ([offerId intValue] ==  [[Config getCompanyId] intValue]) {
        return YES;
    }
    return NO;
}


- (NSArray *)getBillDetailList{
    NSMutableArray *billArray = [[NSMutableArray alloc] init];
    for (StockModel *stockModel in _sellerBillList) {
        stockModel.stockType = StockAllType_BillDetail;
        [billArray addObject:stockModel];
    }
    return billArray;
}

- (NSNumber *)getInquiryTradeMode{
    return _sellDetailModel.TradeMode;
}

- (NSNumber *)getOfferTradeMode{
    for (OfferModel *model in _offerList) {
        if ([model.CompanyId intValue] == [[Config getCompanyId]intValue]) { //先找出属于我的报价信
         return   model.TradeMode;
        }
    }
    return @(-1);
}

//获取询价方的贴现率
- (NSNumber *)getOfferDiscountRateWithKlineType:(KLINE_TYPE)klineType{
    if (klineType == KLine_buyerOffer) {   //报价买入报价方的贴现率获取
        for (OfferModel *model in _offerList) {
            if ([model.CompanyId intValue] == [[Config getCompanyId] intValue]) {
                return model.DiscountRate;
            }
        }
        return nil;
    }else{                      //询价方的贴现率获取
        if (_sellDetailModel) {
            return _sellDetailModel.DiscountRate;
        }else if(_buyDetailModel.DiscountRate){
            return _buyDetailModel.DiscountRate;
        }else{
            return nil;
        }
    }
}

+ (CGFloat)getAllAmountWithBillArray:(NSArray *)billArray{
    CGFloat allAmount = 0;
    for (StockModel *model in billArray) {
       allAmount += [model.Amount floatValue];
    }
    return allAmount/10000;
}

+ (CGFloat)getAverageDiscountRateWithBillArray:(NSArray *)billArray{
    int allAmount = 0;
    CGFloat totalAmount = 0;
    for (StockModel *model in billArray) {
        if (model.DiscountRate == nil || [model.DiscountRate floatValue] == 0) {
            continue;
        }
        allAmount += [model.Amount intValue];
        totalAmount += [model.Amount intValue] * model.DiscountRate.floatValue;
    }
    if (allAmount == 0) {
        return 0;
    }else{
       return totalAmount/allAmount;
    }
}


-(NSArray *)getImagesPaths{
    if (_sellerBillList.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (  StockModel *model in _sellerBillList) {
            if (model.PositiveImagePath) {
                [arr addObject:model.PositiveImagePath];
            }
            if (model.BackImagePath) {
                [arr addObject:model.BackImagePath];
            }
        }
        return arr;
    }
    return nil;
}



@end
