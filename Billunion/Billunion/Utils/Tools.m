//
//  Tools.m
//  PCStock
//
//  Created by Waki on 2016/12/27.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "Tools.h"



@implementation Tools

// 交易状态
+ (NSString *)getTradeStatus:(NSInteger)index{
    switch (index) {
        case 0:  return @"待交易";
        case 1:  return @"交易中";
        case 2:  return @"交易结束";
        default: return @"未知";
    }
}

+ (NSString *)getTradeModel:(NSInteger)index{
    switch (index) {
        case 1:  return @"挑票成交";
        case 2:  return @"批量成交";
        default: return @"未知";
    }
}

// 票据状态 票据资产 票据交易 才有的
+ (NSString *)getBillState:(NSInteger)index{
    switch (index) {
        case 0:  return @"待发布";
        case 1:  return @"待交易";
        case 2:  return @"交易中";
        case 3:  return @"交易结束";
        default: return @"未知";
    }
}

// 审核状态
+ (NSString *)getExamineState:(NSInteger)index{
    switch (index) {
        case -1: return @"待报价";
        case 0:  return @"待审核";
        case 1:  return @"已审核";
        case 2:  return @"审核不通过";
        default: return @"未知";
            break;
    }
}



+ (NSString *)getBillType:(NSInteger)index{
    switch (index) {
        case 1: return NSLocalizedString(@"PBankNote", nil);
        case 2: return NSLocalizedString(@"EBankNote", nil);
        case 3: return NSLocalizedString(@"EBusinessNote", nil);
        default:  return NSLocalizedString(@"Unknown", nil);
    }
}

+ (NSString *)getENoteDueTimeString:(NSInteger)index{
    switch (index) {
        case 1:  return @"一天";
        case 2:  return @"七天";
        case 3:  return @"一月期";
        case 4:  return @"二月期";
        case 5:  return @"三月期";
        case 6:  return @"四月期";
        case 7:  return @"五月期";
        case 8:  return @"六月期";
        case 9:  return @"七月期";
        case 10:  return @"八月期";
        case 11:  return @"九月期";
        case 12:  return @"十月期";
        case 13:  return @"十一月期";
        case 14:  return @"十二月期";
        case 15:  return @"挂历票";
        default: return @"未知";
            break;
    }
}

+ (NSString *)getPNoteDueTimeString:(NSInteger)index{
    switch (index) {
        case 3:  return @"一月期";
        case 4:  return @"二月期";
        case 5:  return @"三月期";
        case 6:  return @"四月期";
        case 7:  return @"五月期";
        case 8:  return @"六月期";
        case 15:  return @"挂历票";
        default: return @"未知";
            break;
    }
}



+ (NSArray *)getDueTimeRangeWithBillType:(NSInteger)billType{
    if (billType == 1) {
       return @[@"一月期",@"二月期",@"三月期",@"四月期",@"五月期",@"六月期",@"挂历票"];
    }else{
        return @[@"一天",@"七天",@"一月期",@"二月期",@"三月期",@"四月期",@"五月期",@"六月期",
                 @"七月期",@"八月期",@"九月期",@"十月期",@"十一月期",@"十二月期",@"挂历票"];
    }
}

//承兑人类型 银行
+ (NSString *)getAcceptor1:(NSInteger)index{
    NSArray *arr = [self getAcceptors:2];
    NSString *acceptor;
    if (index<arr.count && index>0) {
        acceptor = arr[index-1];
    }else{
        acceptor = @"未知";
    }
    return acceptor;
}

//承兑人类型  非银行
+ (NSString *)getAcceptor2:(NSInteger)index{
    NSString *acceptor;
    switch (index) {
        case 1: acceptor = @"中央企业";  break;
        case 2: acceptor = @"国有控股";  break;
        case 3: acceptor = @"地方国企";  break;
        case 4: acceptor = @"民营企业";  break;
        case 5: acceptor = @"外资企业";  break;
        default: acceptor = @"未知";    break;
    }
    return acceptor;
    
}

// 界面上的排布
+ (NSArray *)getAcceptorsWithBillType:(NSInteger)billType{
    if (billType == 1) {
        return  @[@"政策银行",@"国有大行",@"股份制行",@"省级城商",@"省级农商",@"外资银行",
                  @"中外合资",@"民营银行",@"地市城商",@"地市农商",@"村镇农信",@"财务公司"];
    }else{
        return  @[@"政策银行",@"国有大行",@"股份制行",@"省级城商",@"省级农商",@"外资银行",
                  @"中外合资",@"民营银行",@"地市城商",@"地市农商",@"村镇农信",@"财务公司",
                  @"中央企业",@"国有控股",@"地方国企",@"民营企业",@"外资企业"];
    }
}

