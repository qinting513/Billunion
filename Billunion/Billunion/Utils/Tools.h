//
//  Tools.h
//  PCStock
//
//  Created by Waki on 2016/12/27.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
    Reset_verify,   //手机验证
    Reset_pwd       //密码重设
}RESET_TYPE;           //登陆界面的类型


typedef enum {
    AskBuying,         //询价买入
    SpecifiedBuying   //指定买入
}BUYING_TYPE;   //AskBuyTableView 

typedef enum {
    stock_market, //票据行情
    stock_trading, //票据交易
    stock_assets,  //票据资产
    stock_transactionRecords, //交易记录
    stock_buying,  //我的买入
    stock_sell  //我的卖出
    
}STOCK_TYPE;   //BaseViewController


/** 买家信息界面 可选择／不可选择 左边圈圈按钮 */
typedef enum {

    TransactionType_SelectAll = 0, // 不可选
    TransactionType_Selected  = 1
}TransactionType;


typedef enum {
    KLine_buyerInquiry,         //询价买入
    KLine_buyerSpecify,   //指定买入
    KLine_buyerOffer,       //报价买入
    KLine_beSellerSpecify,   //被指定卖出
    KLine_buyerMarket,        //买方市场
    
    KLine_sellerInquiry,         //询价卖出  有头视图
    KLine_sellerSpecify,     //指定卖出
    KLine_sellerOffer,         //报价卖出
    KLine_beBuyerSpecify,  //被指定买入
    KLine_sellerMarket,       //卖方市场  有头视图
    
    KLine_nearStock            //附近票源
    
}KLINE_TYPE;


typedef NS_ENUM(NSInteger, StockAllType) {
    //我的买入 纸票/电票
    StockAllType_MyBuying_askBuying = 1,  //询价买入
    StockAllType_MyBuying_specifiedBuying, //指定买入
    StockAllType_MyBuying_quoteBuying,    //报价买入
    StockAllType_MyBuying_beSpecifiedSell,  //被指定卖出
    
    //我的卖出 纸票／电票
    StockAllType_MySell_askSell,           //询价卖出
    StockAllType_MySell_specifiedSell,     //指定卖出
    StockAllType_MySell_quoteSell,         //报价卖出
    StockAllType_MySell_beSpecifiedBuying,  //被指定买入
    
    //卖方市场／买方市场
    StockAllType_Seller_Market,
    StockAllType_Buyer_Market,
    
    
    //票据交易的 询价卖出／指定卖出
    StockAllType_Tade_askSell,
    StockAllType_Tade_specifiedSell,
    
    //票据资产的 纸票／电票
    StockAllType_Assets,
    
    //交易记录 卖方市场／交易记录
    StockAllType_TradingRecord_Seller_Market,
    StockAllType_TradingRecord_Buyer_Market,
    
    
    //指定卖出选择交易的时候需要用到
    StockAllType_Select_Trade,
    
    //显示买卖方的交易的票据信息的时候使用
    StockAllType_BillDetail
};


typedef enum : NSInteger {
    K_Hour,  //时线
    K_Day,   //日线
    K_Week,  //周线
    K_Month, //月线
    K_Year   //年线
}K_RATE_MARKET_TYPE;   //k线图的类型


typedef enum {
    P_bank_note,   // 银承纸票
    E_bank_note,    //银承电票
    E_business_note // 商承电票
}RateMarketType;

typedef enum {
    NoticeTypeNews, // 系统新闻
    NoticeTypeSystem, // 系统公告
    NoticeTypeTrade  // 推送过来的通知
} NoticeType;



@interface Tools : NSObject

//交易状态
+ (NSString *)getTradeStatus:(NSInteger)index;

// 交易类型
+ (NSString *)getTradeModel:(NSInteger)index;
//票据状态
+ (NSString *)getBillState:(NSInteger)index;

//承兑人类型 银行
+ (NSString *)getAcceptor1:(NSInteger)index;

//承兑人类型  非银行
+ (NSString *)getAcceptor2:(NSInteger)index;

//票据类型
+ (NSString *)getBillType:(NSInteger)index;

//电票期限
+ (NSString *)getENoteDueTimeString:(NSInteger)index;

//纸票期限
+ (NSString *)getPNoteDueTimeString:(NSInteger)index;

//获取承兑人类型集合
+ (NSArray *)getAcceptorsWithBillType:(NSInteger)billType;
//获取票据期限集合
+ (NSArray *)getDueTimeRangeWithBillType:(NSInteger)billType;

/** 获取承兑人类型的对应的数字数组 过滤用的 */
+ (NSArray *)getAcceptorCodeWithAcceptors:(NSArray *)acceptors  billTypes:(NSArray *)billTypes;
/** 获取票据期限类型的对应的数字数组 过滤用的 */
+ (NSArray *)getDueTimeRangeCodeWithDueTimeRanges:(NSArray *)dues  billTypes:(NSArray *)billTypes;


//获取票据信息的审核状态
+ (NSString *)getExamineState:(NSInteger)index;

/** 保存用户登录状态到沙盒， YES 或 NO */
+(void)saveUserLoginStatus:(NSString*)login;
/** 返回用户当前的登录状态 */
+(BOOL)isUserLogin;


// 获取询价方列表title
+(NSArray *)getInqueryTitles;
// 获取报价方列表title
+(NSArray *)getOfferTitles;
// 获取交易对手方列表title
+(NSArray *)getCounterPartyTitles;

/**
 通过stockAllType获取到子标题

 @param allType stock类型
 @return  返回子标题数组
 */
+(NSArray *)getSubTitlesWithStockAllType:(StockAllType)allType;
+(NSArray *)getMineTitles;
/** 获取个人信息界面titles */
+(NSArray *)getMyProfileTitles;
+(NSArray*)getStockAddTitles;
+(NSArray*)getStockAddPlaceHolders;
+(NSArray*)getLoginPlaceHolders;

+(NSArray *)getTradeTimeArray;
/** 交割时间(0:T+0,1:T+1,2:T+2,3:T+3)  */
+(NSString *)getTradeTimeWithNum:(NSNumber *)num;

/**
  金额大写

 @param text 金额 数字字符串
 @return 中文大写字符串
 */
+ (NSString *)getAmountText:(NSString *)text;


/**
 判断金额输入

 @param text 金额字符串
 @return 错误信息  如果为nil，证明输入正确
 */
+ (NSString *)judgeAmontInputWithText:(NSString *)text;


/**
 判断贴现率输入

 @param text 贴现率字符串
 @return 错误信息  如果为nil，证明输入正确
 */
+ (NSString *)judgeDiscountRateInputWithText:(NSString *)text;



@end