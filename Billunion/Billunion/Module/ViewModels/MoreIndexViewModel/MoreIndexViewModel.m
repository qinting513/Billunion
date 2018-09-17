
//
//  MoreIndexViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/23.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreIndexViewModel.h"
#import "FGNetworking.h"
#import "MoreIndexModel.h"
#import "KlineModel.h"

@implementation MoreIndexViewModel

- (void)requestMarketRateResultListWithResponse:(void(^)(NSArray *dataArray, NSString *errorStr))block{
    NSDictionary *params = @{ @"OperType":@310 };
    
    DEBUGLOG(@"%@ \n %@",RATE_RESULT_LIST,params);
    
    [FGNetworking requsetWithPath:RATE_RESULT_LIST params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",RATE_RESULT_LIST,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if (statusCode == 0) {
                NSArray * modelArr = [MoreIndexModel mj_objectArrayWithKeyValuesArray:response[@"Data"]];
                !block ?: block(modelArr,nil);
                
            }else{
                  block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
            
        }else{
            block(nil,NSLocalizedString(@"ERROR_NETWORK", nil)  );
        }
    }];
}


+ (void)requestRateMarketTrendWithType:(K_RATE_MARKET_TYPE)type
                          acceptorType:(NSNumber *)acceptorType
                              billType:(NSNumber *)billType
                          dueTimeRange:(NSNumber *)dueTimeRange
                              response:(void(^)(NSArray *dataArray,NSString *errorStr))block{
    
 
    if (!billType || !acceptorType || !dueTimeRange) {
        block(nil,NSLocalizedString(@"ERROR_GET_DATA_FAIL", nil));
        return;
    }
    
    NSDictionary *params = @{
                             @"OperType":@308,
                             @"Param":@{
                                     @"ChartType":[NSNumber numberWithInteger:type],
                                     @"AcceptorType":acceptorType,
                                     @"BillType":billType,
                                     @"DueTimeRange":dueTimeRange
                                     }
                             };
    DEBUGLOG(@"%@\n%@",RATE_MARKET_TREND,params);
    [FGNetworking requsetWithPath:RATE_MARKET_TREND params:params method:Post handleBlcok:^(id response, NSError *error) {
        DEBUGLOG(@"%@\n%@",RATE_MARKET_TREND,response);
        if (!error) {
            if ([response[@"Status"] intValue] == 0 && ![response[@"Data"] isKindOfClass:[NSNull class]]) {
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
            }else{
               block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
        }else{
              block(nil,NSLocalizedString(@"ERROR_NETWORK", nil)  );
        }
    }];
}


@end