// 私有方法  @"中外合资" 的位置不一样  后台逻辑
+ (NSArray *)getAcceptors:(NSInteger)billType{
    if (billType == 1) {
        return  @[@"政策银行",@"国有大行",@"股份制行",@"省级城商",@"省级农商",@"外资银行",
                  @"民营银行",@"地市城商",@"地市农商",@"村镇农信", @"中外合资",@"财务公司"];
    }else{
        return  @[@"政策银行",@"国有大行",@"股份制行",@"省级城商",@"省级农商",@"外资银行",
                  @"民营银行",@"地市城商",@"地市农商",@"村镇农信", @"中外合资",@"财务公司",
                  @"中央企业",@"国有控股",@"地方国企",@"民营企业",@"外资企业"];
    }
}


/** 获取承兑人类型的对应的数字数组 过滤用的 */
+ (NSArray *)getAcceptorCodeWithAcceptors:(NSArray *)acceptors billTypes:(NSArray *)billTypes{
    NSMutableArray *codeArr = [NSMutableArray array];
    NSInteger billType = [billTypes.firstObject integerValue];
    NSArray *titles = [self getAcceptors:billType];
    for (NSString *acceptor in acceptors) {
        NSInteger index = [titles indexOfObject:acceptor];
        if (index > 11 ) {
            NSRange range = NSMakeRange(12, titles.count - 12);
            NSArray *sub = [titles subarrayWithRange:range];
            index = [sub indexOfObject:acceptor];
        }
        [codeArr addObject:@(index + 1)];
    }
    return [codeArr copy];
}
/** 获取票据期限类型的对应的数字数组 过滤用的 */
+ (NSArray *)getDueTimeRangeCodeWithDueTimeRanges:(NSArray *)dues billTypes:(NSArray *)billTypes{
    NSMutableArray *codeArr = [NSMutableArray array];
    NSInteger billType = [billTypes.firstObject integerValue];
    NSArray *arr = [self getDueTimeRangeWithBillType:billType];
    for (NSString *title in dues) {
        if ([title isEqualToString:@"挂历票"]) {
            [codeArr addObject:@(15)];
            continue;
        }
         NSInteger index = [arr indexOfObject:title];
        if (billType == 1) { // 纸票从3开始
           [codeArr addObject:@(index+3)];
        }else{
           [codeArr addObject:@(index+1)];
        }
    }
    return codeArr;
}



