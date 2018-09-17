//
//  SellDetailModel.h
//  Billunion
//
//  Created by Waki on 2017/2/21.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellDetailModel : NSObject

@property (nonatomic, strong) NSNumber *Amount;
@property (nonatomic, copy) NSString *BillAdress;
@property (nonatomic, strong) NSNumber *ProductType;
@property (nonatomic, strong) NSNumber *BillType;
@property (nonatomic,strong)  NSNumber *DueTimeRange;
@property (nonatomic, strong) NSNumber *DiscountRate;
@property (nonatomic ,copy) NSString *ProductCode;
@property (nonatomic ,copy) NSString *Address;
@property (nonatomic, copy) NSString *OfferName;
@property (nonatomic, strong) NSNumber *OfferId;
@property (nonatomic, copy) NSString *Holder;
@property (nonatomic, strong) NSNumber *InquiryId;
@property (nonatomic ,strong) NSNumber *HolderType;
@property (nonatomic ,strong) NSNumber *HolderIdentityType;
@property (nonatomic ,strong) NSNumber *AcceptorType;
@property (nonatomic ,strong) NSNumber *AcceptorIdentityType;
@property (nonatomic, strong) NSNumber *TradeMode;

@end
