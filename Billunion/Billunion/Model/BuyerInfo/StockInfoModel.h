//
//  StockInfoModel.h
//  Billunion
//
//  Created by QT on 17/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInfoModel : NSObject
/** 企业id */
@property (nonatomic,strong)NSNumber *CompanyId;
/** 企业名称 */
@property (nonatomic,strong)NSString *CompanyName;

/** 交易笔数 */
@property (nonatomic,strong)NSNumber *TradeTimes;
/** 失败笔数 */
@property (nonatomic,strong)NSNumber *FailTimes;
/** 失败金额 */
@property (nonatomic,strong)NSNumber *FailAmount;
/** 成功笔数 */
@property (nonatomic,strong)NSNumber *SuccessTimes;
/** 成功金额 */
@property (nonatomic,strong)NSNumber *SuccessAmount;
/** 成交率 */
@property (nonatomic,strong)NSNumber *SuccessRate;
/** 背书超时次数  Endorse签署；赞同*/
@property (nonatomic,strong)NSNumber *EndorseTimeout;
/** 背错拒收 */
@property (nonatomic,strong)NSNumber *EndorseFail;
/** 背错拒收 */
@property (nonatomic,strong)NSNumber *SignTimeout;
/** 背错拒收 */
@property (nonatomic,strong)NSNumber *RefuseTime;

/** 联系人  */
@property (nonatomic,strong)NSString *Contact;
/** 联系人电话 */
@property (nonatomic,strong)NSString *Phone;
/** 贴现率 */
@property (nonatomic,strong) NSNumber *DiscountRate;
/** 期限 */
@property (nonatomic,strong)NSNumber *TimeOut;
@end
