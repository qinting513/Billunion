
//  Api.m
//  Billunion
//
//  Created by Waki on 2017/1/12.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "Api.h"

NSString * const BASEURL = @"http://192.168.0.254:8080/bill-client/pc-client/";
// NSString * const BASEURL = @"http://192.168.0.69:8080/bill-client/pc-client/";
//NSString * const BASEURL = @"http://192.168.0.138:8083/bill-client/pc-client/";
// NSString * const BASEURL = @"https://192.168.0.99:453/bill-client/pc-client/";
// NSString * const BASEURL = @"http://192.168.0.18:8080/bill-client/pc-client/";

//192.168.0.18  潘慧明
//192.168.0.49  黄强
//192.168.0.254 服务器


NSString * const LOGIN_URL= @"user/login_processing";

NSString * const NOTICE_LIST = @"notices/querynoticeslist";

NSString * const NOTICE_DETAIL = @"notices/querynoticesbyid";

NSString * const NEWS_LIST = @"notices/querynewslist";

NSString * const NEWS_DETAIL = @"notices/querynewsbyid";

NSString *const   PROPERTY_BILLRELEASE = @"property/billRelease";

NSString * const VISITOR_URL = @"visitor";

NSString *const  SELLER_INQUIRY_LIST = @"market/sellerInquiryList";

NSString *const  SELLER_INQUIRY_DETAIL = @"market/sellerInquiryDetail";

NSString *const  SELLER_OFFER_LIST = @"market/sellerOfferList";

NSString *const  ORGAN_HIS_TRADE  =  @"market/organHisTrade";

NSString *const  INDEX  =  @"market/index";

NSString *const  BUYER_INQUIRY_LIST  = @"buyerMarket/buyerInquiryList";

NSString *const  BUYER_INQUIRY_DETAIL  = @"buyerMarket/buyerInquiryDetail";

NSString *const BUYER_OFFER_LIST =  @"buyerMarket/buyerOfferList";

NSString *const RATE_MARKET_TREND = @"market/rateMarketTrend";

NSString *const QUERY_TRADE_VALUE = @"market/queryTradeValue";



NSString *const  TRADE_SELLER_INQUIRY_ADD =  @"trade/manual/seller/inquiry/add";

NSString *const  TRADE_BUYER_INQUIRY_ADD = @"trade/manual/buyer/inquiry/add";

NSString *const TEADE_SELLER_INQUIRY_MODIFY = @"trade/manual/seller/inquiry/modify";

NSString *const TRADE_BUYER_INQUIRY_MODIFY = @"trade/manual/buyer/inquiry/modify";

NSString *const TEADE_SELLER_INQUIRY_DELETE = @"trade/manual/seller/inquiry/delete";

NSString *const TRADE_BUYER_INQUIRY_DELETE = @"trade/manual/buyer/inquiry/delete";



NSString *const TRADE_BUYER_OFFER_ADD = @"trade/manual/buyer/offer/add";

NSString *const TRADE_SELLER_OFFER_ADD =  @"trade/manual/seller/offer/add";

NSString *const TRADE_BUYER_OFFER_MODIFY = @"trade/manual/buyer/offer/modify";

NSString *const TRADE_SELLER_OFFER_MODIFY = @"trade/manual/seller/offer/modify";

NSString *const TRADE_BUYER_OFFER_DELETE =  @"trade/manual/buyer/offer/delete";

NSString *const TRADE_SELLER_OFFER_DELETE = @"trade/manual/seller/offer/delete";

NSString *const TRADE_MANUAL_LIST = @"trade/manual/list";


NSString *const BILL_LIST = @"property/billList";

NSString *const TRADE_BILL_LIST = @"property/bill/list";

NSString *const LOGIN_OUT = @"user/logout";

NSString *const BILLDEL = @"/property/billDel";

NSString *const RATE_RESULT_LIST  = @"market/rateResultList";



NSString *const POSTIVE_IMAGE_UPLOAD = @"billImage/positiveImageUpload";

NSString *const BACK_IMAGE_UPLOAD = @"billImage/backImageUpload";

NSString *const OTHER_IMAGE_UPLOAD  = @"billImage/otherImagesUpload";

NSString *const TRADE_RECORD = @"hisBillInquiry/queryList";

NSString *const TRADE_DEAL_SELECT = @"trade/deal/select";

NSString *const ACCEPTOR_LIST = @"property/bill/acceptor/list";

NSString *const  VISITOR_SEARCH = @"visitor";

