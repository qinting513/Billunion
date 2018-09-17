//
//  KLineViewModel.h
//  Billunion
//
//  Created by Waki on 2017/1/18.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineViewModel : NSObject


//查询市场询价详情
- (void)requestDetailWithsType:(KLINE_TYPE)type response:(void(^)(BOOL isSuccess,NSString *message,id data))block;


/**
 k线图

 @param type  k线图的类别
 @param block  NSArray<KlineModel>
 */
- (void)requestRateMarketTrendWithType:(K_RATE_MARKET_TYPE)type
                             kLineType:(KLINE_TYPE)klineType
                              response:(void(^)(NSArray *dataArray,NSString *errorStr))block;

/**
 票据详情里的报价列表

 @param type K线图的内容类别
 @param block 详情内容
 */
- (void)requestOfferListWithType:(KLINE_TYPE)type response:(void(^)(NSArray *dataArray,NSString *errorStr))block;


/**
 //报价买入

 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param isAnonymous 是否匿名   0不匿名 1匿名
 @param block 返回消息
 */

/**
 //报价买入

 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param isAnonymous 是否匿名   0不匿名 1匿名
 @param inquiryId 询价Id
 @param tradeTime 交割时间(0:T+0,1:T+1,2:T+2,3:T+3)
 @param needOrCanReceipt 是否需要提供发票、合同(0:否，1:是)
 @param targetCustomer 目标客户（0：所有 1：本行）
 @param address 报价方地址
 @param block 返回消息
 */
+ (void)tradeBuyerOfferWithBillRecords:(NSArray *)billRecords
                           isAnonymous:(NSNumber *)isAnonymous
                             inquiryId:(NSNumber *)inquiryId
                              tradeTime:(NSNumber *)tradeTime
                      needOrCanReceipt:(NSNumber *)needOrCanReceipt
                        targetCustomer:(NSNumber *)targetCustomer
                               address:(NSString *)address
                              response:(void(^)(NSString *message,BOOL isFailLocation))block;
/**
 //报价卖出

 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param isAnonymous 是否匿名  0不匿名 1匿名
 @param tradeMode  交易模式：1-挑票成交  2-整批成交
 @param needOrCanReceipt  是否能提供合同
 @param block 返回消息
 */
+ (void)tradeSellerOfferWithBillRecords:(NSArray *)billRecords
                           isAnonymous:(NSInteger)isAnonymous
                             inquiryId:(NSNumber *)inquiryId
                              tradeMode:(NSInteger)tradeMode
                       needOrCanReceipt:(NSNumber *)needOrCanReceipt
                              response:(void(^)(BOOL isSecceed , NSString *message))block;


/**
 撤销交易

 @param type 类型
 @param block 返回信息
 */
- (void)tradeDeleteWithType:(KLINE_TYPE)type response:(void(^)(BOOL isSecceed, NSString *message))block;



/**
 询价买入修改

 @param inquiryId 询价Id
 @param discountRate 贴现率
 @param block 返回值
 */
- (void)resetBuyerInquiryWithInquiryId:(NSNumber *)inquiryId
                          discountRate:(NSNumber *)discountRate
                              response:(void(^)(BOOL isSecceed,NSString *message))block;

/**
 询价卖出修改

 @param inquiryId 询价Id
 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param block 返回消息
 */
+ (void)resetSellerInquiryWithInquiryId:(NSNumber *)inquiryId
                            billRecords:(NSArray *)billRecords
                               response:(void(^)(BOOL isSecceed,NSString *message))block;

/**
 //报价买入修改
 
 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param offerId 报价方Id
 @param address 报价方地址
 @param block 返回消息
 */

+ (void)resetBuyerOfferWithBillRecords:(NSArray *)billRecords
                               offerId:(NSNumber *)offerId
                               address:(NSString *)address
                              response:( void(^)(NSString *message,BOOL isFailLocation) )block;
/**
 报价卖出修改

 @param billRecords 票据集合   [{"BillId":1000,"DiscountRate":5.5}]
 @param offerId 报价方Id
 @param  tradeMode 1 挑票  2批量
 @param block 返回消息
 */
+ (void)resetSellerOfferWithBillRecords:(NSArray *)billRecords
                              TradeMode:(NSNumber *)tradeMode
                                offerId:(NSNumber *)offerId
                               response:(void(^)(BOOL isSecceed,NSString *message))block;


/**
 获取报价方或询价方的票据列表

 @param klineType 页面类型
 @param block   isOffered指是否已进行报价 billList报价方或询价方的票据列表
 */
- (void)getOfferItemListWithKlineType:(KLINE_TYPE)klineType response:(void(^)(BOOL isOffered,NSArray *billList))block;



- (void)setCurrentModel:(id)model type:(KLINE_TYPE)klienType;

/**
 获取要报价的资源集合
 
 @param billList @<AssetsModel>;
 @return 资源集合
 */
+ (NSArray *)getBillRecordsWithBillList:(NSArray *)billList;


/** 获取票源地址 */
-(NSArray *)getBillAddressWithKlineType:(KLINE_TYPE)klineType;

//询价方 Id
- (NSNumber *)getInquiryId;
//报价方 Id
- (NSNumber *)getOfferId;


// 报价方公司Id
-(NSNumber *)getInquiryCompanyId;




//判断是否是询价方是否是自己
- (BOOL)judgeInquiry;


/**
 获取询价方交易模式

 @return  //交易模式：1-挑票成交  2-整批成交
 */
- (NSNumber *)getInquiryTradeMode;

/**
 获取自己报价时的交易模式

 @return  //交易模式：1-挑票成交  2-整批成交
 */
- (NSNumber *)getOfferTradeMode;


/**
 获取报价贴现率

 @param klineType 页面类型
 @return 贴现率
 */
- (NSNumber *)getOfferDiscountRateWithKlineType:(KLINE_TYPE)klineType;


//获取票据的总金额
+ (CGFloat)getAllAmountWithBillArray:(NSArray *)billArray;
//获取票据的平均贴现率
+ (CGFloat)getAverageDiscountRateWithBillArray:(NSArray *)billArray;

//获取图片地址数组
-(NSArray *)getImagesPaths;






@end
