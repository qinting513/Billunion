//
//  NearStockViewModel.h
//  Billunion
//
//  Created by QT on 17/2/27.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearStockViewModel : NSObject

-(void)requestDataWithType:(KLINE_TYPE)type
              acceptorType:(NSArray*)acceptors
              dueTimeRange:(NSArray*)dueTimeRanges
               finishBlock:(void(^)(id model, NSString *errorStr))finishBlock;

@end
