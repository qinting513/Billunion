
//
//  RateMarketViewController.m
//  Billunion
//
//  Created by Waki on 2017/1/13.
//  Copyright © 2017年 JM. All rights reserved.
//


//#define ButtonTag 278
#define ItemBgViewTag 334
#define Space 8
#define ItemTag  233
#import "KLineView.h"
#import "RateMarketViewController.h"
#import "MoreIndexViewModel.h"

@interface RateMarketViewController ()<UITableViewDelegate,UITableViewDataSource,KlineViewDelegate>{
    UIButton *_lastBtn;
}

@property (nonatomic ,strong) UITableView *tableView;
@property (strong,nonatomic) KLineView *klineView;

@end

@implementation RateMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title= @"利率市场";
    [self setupBakcButton];
    [self layoutTableView];
    
    //默认请求k线图的时线
    [self klineViewSelect:0];
}

- (void)layoutTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"rateMarketCellOne"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rateMarketCellOne"];
            [self layoutSectionOne:cell];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"rateMarketCellTwo"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rateMarketCellTwo"];
            [self layoutSectionTwo:cell];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = MainColor;
    return cell;
}


- (NSString *)getTitleWithRateMarketType:(RateMarketType)type{
    NSString *string = [Tools getAcceptor1:[self.acceptorType intValue]];
    if (type == P_bank_note) {
        return [NSString stringWithFormat:@"%@纸票贴现率",string];
    }else{
        return [NSString stringWithFormat:@"%@电票贴现率",string];;
    }
}

- (void)layoutSectionOne:(UITableViewCell *)cell{
    UIView *bgView = cell.contentView;
    NSArray *itmeTitles;
    if (self.rateMarketType == P_bank_note) {
        itmeTitles = [Tools getDueTimeRangeWithBillType:1];
    }else{
       itmeTitles = [Tools getDueTimeRangeWithBillType:2];
    }

    NSString *title = [self getTitleWithRateMarketType:self.rateMarketType];
    
    UILabel *titleLabel = [UILabel labelWithText:title fontSize:14 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [bgView addSubview:titleLabel];
    titleLabel.sd_layout.topSpaceToView(bgView,10).leftSpaceToView(bgView,35).rightSpaceToView(bgView,0).heightIs(16);
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_date1"];
    [cell.contentView addSubview:imgView];
    imgView.sd_layout.leftSpaceToView(bgView,10).centerYEqualToView(titleLabel).widthIs(18).heightIs(18);
    
    UIView *itemBgView = [[UIView alloc] init];
    itemBgView.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
    itemBgView.tag = ItemBgViewTag;
    [bgView addSubview:itemBgView];
    CGFloat itemViewHeight = self.rateMarketType == P_bank_note ? STRealY(250)/2 : STRealY(250);
    itemBgView.sd_layout.topSpaceToView(titleLabel,12).leftSpaceToView(bgView,10).rightSpaceToView(bgView,10).heightIs(itemViewHeight);
    
    CGFloat itemWith = (WIDTH-20-5)/4;
    CGFloat itemHeight = (STRealY(250)-5)/4;
    for (int i = 0; i < itmeTitles.count+2; i++) {
        if (i<itmeTitles.count) {
            UIButton *button = [UIButton buttonWithTitle:itmeTitles[i] titleFont:13 titleColor:[UIColor whiteColor] target:self action:@selector(itmeClick:)];
            button.backgroundColor = [UIColor blackColor];
            button.frame = CGRectMake(1+(itemWith+1)*(i%4), 1+(itemHeight+1)*(i/4), itemWith, itemHeight);
            [itemBgView addSubview:button];
            button.tag = i+ItemTag;
            //默认选择
            if (i == 0) {
                 _lastBtn = button;
                _lastBtn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                [_lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(1+(itemWith+1)*(i%4), 1+(itemHeight+1)*(i/4), itemWith, itemHeight)];
            view.backgroundColor = [UIColor blackColor];
            [itemBgView addSubview:view];
        }
    }
}

- (void)itmeClick:(UIButton *)btn{
//    static NSInteger btnTag = ButtonTag;
//   UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UIView *itemBgView = [cell.contentView viewWithTag:ItemBgViewTag];
//    UIButton *lastBtn = [itemBgView viewWithTag:btnTag];
    _lastBtn.backgroundColor = [UIColor blackColor];
     btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
     [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lastBtn = btn;
}


- (void)layoutSectionTwo:(UITableViewCell *)cell{
    
    CGFloat cellHeight = 210;
//        NSArray *dataArr = [KlineModel getDatas];
//        
//        NSMutableArray *xArray = [NSMutableArray array];
//        NSMutableArray *yArray = [NSMutableArray array];
//        for (NSInteger i = 0; i < dataArr.count; i++) {
//            KlineModel *model = dataArr[i];
//            
//            [xArray addObject:[NSString stringWithFormat:@"%@",model.timeDate]];
//            [yArray addObject:[NSString stringWithFormat:@"%.2f",[model.percent floatValue]]];
//            
////                    [yArray addObject:[NSString stringWithFormat:@"%.2lf",5.0+arc4random_uniform(10)]];
//            
//        }
        _klineView = [[KLineView alloc] initWithFrame:CGRectMake(Space, Space, WIDTH-Space*2, cellHeight-Space*2) xTitleArray:nil yValueArray:nil yMax:10 yMin:0];
        _klineView.delegate = self;
        [cell.contentView addSubview:_klineView];
    
}


#pragma  mark - KlineViewDelegate
- (void)klineViewSelect:(NSInteger)index{
    __weak typeof(self) weakSelf = self;
    
    NSNumber *dueTimeRange;
    if (self.rateMarketType == P_bank_note) { //纸票
        if (!_lastBtn) {
            dueTimeRange = @3;
        }else{
           dueTimeRange = [NSNumber numberWithInteger:(_lastBtn.tag-ItemTag+3)];
        }
    }else{
        if (!_lastBtn) {
            dueTimeRange = @1;
        }else{
            dueTimeRange = [NSNumber numberWithInteger:(_lastBtn.tag-ItemTag)];
        }
    }
   [MoreIndexViewModel requestRateMarketTrendWithType:index
                                         acceptorType:self.acceptorType
                                             billType:[NSNumber numberWithInteger:self.rateMarketType+1]
                                         dueTimeRange:dueTimeRange
                                             response:^(NSArray *dataArray, NSString *errorStr) {
                                                 if (dataArray) {
                                                  [weakSelf reloadKlineViewWithDataArray:dataArray];
                                                 }
                                             }];
}

- (void)reloadKlineViewWithDataArray:(NSArray *)dataArray{
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        KlineModel *model = dataArray[i];
        [xArray addObject:model.timeDate];
        [yArray addObject:model.percent];
    }
    _klineView.dataArray = @[xArray,yArray];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.rateMarketType == P_bank_note) {
            return STRealY(250)/2+50;
        }else{
           return STRealY(250)+50;
        }
    }else{
        return 210;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    view.backgroundColor = [UIColor blackColor];
    return view;
}



@end
