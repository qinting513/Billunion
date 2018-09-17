

//
//  MineViewModel.m
//  Billunion
//
//  Created by Waki on 2017/1/12.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MineViewModel.h"
#import "InquiryInfoViewModel.h"

@interface MineViewModel ()

@property (nonatomic,strong)NSMutableDictionary *keyValues;
@end

@implementation MineViewModel


-(NSMutableDictionary *)keyValues
{
    if (!_keyValues) {
        _keyValues = [NSMutableDictionary dictionary];
    }
    return _keyValues;
}

-(void)requestDataResponse:(void(^)(NSArray *dataArray ,NSString *errorStr))block{
//    @[@"姓名",@"机构",@"邮箱",@"手机",@"交易笔数",@"成功笔数",@"失败笔数",@"成交金额",@"失败金额",@"成交率"];
    NSArray* keyArray  =@[@"AccountName",@"CompanyName",@"Email",@"MobileNumber",
                          @"TradeTimes", @"SuccessTimes",@"FailTimes",@"SuccessAmount",
                          @"FailAmount", @"SuccessRate"];
    __weak typeof(self) weakSelf = self;
    [InquiryInfoViewModel requestInqueryInfoWithTradeSide:0 CompanyId:[Config getCompanyId] Response:^(id model, NSString *errorStr) {
        if (errorStr == nil) {
            [weakSelf setkeyValuesWithModel:model keyArray:keyArray];
            block(weakSelf.keyValues.allValues,nil);
        }else{
            block(nil,errorStr);
        }
    }];
}

-(void)setkeyValuesWithModel:(id)model keyArray:(NSArray *)keyArray
{
    for (int i = 0; i < keyArray.count; i++ ) {
         self.keyValues[@(i)] = [self changeStringPropertyName:keyArray[i] model:model];
     }
   // DEBUGLOG(@"%@",self.keyValues);
}

- (NSString *)changeStringPropertyName:(NSString *)propertyName model:(id)model{
    id value = nil;
    if ([propertyName isEqualToString:@"AccountName"]) {
        value =  [Config getAccountName];
    }else if ([propertyName isEqualToString:@"MobileNumber"]) {
        value =  [Config getMobileNumber];
    }else if ([propertyName isEqualToString:@"Email"]) {
        value =  [Config getEmail];
    }else{
        value = [model valueForKey:propertyName];
      
        if (!value) {
            value = @"-";
        }
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    }
    
    return value;
}

-(NSInteger)numberOfRows{
    return self.keyValues.count;
}

-(NSString *)getDataWithIndex:(NSInteger)index{
   return [self.keyValues objectForKey:@(index)];
}

@end
