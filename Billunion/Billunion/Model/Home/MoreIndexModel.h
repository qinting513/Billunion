//
//  MoreIndexModel.h
//  Billunion
//
//  Created by QT on 17/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreIndexModel : NSObject

/** 银承指数 */
@property (nonatomic,strong)NSNumber *BankIndex;
/** 商承指数 */
@property (nonatomic,strong)NSNumber *CompanyIndex;

/** 承兑人类型指数 */
@property (nonatomic,strong)NSNumber *AcceptorType;

/** 今日成交量 */
@property (nonatomic,strong)NSNumber *Today;
/** 历史成交量 */
@property (nonatomic,strong)NSNumber *History;


/** 产品类型指数  银承纸票 1   银承电票 2  商承电票 3  */
@property (nonatomic,strong)NSNumber *BillType;
/** 波动百分比 */
@property (nonatomic,strong)NSNumber *Percent;
/** 涨幅度 */
@property (nonatomic,strong)NSNumber *Bp;
/** BillType对应的数据 */
@property (nonatomic,strong)NSArray <MoreIndexModel*> *AcceptorTypeRateResultList;
/** 利率 */
@property (nonatomic,strong) NSNumber *Rate;

@end