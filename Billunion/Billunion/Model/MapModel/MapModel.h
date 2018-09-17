//
//  MapModel.h
//  Billunion
//
//  Created by QT on 17/2/27.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface MapModel : NSObject

// 附近票源的
@property (nonatomic,strong)NSNumber *InquiryId;
// 公司Id
@property (nonatomic,strong) NSNumber *CompanyId;
// 报价 Id
@property (nonatomic,strong) NSNumber *OfferId;

// 交易类型 1 挑票  2 批量
@property (nonatomic,strong) NSNumber *TradeMode;

//贴现率
@property (nonatomic ,copy) NSNumber *DiscountRate;

// 公司名
@property (nonatomic,strong)NSString *CompanyName;

// 详细地址
@property (nonatomic, copy) NSString *Remarks;
//票据金额
@property (nonatomic ,strong) NSNumber *Amount;

// 用于判断是不是有图片的
@property (nonatomic,assign) KLINE_TYPE kLineType;

//报价方 报价票据列表
@property (nonatomic,strong)NSArray *OfferItemList;

/** -------- 票源距离 使用的  ----------- */
// 图片
@property (nonatomic,strong)NSString *imageName;
//经纬度
@property (nonatomic,strong) CLLocation *location ;
//
@property (nonatomic,assign) BOOL isUser;

@property (nonatomic,strong)NSString *distanceStr;

@end
