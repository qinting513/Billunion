
//
//  HomeViewModel.m
//  Billunion
//
//  Created by Waki on 2017/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "HomeViewModel.h"
#import "NoticeModel.h"
#import "FGNetworking.h"
#import "IndexModel.h"
#import "MoreIndexModel.h"

@interface HomeViewModel ()

@end

@implementation HomeViewModel


//请求系统消息

+ (void)requestNoticeWithPage:(NSInteger)page
                      itemNum:(NSInteger)num
                   noticeType:(NoticeType)noticeType
                     response:(void(^)(NSArray *dataArray,NSString *errorStr))block{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
     //公告列表  OperType 400
        NSString *path = NOTICE_LIST;
        NSNumber *operType = @400;
        if (noticeType == NoticeTypeNews) {
            // 今日要闻列表
           operType = @402;
            path = NEWS_LIST;
        }
        
        params[@"Page"] = @(page);
        params[@"ItemNum"] = @(num);

    NSDictionary * dict = @{  @"OperType":operType,
                              @"Param":params
                            };
    DEBUGLOG(@"%@ \n %@",path,params);
   [FGNetworking requsetWithPath:path params:dict method:Post handleBlcok:^(id response, NSError *error) {
     DEBUGLOG(@"%@ \n %@",path,response);
       if (!error) {
           if ([response[@"Status"] intValue] == 0 || response[@"Data"])  {
          
                   NSArray *arrary = [NoticeModel mj_objectArrayWithKeyValuesArray:response[@"Data"]];
                   block(arrary,nil);
           }else{
                 block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
           }
       }
   }];
}


+(void)requestIndexResponse:( void(^)(NSArray*dataArray,NSString *errorStr))block
{
    NSDictionary * params = @{
                              @"OperType":@307,
                              };
    /** 指数 */
    __block NSMutableArray *dataList = [NSMutableArray array];
    [FGNetworking requsetWithPath:INDEX params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",INDEX,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0 && [response[@"Data"] isKindOfClass:[NSArray class]]) {
                    NSArray *arr = [IndexModel mj_objectArrayWithKeyValuesArray:response[@"Data"]];
                    [dataList addObjectsFromArray:arr];
                    if (dataList.count == 3) {
                        block(dataList,nil);
                    }
            }else{
                block(nil,NSLocalizedString(@"NO_MORE_DATA", nil) );
            }
        }else{
            block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
//            NSLog(@"网络请求出错：%@",error);
        }
    }];
    
    NSDictionary *params1 = @{
        @"OperType": @309,
        @"Param": @{
//            "CompanyId": null, // 企业ID
//            "BillType": null,   //产品类型
//            "AcceptorType": null,  // 承兑人类型
//            "DueTime": null   //票据期限
          }
        };
    
    /** 成交量 */
    DEBUGLOG(@"%@ \n %@",QUERY_TRADE_VALUE,params1);
    [FGNetworking requsetWithPath:QUERY_TRADE_VALUE params:params1 method:Post handleBlcok:^(id response, NSError *error) {
     DEBUGLOG(@"%@ \n %@",QUERY_TRADE_VALUE,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0 && response[@"Data"] ) {
                    MoreIndexModel *moreIndexModel = [MoreIndexModel mj_objectWithKeyValues:response[@"Data"]];
                    [dataList addObject:moreIndexModel];
                    if (dataList.count == 3) {
                        block(dataList,nil);
                    }
            }else{
                 block(nil,NSLocalizedString(@"NO_MORE_DATA", nil) );
            }
        }else{
                block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
}



+ (void)requestNoticeDetailWithId:(NSNumber *)newsId  noticeType:(NoticeType)noticeType response:(void(^)(id model ,NSString *errorStr))block{
    if (!newsId) {
         block(nil,NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) );
        return;
    }
     //公告列表
    NSString *path = NOTICE_DETAIL;
    NSNumber *operType = @401;
    if (noticeType == NoticeTypeNews) {
        // 今日要闻列表
        operType = @403;
        path = NEWS_DETAIL;
    }
    
    NSDictionary * params = @{@"OperType":operType,
                              @"Param":@{ @"Id":newsId }};
    DEBUGLOG(@"%@ \n %@",path,params);
    [FGNetworking requsetWithPath:path params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",path,response);
        if (!error) {
            int statusCode  = [response[@"Status"] intValue];
            if (statusCode == 0) {
                if (response[@"Data"] && ![response[@"Data"] isKindOfClass:[NSNull class]]) {
                    NoticeModel *model = [NoticeModel mj_objectWithKeyValues:response[@"Data"]];
                    block(model,nil);
                }else{
                     block(nil,NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) );
                }
            }else{
                 block(nil,NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil) );
            }
        }else{
             block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
}

+ (NSNumber *)getNewsId:(id)noticeModel{
    if ([noticeModel isKindOfClass:[NoticeModel class]]) {
        return ((NoticeModel *)noticeModel).Id;
    }
    return nil;
}

@end
