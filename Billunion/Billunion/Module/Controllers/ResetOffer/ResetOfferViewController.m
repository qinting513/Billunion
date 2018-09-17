
//
//  ResetOfferViewController.m
//  Billunion
//
//  Created by Waki on 2017/3/2.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "ResetOfferViewController.h"
#import "StockView.h"
#import "InfoMationView.h"
#import "KLineViewModel.h"
#import "TradeViewModel.h"
#import "AddressViewController.h"
#import "TradeConfigView.h"


@interface ResetOfferViewController ()<StockViewProtocol,TradeConfigViewDelegate>{
    InfoMationView *_infoMationView;
    CGFloat _topViewH;
}

@property (nonatomic, strong) StockView *stockView;
@property (nonatomic, strong) TradeConfigView *tradeConfigView;


@end

@implementation ResetOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = NSLocalizedString(@"ModifyOffer", nil);
    NSArray * subTitles = [Tools getSubTitlesWithStockAllType:StockAllType_BillDetail];
    if (self.klineType == KLine_sellerMarket) {
        self.title = NSLocalizedString(@"QuoteBuy", nil);
    }
    
    if (self.billArray.count > 0) {
         [self tradeConfigView];
         [self setAmcount];
        
        [self addStockViewWithSubTitles:subTitles];
        _infoMationView = [[InfoMationView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_infoMationView];
    }
    
}

- (void)addStockViewWithSubTitles:(NSArray *)subTitles{
    self.stockView = [[StockView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-self.tradeConfigView.height) withTransactionType:TransactionType_SelectAll titles:subTitles];
    self.stockView.delegate = self;
    self.stockView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.stockView];

    
    self.stockView.dataArray = [NSMutableArray arrayWithArray:self.billArray];
    [self.stockView tableViewReloadData];
}

