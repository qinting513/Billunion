//
//  BuyViewController.m
//  PCStock
//
//  Created by Waki on 2016/12/27.
//  Copyright © 2016年 JM. All rights reserved.
//


#import "BuyViewController.h"
#import "KLineViewController.h"
#import "StockView.h"
#import "BuyViewModel.h"

@interface BuyViewController ()<StockViewProtocol>


@end

@implementation BuyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

 
    
    NSArray *titles = @[NSLocalizedString(@"AskBuy",            nil),
                        NSLocalizedString(@"SpecifiedBuy",      nil),
                        NSLocalizedString(@"QuoteBuy",          nil),
                        NSLocalizedString(@"BeSpecifiedSell",   nil)];
    NSArray *subTitles = [Tools getSubTitlesWithStockAllType:StockAllType_MyBuying_askBuying];
    
    self.stockType = stock_buying;
    [self layoutMainSelectViweWithTitles:@[ NSLocalizedString(@"PaperTicket", nil),
                                            NSLocalizedString(@"ElectricTicket", nil)]];
    [self layoutSelectViweWithTitles:titles];
    [self layoutScrollViewWithSubTitles:subTitles];
 
    [self loadData];
 
}

-(void)loadData{
    StockView *stockView = (StockView *)[self getStockViewWithIndex:0];
    [self requestBuyDataWithStockView:stockView billType:1 viewPage:0 numPage:1 isPullUp:NO];
}



- (void)requestBuyDataWithStockView:(StockView *)stockView
                           billType:(NSInteger)billType
                           viewPage:(NSInteger)viewPage
                            numPage:(NSInteger)numPage
                           isPullUp:(BOOL)isPullUp
{
    stockView.delegate = self;
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    [mutableDic setObject:@[@(billType)] forKey:@"BillType"];
    NSArray *AcceptorIdentityTypeArr = @[@1];
    NSArray *AcceptorTypeArr = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    [mutableDic setObject:AcceptorIdentityTypeArr forKey:@"AcceptorIdentityType"];
    [mutableDic setObject:AcceptorTypeArr forKey:@"AcceptorType"];
    [mutableDic setObject:@[@0,@1,@2]  forKey:@"TradeStatus"];
    [mutableDic setObject:[BuyViewModel getBuyTradeRoleWithViewPage:viewPage] forKey:@"TradeRole"];
    [mutableDic setObject:@(numPage)  forKey:@"Page"];
    [mutableDic setObject:@(20)  forKey:@"ItemNum"];

    [BuyViewModel requestTradeManualListWithParams:mutableDic response:^(NSArray *dataArr, NSString *errorStr) {
        [stockView handleResponseWithDataArray:dataArr
                                     errorStr:errorStr
                                     isPullUp:isPullUp];
    }];
}



- (void)mainSelectedWithPage:(NSInteger)page{
    if (page == 1) {
        UIView *currentView =  [self getStockViewWithIndex:0];
        if ([currentView isKindOfClass:[StockView class]]) {
            if (((StockView *)currentView).dataArray.count == 0) {
                [self requestBuyDataWithStockView:(StockView *)currentView
                                         billType:2
                                         viewPage:0
                                          numPage:1
                                         isPullUp:NO];
            }
        }
    }
}

- (void)subSelectedWithPage:(NSInteger)page{
    UIView *currentView =  [self getStockViewWithIndex:page];
    if ([currentView isKindOfClass:[StockView class]]) {
        if (((StockView *)currentView).dataArray.count == 0) {
            if (self.segmentSelectIndex == 0) {
                [self requestBuyDataWithStockView:(StockView *)currentView
                                         billType:1
                                         viewPage:page
                                          numPage:1
                                         isPullUp:NO];
            }else{
                [self requestBuyDataWithStockView:(StockView *)currentView
                                         billType:2
                                         viewPage:page
                                          numPage:1
                                         isPullUp:NO];
            }

        }
    }
}




- (void)stockDidSelectWithIndexPath:(NSIndexPath *)indexPath
                          stockView:(id)view{
    StockView *stockView = (StockView *)view;
    NSInteger tag = stockView.tag;

    if (self.segmentSelectIndex != 0) {
        return;
    }
    KLineViewController *vc = [[KLineViewController alloc]init];
    KLINE_TYPE kLineType;
    switch (tag-190010) {
        case 0:   {  kLineType= KLine_buyerInquiry;
            break;
        }
        case 10:  { kLineType = KLine_buyerSpecify;
            break;
        }
        case 20:  { kLineType = KLine_buyerOffer;
            break;
        }
        case 30:  { kLineType = KLine_beSellerSpecify;
            break;
        }
        default:
            break;
    }
    vc.title = NSLocalizedString(@"Trade", nil) ;
    vc.kLineType = kLineType;
    [vc.kLineViewModel setCurrentModel:stockView.dataArray[indexPath.row] type:kLineType];
    [self.navigationController pushViewController:vc animated:YES];
}

/** 下拉刷新 */
-(void)stockViewHeaderRefresh:(StockView *)stockView
{
    if ([stockView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView = ( UIScrollView *)stockView.superview;
            [self requestBuyDataWithStockView:stockView
                                     billType:(self.segmentSelectIndex+1)
                                     viewPage:(superView.contentOffset.x/WIDTH)
                                      numPage:1
                                     isPullUp:NO];
    }

}
-(void)stockViewFooterRefresh:(StockView *)stockView
{
    if ([stockView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView = ( UIScrollView *)stockView.superview;
         stockView.numPage ++;
        [self requestBuyDataWithStockView:stockView
                                 billType:(self.segmentSelectIndex+1)
                                 viewPage:(superView.contentOffset.x/WIDTH)
                                  numPage:stockView.numPage
                                 isPullUp:YES];
    }

}



@end
