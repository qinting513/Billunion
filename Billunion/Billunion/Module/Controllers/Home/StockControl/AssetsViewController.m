
//
//  AssetsViewController.m
//  Billunion
//
//  Created by Waki on 2017/1/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AssetsViewController.h"
#import "StockAddController.h"
#import "KLineViewController.h"

#import "StockView.h"
#import "AssetsViewModel.h"
#import "StockViewProtocol.h"

@interface AssetsViewController ()<StockViewProtocol>
/** 票据资产  右上角 票据添加按钮 */
@property (nonatomic,strong) UIButton *rightBarBtn;

@end

@implementation AssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];

    NSArray * subTitles =  [Tools getSubTitlesWithStockAllType:StockAllType_Assets];
    
    [self layoutMainSelectViweWithTitles:@[NSLocalizedString(@"Assets", nil)]];
    [self layoutSelectViweWithTitles:@[  NSLocalizedString(@"PaperTicket", nil),
                                         NSLocalizedString(@"ElectricTicket", nil),
                                      ]];
    [self layoutScrollViewWithSubTitles:subTitles];
    [self addRightBarButtonItem:0];
    StockView *stockView = (StockView *)[self getStockViewWithIndex:0];
    stockView.delegate = self;
    [self requestAssetsList:stockView billType:1 page:1 isPullUp:NO];
    self.rightBarBtn.hidden = NO;
}

- (void)requestAssetsList:(StockView *)stockView
                 billType:(NSInteger)billType
                     page:(NSInteger)page
                 isPullUp:(BOOL)isPullUp{

    NSDictionary *params = @{
                             @"Page":@(page),
                             @"ItemNum":@(20),
                             @"BillType":@[ @(billType),@3 ],
                             };
    [AssetsViewModel requestPropertyBillListWithParams:params
                                          stockAllType:StockAllType_Assets
                                              response:^(NSArray *dataArr, NSString *errorStr) {
        [stockView handleResponseWithDataArray:dataArr
                                     errorStr:errorStr
                                     isPullUp:isPullUp];
    }];
}


-(UIButton *)rightBarBtn
{
    if (!_rightBarBtn) {
        _rightBarBtn = [UIButton buttonWithTitle:NSLocalizedString(@"AddStock", nil) titleFont:13
                                      titleColor:[UIColor colorWithRGBHex:0xffffff]
                                          target:self
                                          action:@selector(rightBarBtnClick:)];
        _rightBarBtn.frame = CGRectMake(0, 0, 80, 44);
        _rightBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBarBtn];
    }
    return _rightBarBtn;
}


-(void)addRightBarButtonItem:(NSInteger)index
{
    self.rightBarBtn.tag = index;
    if(self.stockType == stock_assets && index == 0){
        self.rightBarBtn.hidden = NO;
    }else{
        self.rightBarBtn.hidden = YES;
    }
}

- (void)subSelectedWithPage:(NSInteger)page{
    if (page == 1) {
        UIView *currentView =  [self getStockViewWithIndex:1];
        if ([currentView isKindOfClass:[StockView class]]) {
            ((StockView *)currentView).delegate = self;
            if (((StockView *)currentView).dataArray.count == 0) {
                [self requestAssetsList:(StockView *)currentView billType:2 page:1 isPullUp:NO];
            }
        }
    }

}

// 点击cell的操作
//- (void)stockDidSelectWithIndexPath:(NSIndexPath *)indexPath
//                          stockView:(id)view{
//    StockView *stockView = (StockView *)view;
//    NSLog(@"indexPath:%@ tableViewTag:%ld",indexPath,stockView.tag);
//}

- (void)rightBarBtnClick:(UIButton *)button{
    StockAddController *stockAddVC = [[StockAddController alloc] init];
    [self.navigationController pushViewController:stockAddVC animated:YES];
}


#pragma mark - 上拉 下拉刷新
-(void)stockViewHeaderRefresh:(StockView *)stockView
{
    if (  [stockView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView =  ( UIScrollView *)stockView.superview;
        NSInteger billType = 1 + superView.contentOffset.x / WIDTH;
        [self requestAssetsList:stockView billType:billType page:1 isPullUp:NO];
    }

}
-(void)stockViewFooterRefresh:(StockView *)stockView
{
    if (  [stockView.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView =  ( UIScrollView *)stockView.superview;
        NSInteger billType = 1 + superView.contentOffset.x / WIDTH;
        stockView.numPage ++;
        [self requestAssetsList:stockView billType:billType page:stockView.numPage isPullUp:YES];
    }
}

#pragma mark - 选择某个cell删除
-(void)stockView:(StockView *)stockView didSelectToDelete:(NSIndexPath *)indexPath{
    id model =  stockView.dataArray[indexPath.row];
    NSInteger status = [AssetsViewModel getBillStatusWithModel:model];
    if (status == 1 || status == 2 ) {
        [self.view showWarning: NSLocalizedString(@"ERROR_STOCK_CANT_DELETE", nil) ];
        return ;
    }
    NSInteger billId = [AssetsViewModel getBillIdWithModel:model];
    [AssetsViewModel requestDeleteStockWithBillId:billId response:^(NSString *errorStr) {
        if (!errorStr) {
            [Hud showTipsText:NSLocalizedString(@"DELETE_OK", nil)  ];
            [stockView.dataArray removeObject:model];
            [stockView tableViewReloadData];
        }
    }];
    
}

-(void)dealloc{
    DEBUGLOG(@"%s",__func__);
}


@end
