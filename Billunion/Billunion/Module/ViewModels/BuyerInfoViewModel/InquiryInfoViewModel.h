//
//  InquiryInfoViewModel.h
//  Billunion
//
//  Created by QT on 17/3/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InqueryInfoModel.h"

@interface InquiryInfoViewModel : NSObject


@property (nonatomic,assign) KLINE_TYPE  klineType;

@property (nonatomic,assign) TransactionType transactionType;

/**
 请求询价方信息

 @param tradeSide  交易方
 @param companyId  企业id
 @param block     请求结果
 */
+(void)requestInqueryInfoWithTradeSide:(NSInteger)tradeSide CompanyId:(NSNumber*)companyId Response:(void(^)(id model,NSString *errorStr))block;

// 对信息的处理
- (NSString *)getUserInfoWithIndexPath:(NSIndexPath *)indexPath  isHaveContact:(BOOL)isHaveContact;

// 过滤model 把所有model统一起来
- (void)setCurrentModel:(id)model;

//选中票的下标集合
- (void)setIndexArray:(NSArray *)indexArray;

- (NSString *)getDiscountRate;

- (NSString *)getAmount;

- (NSNumber *)getCompanyId;

- (NSNumber *)getOfferId;

- (NSNumber *)getInquiryId;

- (NSArray *)getBillList;

- (NSArray *)getBillRecords;

// 交易模式：1-挑票成交  2-整批成交
-(NSInteger)getTradeModeWithModel:(id)model;

@end