+(void)saveUserLoginStatus:(NSString*)login{
    [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"userLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isUserLogin{
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLogin"];
    if ([str isEqualToString:@"YES"]) {
        return YES;
    }else{
        return  NO;
    }
}

// 获取询价方列表title
+(NSArray *)getInqueryTitles{
    return @[@"询价方",@"交易笔数",@"成功笔数",@"失败笔数",@"成交金额",@"失败金额",@"成交率"];
}

// 获取报价方列表title
+(NSArray *)getOfferTitles{
    return   @[@"报价方",@"交易笔数",@"成功笔数",@"失败笔数",@"成交金额",@"失败金额",@"成交率"];
}
// 获取交易对手方列表title
+(NSArray *)getCounterPartyTitles{
    return   @[@"交易对手",@"联系人",@"联系电话",@"交易笔数",@"成功笔数",@"失败笔数",@"成交金额",@"失败金额",@"成交率"];
}

+(NSArray *)getTradeTimeArray{
    return @[@"T+0",@"T+1",@"T+2",@"T+3"];
}

+(NSString *)getTradeTimeWithNum:(NSNumber *)num{
    if (num == nil) {
        return @"未知";
    }
    NSString *time;
    switch (num.integerValue) {
        case 0: time = @"T+0";  break;
        case 1: time = @"T+1";  break;
        case 2: time = @"T+2";  break;
        case 3: time = @"T+3";  break;
        default: time = @"未知";    break;
    }
    return time;
}

+(NSArray *)getSubTitlesWithStockAllType:(StockAllType)allType{
    NSString *Amount            = NSLocalizedString(@"Amount", nil);
    NSString *DiscountRate      = NSLocalizedString(@"DiscountRatePercent", nil);
    NSString *BillType          = NSLocalizedString(@"BillType", nil);
    NSString *Acceptor          = NSLocalizedString(@"Acceptor", nil);
    NSString *DueTimeRange      = NSLocalizedString(@"DueTimeRange", nil); // 票据期限类型
    NSString *RemainingDays     = NSLocalizedString(@"RemainingDays", nil); // 剩余天数
    NSString *TradeState        = NSLocalizedString(@"TradeState", nil);    // 交易状态
    NSString *AuditState        = NSLocalizedString(@"AuditState", nil); // 审核状态
    NSString *StockAddress      = NSLocalizedString(@"StockAddress", nil);
    NSString *Counterpart       = NSLocalizedString(@"Counterpart", nil);
   //  NSString *Holder            = NSLocalizedString(@"Holder", nil);
    NSString *InquiryParty      = NSLocalizedString(@"InquiryParty", nil);
    NSString *TradeTime         = NSLocalizedString(@"TradeTime", nil);
    NSString *TradeType         = NSLocalizedString(@"TradeType", nil);
    NSString *Change                = @"涨跌幅(bp)";
    NSString *needContract      = @"需要发票、合同"; // 是 否
    NSString *haveContract      = @"提供发票、合同"; // 能 否
    NSString *aimCustomer       = @"目标客户"; // 全部 本行客户
    NSString *CounterPartyName  = @"交易对手";
    
    NSArray *subTitles;
    switch (allType) {
        case StockAllType_MyBuying_askBuying:
        case StockAllType_MyBuying_specifiedBuying:
        case StockAllType_MyBuying_quoteBuying:
        case StockAllType_MyBuying_beSpecifiedSell:
            subTitles =  @[
                           @[  //纸票
                                @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,needContract,aimCustomer],
                                @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,Counterpart,needContract],
                                @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,haveContract],
                                @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,Counterpart,haveContract],
                            ],
                           @[  // 电票
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,needContract,aimCustomer],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,Counterpart,needContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,Counterpart,haveContract],
                            ],
                           ];
            break;
        case StockAllType_MySell_askSell:
        case StockAllType_MySell_specifiedSell:
        case StockAllType_MySell_quoteSell:
        case StockAllType_MySell_beSpecifiedBuying:
            subTitles =  @[
                           @[  //纸票
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,Counterpart,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,needContract,aimCustomer],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,StockAddress,Counterpart,needContract],
                               ],
                           @[  // 电票
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,Counterpart,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,needContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,AuditState,Counterpart,needContract],
                               ],
                           ];

            break;
        case StockAllType_Seller_Market:
        case StockAllType_Buyer_Market:
            subTitles =  @[
                            @[
                                @[Amount,DiscountRate,Change,BillType,Acceptor,DueTimeRange,InquiryParty,StockAddress,haveContract],
                                @[Amount,DiscountRate,Change,BillType,Acceptor,DueTimeRange,InquiryParty,haveContract],
                             ],
                           
                            @[
                               @[Amount,DiscountRate,Change,BillType,Acceptor,DueTimeRange,InquiryParty,StockAddress,TradeTime,needContract,aimCustomer],
                               @[Amount,DiscountRate,Change,BillType,Acceptor,DueTimeRange,InquiryParty,TradeTime,needContract,aimCustomer]
                             ],
                           ];
            break;
        case StockAllType_Tade_askSell:
        case StockAllType_Tade_specifiedSell:
            subTitles = @[
                          @[
                              @[Amount,Acceptor,BillType,DueTimeRange,RemainingDays,TradeState,StockAddress],
                              @[Amount,Acceptor,BillType,DueTimeRange,RemainingDays,TradeState,StockAddress],
                            ]
                          ];
            break;
        case StockAllType_Assets:
            subTitles = @[
                          @[
                              @[Amount,Acceptor,BillType,DueTimeRange,RemainingDays,TradeState,StockAddress],
                              @[Amount,Acceptor,BillType,DueTimeRange,RemainingDays,TradeState]
                              ]
                          ];
            break;
        case StockAllType_TradingRecord_Seller_Market:
        case StockAllType_TradingRecord_Buyer_Market:
            subTitles =  @[
                           @[
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,CounterPartyName,TradeState,StockAddress,TradeType,needContract,aimCustomer],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,CounterPartyName,TradeState,TradeType,needContract,aimCustomer],
                            ],
                           @[
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,CounterPartyName,TradeState,StockAddress,TradeType,haveContract],
                               @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,CounterPartyName,TradeState,TradeType,haveContract],
                            ],
                           ];
            break;
        case StockAllType_Select_Trade:
            subTitles = @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,TradeState,StockAddress];
            break;
        case StockAllType_BillDetail:
            subTitles = @[Amount,DiscountRate,BillType,Acceptor,DueTimeRange,RemainingDays,StockAddress];
            break;
        default:
            break;
    }
    
    return subTitles;
}


