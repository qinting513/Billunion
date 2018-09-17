
//
//  MarketViewController.m
//  Billunion
//
//  Created by Waki on 2017/1/20.
//  Copyright © 2017年 JM. All rights reserved.
//

/**  ----------------- 票据行情  -----------------  */
#import "MarketViewController.h"
#import "StockAddController.h"
#import "KLineViewController.h"

#import "MarketViewModel.h"
#import "StockView.h"

#import "UIView+HUD.h"
#import "FilterViewController.h"

@interface MarketViewController ()<StockViewProtocol>

@property (nonatomic,strong)MarketViewModel *marketViewModel;
// 记录当前的stockView
@property (nonatomic,strong)StockView *currentStockView;


@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    
    [self layoutMainSelectViweWithTitles:@[NSLocalizedString(@"SellerMarket", nil),
                                           NSLocalizedString(@"BuyerMarket", nil)]];
    [self layoutSelectViweWithTitles:@[ NSLocalizedString(@"PaperTicket", nil),
                                        NSLocalizedString(@"ElectricTicket", nil)]];
    NSArray *subTitles =  [Tools getSubTitlesWithStockAllType:StockAllType_Seller_Market];
    [self layoutScrollViewWithSubTitles:subTitles];
    [self setupRightBarBtn];
    StockView *stockView = (StockView *)[self getStockViewWithIndex:0];
    stockView.delegate = self;
    self.currentStockView = stockView;
    [self setupStockViewBillType];
    [self refreshWithDict:nil page:1 isPullUp:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [Hud hide];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"filterDict: %@",self.currentStockView.filterDict);
}

