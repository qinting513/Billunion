//
//  MarketViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MarketViewModel.h"
#import "FGNetworking.h"
//#import "AssetsModel.h"
#import "StockModel.h"


@implementation MarketViewModel


//卖方市场行情列表
+(void)requestSellerInquiryListWithBillType:(NSArray*)billTypes
                                       page:(NSInteger)page
                                    itemNum:(NSInteger)itemNum
                               acceptorType:(NSArray*)acceptorType
                               dueTimeRange:(NSArray*)dueTimeRange
                                    address:(NSString *)address
                                   response:( void(^)(NSArray *dataArr,NSString *errorStr))block{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"Page"] = @(page);
    param[@"ItemNum"] = @(itemNum);
    param[@"BillType"] = billTypes;
    param[@"AcceptorIdentityType"] = @1;
    
    if (acceptorType.count > 0) {
        param[@"AcceptorType"] = acceptorType;
    }
    if (address && address.length > 0) {
        param[@"Address"] = address;
    }
    if (dueTimeRange.count > 0) {
        param[@"DueTimeRange"] = dueTimeRange;
    }
    
    NSDictionary * params = @{
                            @"OperType":@300,
                            @"Param":param
                            };
    [self requestDataWithPath:SELLER_INQUIRY_LIST
                       params:params
                    stockType:StockAllType_Seller_Market
                     response:block];
    
}

/** --------------------------------- 分割线 ------------------------------------------- */

//买方市场行情列表
+(void)requestBuyerInquiryListWithBillType:(NSArray*)billTypes
                                      page:(NSInteger)page
                              acceptorType:(NSArray*)acceptorType
                              dueTimeRange:(NSArray*)dueTimeRange
                                   address:(NSString *)address
                                  response:( void(^)(NSArray *dataArr,NSString *errorStr))block{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"Page"] = @(page);
    param[@"ItemNum"] = @20;
   
        param[@"BillType"] = billTypes;
    
    
    if (acceptorType.count > 0) {
        param[@"AcceptorType"] = acceptorType;
    }
    if (address && address.length > 0) {
        param[@"Address"] = address;
    }
    if (dueTimeRange.count > 0) {
        param[@"DueTimeRange"] = dueTimeRange;
    }

    NSDictionary * params = @{
                              @"OperType":@301,
                              @"Param":param
                              };
    [self requestDataWithPath:BUYER_INQUIRY_LIST
                       params:params
                    stockType:StockAllType_Buyer_Market
                     response:block];
}

/** --------------------------------- 公共方法 ------------------------------------------- */
+(void)requestDataWithPath:(NSString*)path
                    params:(NSDictionary *)params
                 stockType:(StockAllType)stockType
                  response:( void(^)(NSArray *dataArr,NSString *errorStr))block
{
    DEBUGLOG(@"%@ \n %@",path,params);
    [FGNetworking requsetWithPath:path params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",path,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0 && [response[@"Data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [response[@"Data"] count]; i++) {
                        StockModel *sellerModel  = [StockModel mj_objectWithKeyValues:response[@"Data"][i]];
                        sellerModel.stockType = stockType;
                        [modelArr addObject:sellerModel];
                    }
                    !block ?: block(modelArr,nil);
               
            }else{
                 !block ?: block(nil,nil);
            }
        }else{
            !block ?: block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
           //  NSLog(@"网络请求出错：%@",error);
        }
    }];
}


@end