- (void)stockDidSelectWithIndexPath:(NSIndexPath *)indexPath stockView:(id)view{
    
    if (self.klineType == KLine_buyerOffer || self.klineType == KLine_sellerMarket) {
        return;
    }
    NSNumber *discountRate = [TradeViewModel getDiscountRateWithStockModel:self.billArray[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    if (discountRate) {
        _infoMationView.inputViewStr = [NSString stringWithFormat:@"%.3f",[discountRate floatValue]];
    }
    [_infoMationView showWithType:InfoMationViewType_InPut_DiscountRate];
    _infoMationView.inputTextViewBlock = ^(BOOL isSureBtn,NSString *message){
        if (isSureBtn && message) {
            [weakSelf didResetDiscountRate:message row:indexPath.row];
        }
    };
}

- (void)didResetDiscountRate:(NSString *)discountRate row:(NSInteger)row{
    NSNumber *rate = [NSNumber numberWithFloat:discountRate.floatValue];
    [TradeViewModel resetDiscountRate:rate stockModel:self.billArray[row]];
    [self.stockView tableViewReloadData];
    
     [self setAmcount];
}


- (TradeConfigView *)tradeConfigView{
    if (!_tradeConfigView) {
        
        TradeConfigViewType type;
        if (self.klineType == KLine_sellerMarket || self.klineType == KLine_nearStock) {
            type = TradeConfigViewType_sellerMarket;
        }else if (self.klineType == KLine_buyerOffer){
            type = TradeConfigViewType_buyerOffer;
        }else{
            type = TradeConfigViewType_other;
        }
        
        _tradeConfigView = [[TradeConfigView alloc] initWithKlineType:type];
        _tradeConfigView.delegate = self;
        [self.view addSubview:_tradeConfigView];
    }
    return _tradeConfigView;
}

//获取交割时间
- (NSNumber  *)getDelivery{
    return @(_tradeConfigView.delivery);
}

//获取是否匿名
-(NSNumber *)getAnonymous{
    if (_tradeConfigView.type == TradeConfigViewType_sellerMarket) {
       return  @(_tradeConfigView.select2Index);
    }else{
       return  @(_tradeConfigView.select1Index);
    }
}

//获取是否需要合同
- (NSNumber *)getNeedOrCanReceipt{
    return @(_tradeConfigView.select1Index);
}

//获取贴现率
- (NSNumber *)getDiscountRate{
    if ([_tradeConfigView.discountRateField.text isPureFloat] &&
        _tradeConfigView.discountRateField.text.floatValue > 0 &&
        _tradeConfigView.discountRateField.text.floatValue <= 100 ) {
        return [NSNumber numberWithFloat:_tradeConfigView.discountRateField.text.floatValue];
    }else{
        return nil;
    }
}


- (void)setAmcount{
    NSString *allAmount = [NSString stringWithFormat:@"%.2f",[KLineViewModel getAllAmountWithBillArray:self.billArray]];
    NSString *averageDiscountRate = [NSString stringWithFormat:@"%.3f%%",[KLineViewModel getAverageDiscountRateWithBillArray:self.billArray]];
    
    [self.tradeConfigView setAmcountWithAmcount:allAmount discountRate:averageDiscountRate];
}

#pragma mark - TradeConfigViewDelegate
- (void)didEnterTextField:(NSString *)text{
    for (int i = 0 ; i < self.billArray.count; i++) {
        [self didResetDiscountRate:text row:i];
   }
}

#pragma mark - 完成 按钮
- (void)okClick{
    __weak typeof(self) weakSelf = self;
    [Hud showActivityIndicator];
    NSArray *billRecords = [KLineViewModel getBillRecordsWithBillList:self.billArray];
    switch (self.klineType) {
        case KLine_beSellerSpecify:
        case KLine_beBuyerSpecify:
        case KLine_sellerOffer: {
                if (self.OfferId) {   //修改报价
                    if (self.klineType == KLine_beSellerSpecify) {
                        //被指定卖出 修改报价
                        [self resetBuyerOffer];
                    }else{
                        [KLineViewModel resetSellerOfferWithBillRecords:billRecords
                                                              TradeMode:self.OfferTradeMode
                                                                offerId:self.OfferId
                                                               response:^(BOOL isSecceed, NSString *message) {
                                                                   [Hud hide];
                                                                   [weakSelf.view showWarning:message];
                                                               }];
                    }
                }else if (self.InquiryId && self.klineType == KLine_beSellerSpecify){
                    //被指定卖出 (首次报价时) 点击买入   
                    [self tradeBuyerOfferWithBillRecords:billRecords isAnonymous:@0 needOrCanReceipt:nil];
                }
        }
            break;
        case KLine_sellerSpecify:   //指定卖出
        case KLine_sellerInquiry:{ //询价卖出修改报价
                [KLineViewModel resetSellerInquiryWithInquiryId:self.InquiryId
                                                    billRecords:billRecords
                                                       response:^(BOOL isSecceed, NSString *message) {
                                                           [Hud hide];
                    [weakSelf.view showWarning:message];
                 }];
            }
             break;
        case KLine_buyerOffer: {  //报价买入 修改报价
                [self resetBuyerOffer];
            }
             break;
        case KLine_sellerMarket:
        case KLine_nearStock:{ //卖方市场 /附近票源 点击买入
                if (![self getDiscountRate]) {
                    [Hud hide];
                    [self.view showWarning:NSLocalizedString(@"DISCOUNTRATE_ERROR", nil)];
                    return;
                }
                NSNumber *isAnonymous = [self getAnonymous];
                NSNumber * needOrCanReceipt = [self getNeedOrCanReceipt];
                [self tradeBuyerOfferWithBillRecords:billRecords isAnonymous:isAnonymous needOrCanReceipt:needOrCanReceipt];
        }
             break;
        default:
            break;
    }
}


- (void)tradeBuyerOfferWithBillRecords:(NSArray *)array
                           isAnonymous:(NSNumber *)isAnonymous
                      needOrCanReceipt:(NSNumber *)needOrCanReceipt{
    __weak typeof(self) weakSelf = self;
    NSNumber * delivery = [self getDelivery];
    [KLineViewModel tradeBuyerOfferWithBillRecords:array isAnonymous:isAnonymous inquiryId:self.InquiryId tradeTime:delivery needOrCanReceipt:needOrCanReceipt targetCustomer:nil address:nil response:^(NSString *message, BOOL isFailLocation) {
        if (isFailLocation) {
            [Hud hide];
            AddressViewController *vc = [[AddressViewController alloc] init];
            vc.normalBlock = ^(NSString *address,NSString *selectedCity){
                if (address != nil) {
                    [Hud showActivityIndicator];
                    [KLineViewModel tradeBuyerOfferWithBillRecords:array isAnonymous:isAnonymous inquiryId:self.InquiryId tradeTime:delivery needOrCanReceipt:needOrCanReceipt targetCustomer:nil address:address response:^(NSString *message, BOOL isFailLocation) {
                        [Hud hide];
                        (message == nil) ? : [weakSelf.view showWarning:message];
                    }];
                }
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
            //             @"定位失败,填写地址后自动报价"
            if(message){
                [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil)
                                                    message:message
                                                    okTitle:NSLocalizedString(@"Sure", nil)
                                                cancelTtile:nil
                                                     target:self
                                                 clickBlock:nil];
            }

        }else{
            if (message != nil) {
                [weakSelf.view showWarning:message];
            }
        }
    }];
}

// 被指定卖出 、报价买入 修改报价
- (void)resetBuyerOffer{
     __weak typeof(self) weakSelf = self;
    NSArray *billRecords = [KLineViewModel getBillRecordsWithBillList:self.billArray];
    [KLineViewModel resetBuyerOfferWithBillRecords:billRecords
                                           offerId:self.OfferId
                                           address:nil
                                          response:^(NSString *message, BOOL isFailLocation) {
          if (isFailLocation) { // 定位失败 去选择地址
              [Hud hide];
              AddressViewController *vc = [[AddressViewController alloc]init];
              vc.normalBlock = ^(NSString *address,NSString *selectedCity){
                  if (address != nil) {
                      [Hud showActivityIndicator];
                      [KLineViewModel resetBuyerOfferWithBillRecords:billRecords
                                                             offerId:self.OfferId
                                                             address:address
                                                            response:^(NSString *message, BOOL isFailLocation) {
                                                                [Hud hide];
                          [weakSelf.view showWarning:message];
                      }];
                  }
              };
              [weakSelf.navigationController pushViewController:vc animated:YES];
              //             @"定位失败,填写地址后自动报价"
              [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tips", nil)
                                                  message:message
                                                  okTitle:NSLocalizedString(@"Sure", nil)
                                              cancelTtile:nil
                                                   target:self
                                               clickBlock:nil];
          }else{
              [weakSelf.view showWarning:message];
          }
   
   }];

}


@end
