//
//  TradeRecordViewModel.h
//  Billunion
//
//  Created by QT on 17/3/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRecordViewModel : NSObject


+(void)requestTradeRecordsWithMarketType:(NSInteger)marketType
                                BillType:(NSInteger)billType
                                    page:(NSInteger)page
                                 itemNum:(NSInteger)itemNum
                                response:( void(^)(NSArray *dataArr,NSString *errorStr))block;

@end