-(void)setupRightBarBtn
{
    UIButton *btn= [UIButton buttonWithTitle: NSLocalizedString(@"Filter", nil)
                                   titleFont:13
                                  titleColor:[UIColor colorWithRGBHex:0xffffff]
                                      target:self
                                      action:@selector(rightBarBtnClick:)];
    btn.frame = CGRectMake(0, 0, 80, 44);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

#pragma mark - 点击筛选
// 注意 此方法要在记住 currentStockView 后调用才有用
-(void)setupStockViewBillType{
    
    NSInteger billType = 1;
    if (  [self.currentStockView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView =  ( UIScrollView *)self.currentStockView.superview;
        billType = billType + superView.contentOffset.x / WIDTH;
    }
    
    if ([self.currentStockView.filterDict[kBillType] count] == 0) {
        // 第一次点击 初始化操作
        self.currentStockView.filterDict[kBillType] = @[@(billType)];
    }
}

-(void)rightBarBtnClick:(UIButton *)btn{
    
    FilterViewController *vc = [[FilterViewController alloc]init];
    vc.filterDict = self.currentStockView.filterDict;
    
    __weak typeof(self) weakSelf = self;
    vc.finishFilterBlock = ^(NSDictionary *dict){
        // 要先移除 防止网络请求不到 原来的数据又没清理掉
       [weakSelf.currentStockView.dataArray removeAllObjects];
       [weakSelf.currentStockView tableViewReloadData];
        
        weakSelf.currentStockView.filterDict = [dict mutableCopy];
        [weakSelf refreshWithDict:dict page:1 isPullUp:NO];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 点击title方法
- (void)mainSelectedWithPage:(NSInteger)page{
    UIScrollView *scrollView = [self getCurrentSrollView];
    [self subSelectedWithPage:(scrollView.contentOffset.x / WIDTH)];
}


- (void)subSelectedWithPage:(NSInteger)page{
    StockView *stockView = (StockView*)[self getStockViewWithIndex:page];
    self.currentStockView = stockView;
    [self setupStockViewBillType];
    stockView.delegate = self;
    if (stockView.dataArray.count == 0) {
        [Hud showActivityIndicator];
        [self refreshWithDict:stockView.filterDict page:1 isPullUp:NO];
    }
}

#pragma mark - Cell的点击
- (void)stockDidSelectWithIndexPath:(NSIndexPath *)indexPath
                          stockView:(id)view{
    StockView *stockView = (StockView *)view;
    NSInteger tag = stockView.tag;
    if(tag-190010 == 0) {
        KLINE_TYPE kLineType;
        KLineViewController *vc = [[KLineViewController alloc]init];
        kLineType = (self.segmentSelectIndex == 0)? KLine_sellerMarket : KLine_buyerMarket;
        vc.kLineType = kLineType;
        [vc.kLineViewModel setCurrentModel:stockView.dataArray[indexPath.row] type:kLineType];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 上下拉刷新
-(void)stockViewHeaderRefresh:(StockView *)stockView
{

      [self refreshWithDict:stockView.filterDict page:1 isPullUp:NO ];
}
-(void)stockViewFooterRefresh:(StockView *)stockView
{
    stockView.numPage ++;
    [self refreshWithDict:stockView.filterDict page:stockView.numPage isPullUp:YES ];
}

#pragma mark - 网络请求主要方法
-(void)refreshWithDict:(NSDictionary*)dict page:(NSInteger)page isPullUp:(BOOL)isPullUp {
    if (dict.count > 1) { //有筛选条件的，只要去筛选界面过 无论如何都设置了billType
        NSArray *billType       =  dict[kBillType];
        NSArray *acceptors      =  [Tools getAcceptorCodeWithAcceptors:dict[kAcceptor] billTypes:billType];
        NSArray *dueTimeRanges  =  [Tools getDueTimeRangeCodeWithDueTimeRanges:dict[kDueTimeRange] billTypes:billType];
        NSArray  *arr           =  dict[kAddress];
      
        NSMutableString *address = [NSMutableString string];
        if (arr.count > 0) {
            for (NSString *str in arr) {
                [address appendFormat:@"%@,",str];
            }
            /** 去除最后的 , */
            NSRange range = {address.length - 1 ,1};
            [address replaceCharactersInRange:range withString:@""];
        }

        [self requestWithBillType:billType
                          numPage:page
                        stockView:self.currentStockView
                     acceptorType:acceptors
                     dueTimeRange:dueTimeRanges
                          address:address
                         isPullUp:isPullUp];
    }else{ //没有筛选条件的
        UIScrollView *superView = ( UIScrollView *)self.currentStockView.superview;
        NSInteger offset = superView.contentOffset.x / WIDTH;
        NSArray *billTypes = (offset == 0) ? @[@1] : @[@2,@3]; //1 纸票 2,3是电票
        [self requestWithBillType:billTypes
                          numPage:page
                        stockView:self.currentStockView
                     acceptorType:nil
                     dueTimeRange:nil
                          address:nil
                         isPullUp:isPullUp];
    }
}

-(void)requestWithBillType:(NSArray*)billTypes
                   numPage:(NSInteger)numPage
                 stockView:(StockView*)stockView
              acceptorType:(NSArray*)acceptorType
              dueTimeRange:(NSArray*)dueTimeRange
                   address:(NSString *)address
                  isPullUp:(BOOL)isPullUp{
  
    if (self.segmentSelectIndex == 0) {
        /**
         卖方市场数据请求
         @param type 1为纸票 2,3为电票
         */
        [MarketViewModel requestSellerInquiryListWithBillType:billTypes
                                                         page:numPage
                                                      itemNum:20
                                                 acceptorType:acceptorType
                                                 dueTimeRange:dueTimeRange
                                                      address:address
                                                     response:^(NSArray *dataArr, NSString *errorStr) {
         [stockView handleResponseWithDataArray:dataArr
                                      errorStr:errorStr
                                      isPullUp:isPullUp];
                                                     }];
    }else{
        /** 买方市场数据请求 */
        [MarketViewModel requestBuyerInquiryListWithBillType:billTypes
                                                        page:numPage
                                                acceptorType:acceptorType
                                                dueTimeRange:dueTimeRange
                                                     address:address
                                                    response:^(NSArray *dataArr, NSString *errorStr) {
      [stockView handleResponseWithDataArray:dataArr
                                   errorStr:errorStr
                                   isPullUp:isPullUp];
                                                    }];
    }
    
}

-(void)dealloc{
    DEBUGLOG(@"%s",__func__);
}

@end
