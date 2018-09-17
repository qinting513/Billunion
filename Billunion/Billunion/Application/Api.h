//
//  Api.h
//  Billunion
//
//  Created by Waki on 2017/1/12.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const BASEURL;

/** 登录URL  ok */
FOUNDATION_EXPORT NSString * const LOGIN_URL;

/**	获取验证码 找回密码 */
FOUNDATION_EXPORT NSString * const VISITOR_URL;

//公告列表  OperType 400
FOUNDATION_EXPORT NSString * const NOTICE_LIST;

//公告详情  OperType 401
FOUNDATION_EXPORT NSString * const NOTICE_DETAIL;

//今日要闻列表  OperType 402
FOUNDATION_EXPORT NSString * const NEWS_LIST;

//今日要闻详情  OperType 403
FOUNDATION_EXPORT NSString * const NEWS_DETAIL;

/**票据添加*/
FOUNDATION_EXPORT NSString * const  PROPERTY_BILLRELEASE;

/**查询卖方市场行情列表*/
FOUNDATION_EXPORT NSString * const  SELLER_INQUIRY_LIST;
/*查询卖方市场询价详情*/
FOUNDATION_EXPORT NSString *const  SELLER_INQUIRY_DETAIL;

/*查询买方市场行情列表*/
FOUNDATION_EXPORT NSString *const BUYER_INQUIRY_LIST;
/*查询买方市场行情列表详情 */
FOUNDATION_EXPORT NSString *const BUYER_INQUIRY_DETAIL;


/*查询机构历史交易*/   //交易记录里面的 点击后跳出的页面
FOUNDATION_EXPORT NSString *const  ORGAN_HIS_TRADE; 



/*查询行情指数 普创指数的更多部分 */
FOUNDATION_EXPORT NSString *const  INDEX;
/*查询成交量   首页的普创指数 今日成交 累计成交 */
FOUNDATION_EXPORT NSString *const QUERY_TRADE_VALUE;


/*查询行情趋势 k 线图 */
FOUNDATION_EXPORT NSString *const RATE_MARKET_TREND;


//询价卖出
FOUNDATION_EXPORT NSString *const TRADE_SELLER_INQUIRY_ADD;
//询价买入
FOUNDATION_EXPORT NSString *const TRADE_BUYER_INQUIRY_ADD;
//询价卖出修改
FOUNDATION_EXPORT NSString *const TEADE_SELLER_INQUIRY_MODIFY;
//询价买入修改
FOUNDATION_EXPORT NSString *const TRADE_BUYER_INQUIRY_MODIFY;
//询价卖出删除
FOUNDATION_EXPORT NSString *const TEADE_SELLER_INQUIRY_DELETE;
//询价买入删除
FOUNDATION_EXPORT NSString *const TRADE_BUYER_INQUIRY_DELETE;

//报价买入
FOUNDATION_EXPORT NSString *const TRADE_BUYER_OFFER_ADD;
//报价卖出
FOUNDATION_EXPORT NSString *const TRADE_SELLER_OFFER_ADD;
//报价买入修改
FOUNDATION_EXPORT NSString *const TRADE_BUYER_OFFER_MODIFY;
//报价卖出修改
FOUNDATION_EXPORT NSString *const TRADE_SELLER_OFFER_MODIFY;
//报价买入删除
FOUNDATION_EXPORT NSString *const TRADE_BUYER_OFFER_DELETE;
//报价卖出删除
FOUNDATION_EXPORT NSString *const TRADE_SELLER_OFFER_DELETE;

//查询票据资产信息列表
FOUNDATION_EXPORT NSString *const BILL_LIST;

//交易时票据信息筛选
FOUNDATION_EXPORT NSString *const TRADE_BILL_LIST;

//查询我的买入／我的卖出 交易信息表
FOUNDATION_EXPORT NSString *const TRADE_MANUAL_LIST;



//移动端不需要的接口
/*查询买方市场的报价列表*/
FOUNDATION_EXPORT NSString *const BUYER_OFFER_LIST;
/*查询卖方市场报价列表*/
FOUNDATION_EXPORT NSString *const  SELLER_OFFER_LIST;

//登出
FOUNDATION_EXTERN NSString *const LOGIN_OUT;

//  删除票据
FOUNDATION_EXPORT NSString *const BILLDEL;

//利率市场
FOUNDATION_EXPORT NSString *const RATE_RESULT_LIST;


//图片上传
FOUNDATION_EXPORT NSString *const POSTIVE_IMAGE_UPLOAD;
FOUNDATION_EXPORT NSString *const BACK_IMAGE_UPLOAD ;
FOUNDATION_EXPORT NSString *const OTHER_IMAGE_UPLOAD ;

/** 交易记录  */
FOUNDATION_EXPORT NSString *const TRADE_RECORD;

//成交
FOUNDATION_EXPORT NSString *const TRADE_DEAL_SELECT;

//查询承兑人列表：
FOUNDATION_EXPORT NSString *const ACCEPTOR_LIST;

//按关键字检索企业
FOUNDATION_EXPORT NSString *const VISITOR_SEARCH;


