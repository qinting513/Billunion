//
//  TradeViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeViewModel : NSObject

/**
 询价买入

 @param askBuyDict params
 @param block 返回信息
 */
- (void)tradeBuyerInquiryAddWithAskBuyDict:(NSMutableDictionary *)askBuyDict
                                  response:(void(^)(NSString  *message))block;

/**
 询价卖出／指定卖出

 @param modelArray  卖出的票据集合
 @param tradeMode  交易模式：1-挑票成交  2-整批成交
 @param tradeType   交易类型：0-一般交易，1-指定交易，2-买断交易
 @param counterPartyId  交易对手Id
 @param needOrCanReceipt 是否能够提供发票、合同(0:否，1:是)
 @param depositBanks //["x1","x2",...] 开户行行号（数组，用逗号分隔）
 @param block 返回信息
 */
- (void)selectToSell:(NSArray *)modelArray
           tradeMode:(NSNumber *)tradeMode
           tradeType:(NSNumber *)tradeType
      counterPartyId:(NSNumber *)counterPartyId
    needOrCanReceipt:(NSNumber *)needOrCanReceipt
        depositBanks:(NSArray *)depositBanks
            response:(void(^)(NSString  *message))block;

//
//成交
+ (void)tradeSelectWithInquiryId:(NSNumber *)inquiryId
                         offerId:(NSNumber *)offerId
                    tradeRecords:(NSArray *)tradeRecords
                        response:( void(^)(BOOL isSeccess,NSString *message))block;

//搜索承兑人
+ (void)searchAcceptorWithBillType:(NSNumber *)billType
                               keyWord:(NSArray *)keyWord
                                  page:(NSInteger)page
                          response:(void(^)(NSArray  *array))block;

//按关键字检索企业
+ (void)searchVisitorWithKeyWord:(NSString *)keyWord
                        response:(void(^)(NSArray  *array))block;

+ (BOOL)judgeHaveDiscountRate:(NSArray *)selectArray;


/**
   更换SotckAllType

 @param array  @[StockModel] stockType = StockAllType_Assets
 @return @[StockModel] = StockAllType_Select_Trade
 */
+ (NSArray *)changeToTradeWithArray:(NSArray *)array ;


/**
 修改票据的贴现率

 @param discountRate 贴现率
 @param model StockModel
 */
+ (void)resetDiscountRate:(NSNumber *)discountRate stockModel:(id)model;

/**
 判断所选票据的承兑人类型和票据期限类型是否一致

 @param billList @[<StockModel>]
 @return YES 一致   NO 不一致
 */
+ (BOOL)judgeTheSameOfBillList:(NSArray *)billList;


+ (NSNumber *)getDiscountRateWithStockModel:(id)model;



/**
 记住当前选中的交易对手

 @param counterPartyModel  CounterPartyModel
 */
- (void)setCurrentCounterPartyModel:(id)counterPartyModel;

/**
 根据交易对手的Model获取交易对手的Id

 @return 返回交易对手的Id
 */
- (NSNumber *)getCurrentCounterPartyId;

/**
 根据交易对手的Model获取交易对手名称
 
 @param counterPartyModel CounterPartyModel
 @return 返回交易对手的名称
 */
+ (NSString *)getCounterPartyNameWithModel:(id)counterPartyModel;


@end