+(NSArray *)getMineTitles{
    // return  @[@"账号信息",@"关于我们",@"问题反馈",@"检查更新",@"系统公告"];
    return @[   NSLocalizedString(@"UserCenter", nil),
                NSLocalizedString(@"AboutUs", nil),
                NSLocalizedString(@"FeedbackProblems", nil),
                NSLocalizedString(@"CheckUpdate", nil),
                NSLocalizedString(@"SystemNotice", nil)];
}

+(NSArray *)getMyProfileTitles{
    return @[    NSLocalizedString(@"AccountName", nil),    NSLocalizedString(@"CompanyName", nil),
                 NSLocalizedString(@"E-mail", nil),
                 NSLocalizedString(@"Phone", nil),          NSLocalizedString(@"TradeTimes", nil),
                 NSLocalizedString(@"SuccessTimes", nil),   NSLocalizedString(@"FailTimes", nil),
                 NSLocalizedString(@"SuccessAmount", nil),  NSLocalizedString(@"FailAmount", nil),
                 NSLocalizedString(@"SuccessRate", nil),
           ];
}
+(NSArray*)getStockAddTitles{
    return @[    NSLocalizedString(@"BillNum", nil),   NSLocalizedString(@"StockAmount", nil),
                 NSLocalizedString(@"Acceptor", nil),          NSLocalizedString(@"ReleaseDate", nil),
                 NSLocalizedString(@"ExpireDate", nil),    NSLocalizedString(@"DetailAddress", nil),
                 NSLocalizedString(@"CurrentCity", nil),   NSLocalizedString(@"PositiveImage", nil),
                 NSLocalizedString(@"BackImage", nil)
                 ];
}
+(NSArray*)getStockAddPlaceHolders{
    return @[NSLocalizedString(@"FillInEightDigitBillNum", @""),
             NSLocalizedString(@"AccurateToTwoDecimalPlaces", @""),
//             NSLocalizedString(@"FillInAcceptor", @""),
                    ];
}
+(NSArray*)getLoginPlaceHolders{
 
    return @[
             NSLocalizedString(@"PhoneNumber", @""),
             NSLocalizedString(@"Password", @""),
             NSLocalizedString(@"VerifyCode", @""),
             ];
}

+ (NSString *)getAmountText:(NSString *)text{
   // DEBUGLOG(@"%@",[NSString toCapitalLetters:[NSString stringWithFormat:@"%f",text.floatValue*10000]]);
    return [NSString toCapitalLetters:[NSString stringWithFormat:@"%f",text.floatValue*10000]];

}

+ (NSString *)judgeAmontInputWithText:(NSString *)text{
    if (text.length > 0 && ![text isPureFloat]) {
        return @"输入有误，请从新输入!";
    }
    
    //有小数
    if ([text containsString:@"."]) {
        NSString *str1 =  [[text componentsSeparatedByString:@"."] firstObject];
        NSString *str2 = [[text componentsSeparatedByString:@"."] lastObject];
        if (str1.length >= 2) {
            if ([str1 substringToIndex:1].intValue == 0) {
                return @"输入有误，请从新输入!";
            }
        }else if(str1.length == 0){
                return  @"输入有误，请从新输入!";
        }
        
        if (str2.length >2 ) {
            return @"询价金额只能保留两位小数!";
        }
    }else{
        //无小数
        if (text.length >= 2) {
            if ([text substringToIndex:1].intValue == 0) {
                return @"输入有误，请从新输入!";
            }
        }
    }
    return nil;
}

+ (NSString *)judgeDiscountRateInputWithText:(NSString *)text{
    if (text.length > 0 && ![text isPureFloat]) {
        return @"输入有误，请从新输入!";
    }
    
    //有小数
    if ([text containsString:@"."]) {
        NSString *str1 =  [[text componentsSeparatedByString:@"."] firstObject];
        NSString *str2 = [[text componentsSeparatedByString:@"."] lastObject];
        if (str1.length >= 2) {
            if ([str1 substringToIndex:1].intValue == 0) {
                return @"输入有误，请从新输入!";
            }
        }else if(str1.length == 0){
            return  @"输入有误，请从新输入!";
        }
        
        if (str2.length >3 ) {
            return @"贴现率只能保留三位小数!";
        }
    }else{
        //无小数
        if (text.length >= 2) {
            if ([text substringToIndex:1].intValue == 0) {
                return @"输入有误，请从新输入!";
            }
        }
    }
    return nil;
}



@end
