//
//  InquiryInfoViewModel.m
//  Billunion
//
//  Created by QT on 17/3/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "InquiryInfoViewModel.h"
#import "FGNetworking.h"
#import "OfferModel.h"
#import "MapModel.h"
#import "StockModel.h"


@interface   InquiryInfoViewModel (){
    id _model;
    InqueryInfoModel *_infoModel;
    NSArray *_selectArray;
}
@property (nonatomic,strong) NSMutableDictionary *keyValues;
@end
@implementation InquiryInfoViewModel

// 交易方  // 公司ID
+(void)requestInqueryInfoWithTradeSide:(NSInteger)tradeSide CompanyId:(NSNumber*)companyId Response:(void(^)(id model,NSString *errorStr))block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // dict[@"TradeSide"] = @(tradeSide);  // 不用传这个
    if (companyId) {
        dict[@"CompanyId"] = companyId;
    }
    NSDictionary *params = @{
                             @"OperType":@306,
                             @"Param":dict
                             };
    DEBUGLOG(@"%@ \n %@",ORGAN_HIS_TRADE,params);
    [FGNetworking requsetWithPath:ORGAN_HIS_TRADE params:params method:Post handleBlcok:^(id response, NSError *error) {
    DEBUGLOG(@"%@ \n %@",ORGAN_HIS_TRADE,response);
        if (!error) {
            int statusCode = [[response objectForKey:@"Status"] intValue];
            if ( statusCode == 0) {
                InqueryInfoModel *model = [InqueryInfoModel mj_objectWithKeyValues:response[@"Data"]];
                !block ?: block(model,nil);
            }
        }else{
            !block ?: block(nil,  NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
}


- (NSString *)getUserInfoWithIndexPath:(NSIndexPath *)indexPath isHaveContact:(BOOL)isHaveContact{
    
    if (isHaveContact) {
        switch (indexPath.row) { /** ---------- 交易记录 点击进来的 ------------- */
            case 0: return  (_infoModel.CompanyName == nil) ? @"" :_infoModel.CompanyName;
            case 1: return  (_infoModel.Contact == nil) ? @"" :_infoModel.Contact;
            case 2: return   (_infoModel.Phone == nil) ? @"" :_infoModel.Phone;
            case 3: return  [NSString stringWithFormat:@"%@次",(_infoModel.TradeTimes==nil)?@"0":_infoModel.TradeTimes];
            case 4: return  [NSString stringWithFormat:@"%@次",(_infoModel.SuccessTimes==nil)?@"0":_infoModel.SuccessTimes];
            case 5: return  [NSString stringWithFormat:@"%@次",(_infoModel.FailTimes==nil)?@"0":_infoModel.FailTimes];
            case 6: return  [NSString stringWithFormat:@"%.2lf万",(_infoModel.SuccessAmount==nil)? 0 :_infoModel.SuccessAmount.doubleValue/10000.0];
            case 7: return  [NSString stringWithFormat:@"%.2lf万",(_infoModel.FailAmount==nil)? 0 :_infoModel.FailAmount.doubleValue/10000.0];
            case 8: return  [NSString stringWithFormat:@"%@%%",(_infoModel.SuccessRate==nil) ? @"0" : _infoModel.SuccessRate];
            default: return  @"";
                break;
        }
    }else{  //询价方、报价方 信息
        switch (indexPath.row) {
            case 0: return  (_infoModel.CompanyName == nil) ? @"" :_infoModel.CompanyName;
            case 1: return  [NSString stringWithFormat:@"%@次",(_infoModel.TradeTimes==nil)?@"0":_infoModel.TradeTimes];
            case 2: return  [NSString stringWithFormat:@"%@次",(_infoModel.SuccessTimes==nil)?@"0":_infoModel.SuccessTimes];
            case 3: return  [NSString stringWithFormat:@"%@次",(_infoModel.FailTimes==nil)?@"0":_infoModel.FailTimes];
            case 4: return  [NSString stringWithFormat:@"%.2lf万",(_infoModel.SuccessAmount==nil)? 0 :_infoModel.SuccessAmount.doubleValue/10000.0];
            case 5: return  [NSString stringWithFormat:@"%.2lf万",(_infoModel.FailAmount==nil)? 0 :_infoModel.FailAmount.doubleValue/10000.0];
            case 6: return  [NSString stringWithFormat:@"%@%%",(_infoModel.SuccessRate==nil) ? @"0" : _infoModel.SuccessRate];
            default: return  @"-";
                break;
        }
    }
    return nil;
}


- (void)setCurrentModel:(id)model{
    if (!_infoModel) {
        _infoModel = [[InqueryInfoModel alloc] init];
    }
    if ([model isKindOfClass:[OfferModel class]]) {
        _infoModel.CompanyId =  ((OfferModel *)model).CompanyId;
        _infoModel.OfferId  = ((OfferModel *)model).Id;
        _infoModel.InquiryId = ((OfferModel *)model).InquiryId;
        _infoModel.OfferItemList = ((OfferModel *)model).OfferItemList;
        if (self.klineType != KLine_buyerInquiry && self.klineType != KLine_buyerSpecify) {
            _infoModel.Amount = ((OfferModel *)model).Amount;
            _infoModel.DiscountRate = ((OfferModel *)model).DiscountRate;
        }
//         _selectArray = ((OfferModel *)model).OfferItemList;
    }else if ([model isKindOfClass:[MapModel class]]){
        _infoModel.DiscountRate = ((MapModel *)model).DiscountRate;
        _infoModel.Amount = ((MapModel *)model).Amount;
        _infoModel.CompanyId =  ((MapModel *)model).CompanyId;
        _infoModel.OfferId  = ((MapModel *)model).OfferId;
        _infoModel.InquiryId = ((MapModel *)model).InquiryId;
        _infoModel.OfferItemList = ((MapModel *)model).OfferItemList;
//        _selectArray = ((MapModel *)model).OfferItemList;
    }else if ([model isKindOfClass:[InqueryInfoModel class]]){
        InqueryInfoModel *curModel = _infoModel;
        _infoModel = (InqueryInfoModel *)model;
        _infoModel.DiscountRate = curModel.DiscountRate;
        _infoModel.Amount = curModel.Amount;
        _infoModel.CompanyId =  curModel.CompanyId;
        _infoModel.OfferId  = curModel.OfferId;
        _infoModel.InquiryId = curModel.InquiryId;
        _infoModel.OfferItemList = curModel.OfferItemList;
//        _selectArray = curModel.OfferItemList;
    }
}

-(NSInteger)getTradeModeWithModel:(id)model{

    if ([model isKindOfClass:[OfferModel class]]) {
        return [((OfferModel*)model).TradeMode integerValue];
    }else if ([model isKindOfClass:[MapModel class]]){
         return [((MapModel*)model).TradeMode integerValue];
    }
    return 0;
}


- (void)setIndexArray:(NSArray *)indexArray{
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    for (NSNumber *index in indexArray) {
        [dataArray addObject:_infoModel.OfferItemList[[index intValue]]];
    }
    _selectArray = dataArray;
    _infoModel.Amount = [self getAllAmountWithBillArray:dataArray];
    _infoModel.DiscountRate = [self getAverageDiscountRateWithBillArray:dataArray];
}

-(NSString *)getDiscountRate
{
    if (self.transactionType == TransactionType_Selected) {
        _infoModel.DiscountRate = [self getAverageDiscountRateWithBillArray:_selectArray];
    }else{
       _infoModel.DiscountRate = [self getAverageDiscountRateWithBillArray:_infoModel.OfferItemList];
    }
    return [NSString stringWithFormat:@"贴现率:%.3f%%",_infoModel.DiscountRate? _infoModel.DiscountRate.floatValue :0];
}

-(NSString *)getAmount{
    if (self.transactionType == TransactionType_Selected) {
        _infoModel.Amount = [self getAllAmountWithBillArray:_selectArray];
    }else{
        _infoModel.Amount = [self getAllAmountWithBillArray:_infoModel.OfferItemList];
        
    }
    return [NSString stringWithFormat:@"金额(万):%.2f",_infoModel.Amount.doubleValue/10000];
}

- (NSNumber *)getCompanyId{
    return _infoModel.CompanyId;
}

- (NSNumber *)getOfferId{
    return _infoModel.OfferId;
}

- (NSNumber *)getInquiryId{
    return _infoModel.InquiryId;
}

- (NSArray *)getBillList{
    return _infoModel.OfferItemList;
}

- (NSArray *)getBillRecords{
    NSArray *billArray;
    if (self.transactionType == TransactionType_Selected) {
        billArray = _selectArray;
    }else{
        billArray = _infoModel.OfferItemList;
    }
    
    
    NSMutableArray *Marray = [[NSMutableArray alloc] init];
    for (StockModel *model in billArray) {
        if (model.BillId && model.DiscountRate) {
            [Marray addObject:@{@"BillId":model.BillId,@"DiscountRate":model.DiscountRate}];
        }
    }
    return  Marray;

}


- (NSNumber *)getAllAmountWithBillArray:(NSArray *)billArray{
    CGFloat allAmount = 0;
    for (StockModel *model in billArray) {
        allAmount += [model.Amount floatValue];
    }
    if (allAmount == 0) {
        return @(0);
    }else{
        return [NSNumber numberWithFloat:allAmount];
    }
}

- (NSNumber *)getAverageDiscountRateWithBillArray:(NSArray *)billArray{
    int allAmount = 0;
    CGFloat totalAmount = 0;
    for (StockModel *model in billArray) {
        if (model.DiscountRate == nil || [model.DiscountRate floatValue] == 0) {
            continue;
        }
        allAmount += [model.Amount intValue];
        totalAmount += [model.Amount intValue] * model.DiscountRate.floatValue;
    }
    if (allAmount == 0) {
        return @0;
    }else{
         return [NSNumber numberWithFloat:totalAmount/allAmount];
    }
}




@end
