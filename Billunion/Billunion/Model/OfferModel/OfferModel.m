//
//  OfferModel.m
//  Billunion
//
//  Created by QT on 17/2/25.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "OfferModel.h"
#import "StockModel.h"

@implementation OfferModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.OfferItemList = [[NSArray alloc] init];
    }
    return self;
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{ @"OfferItemList":[StockModel class] };
}

- (void)setOfferItemList:(NSArray *)OfferItemList{
    if (OfferItemList.count > 0 && [OfferItemList.firstObject isKindOfClass:[StockModel class]]) {
        for (StockModel *model in OfferItemList) {
            model.stockType = StockAllType_BillDetail;
        }
    }
    _OfferItemList = OfferItemList;
}
@end
