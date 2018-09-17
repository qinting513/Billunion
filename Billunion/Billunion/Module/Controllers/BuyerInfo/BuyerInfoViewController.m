//
//  BuyerInfoViewController.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyerInfoViewController.h"
#import "BuyerInfoCell.h"
#import "BuyerInfoHeadView.h"
#import "BuyerInfoLastCell.h"
#import "BillInfoCell.h"
#import "TradeViewModel.h"
#import "KLineViewModel.h"

/** 这个控制 分为"票据详情",@"基本资料" ，票据详情可展开或者收缩
 */

@interface BuyerInfoViewController ()<UITableViewDataSource,UITableViewDelegate,BuyerInfoLastCellDelegate,StockViewProtocol>

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *sectionTitles;
//子标题数组
@property (nonatomic,strong) NSArray *subTitles;


/** 分组0  0：收缩,此时 self.isDetail = YES;   1：展开 */
@property (nonatomic,assign) NSInteger sectionZeroRows;
@property (nonatomic,assign) BOOL isDetail;

@end

@implementation BuyerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = @"报价方信息";
    self.sectionZeroRows = 1;
    self.isDetail = (self.sectionZeroRows == 0);
    self.subTitles = [Tools getSubTitlesWithStockAllType:StockAllType_BillDetail];
    self.inquiryInfoVM.transactionType = self.transactionType;

    [self tableView];
    [self loadData];
    
}

-(InquiryInfoViewModel *)inquiryInfoVM
{
    if (!_inquiryInfoVM) {
        _inquiryInfoVM = [[InquiryInfoViewModel alloc]init];
    }
    return _inquiryInfoVM;
}

-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    [InquiryInfoViewModel requestInqueryInfoWithTradeSide:0 CompanyId:[self.inquiryInfoVM getCompanyId] Response:^(id model, NSString *errorStr) {
        if (errorStr) {
            [weakSelf.view showWarning:errorStr];
        }else{
             [weakSelf.inquiryInfoVM setCurrentModel: model];
             [weakSelf.tableView reloadData];
        }
    }];
    
}

#pragma mark - 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = [Tools getOfferTitles];
    }
    return _titles;
}
-(NSArray *)sectionTitles
{
    if (_sectionTitles == nil) {
        _sectionTitles = @[@"票据详情",@"基本信息"];
    }
    return _sectionTitles;
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    switch (section) {
        case 0:
            // 票据信息
            return self.sectionZeroRows;
        case 1:
            // 基本资料
            return self.titles.count;
        default:
            // 成交
            return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {   /** 票据详情 */

            static NSString *cellID = @"BillInfoCell";
            BillInfoCell* billCell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!billCell) {
                billCell = [[BillInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:36*([self.inquiryInfoVM getBillList].count+1) transactionType:self.transactionType subTitles:self.subTitles];
                
            }
            billCell.stockView.delegate = self;
            billCell.dataArray = [self.inquiryInfoVM getBillList];
            cell = billCell;
            break;
        }
        case 1:
        {
           
            BuyerInfoCell * buyerInfoCell = (BuyerInfoCell*)[self getCellWith:tableView cellID:@"BuyerInfoCell"];
            buyerInfoCell.titleLabel.text = self.titles[indexPath.row];
            buyerInfoCell.contentLabel.text = [self.inquiryInfoVM getUserInfoWithIndexPath:indexPath isHaveContact:NO];
            cell = buyerInfoCell;
            break;
        }
        default:
        {
            /** 只有一个按钮的cell */
            BuyerInfoLastCell *lastCell = (BuyerInfoLastCell*)[self getCellWith:tableView cellID:@"BuyerInfoLastCell"];
            lastCell.delegate = self;
            lastCell.rateLabel.text  = [self.inquiryInfoVM getDiscountRate];
            lastCell.moneyLabel.text = [self.inquiryInfoVM getAmount];
            cell = lastCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = MainColor;
    cell.contentView.backgroundColor = MainColor;
     return cell;

}

-(UITableViewCell*)getCellWith:(UITableView*)tableView cellID:(NSString *)cellID
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ NSClassFromString(cellID) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
    }

    return  cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 36*([self.inquiryInfoVM getBillList].count+1);
    }
    if (indexPath.section == 2) {
        return 59;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0.001;
    }
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   if(section == 0)  return 4;
   else              return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 2) {
        BuyerInfoHeadView *view = [[BuyerInfoHeadView alloc]initWith:self.isDetail];
        view.titleLabel.text = self.sectionTitles[section];
        __weak typeof(self) weakSelf = self;
        view.detailBtnClickBlock = ^(BOOL isDetail){
            weakSelf.isDetail = isDetail;
            weakSelf.sectionZeroRows = isDetail ? 0 : 1;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
            [weakSelf.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        if (section == 1) {
            view.detailBtn.hidden = YES;
        }
        return view;
    }
    
    return nil;
}


#pragma mark - 成交按钮
-(void)transactionBtnClick{
    
    if ([self.inquiryInfoVM getBillRecords].count == 0) {
        [self.view showWarning:@"您需选择票据才能进行成交!"];
        return;
    }
    
    [TradeViewModel tradeSelectWithInquiryId:[self.inquiryInfoVM getInquiryId]
                                     offerId:[self.inquiryInfoVM getOfferId]
                                tradeRecords:[self.inquiryInfoVM getBillRecords]
                                    response:^(BOOL isSeccess, NSString *message) {
                                        if (isSeccess) {
                                            [Hud showTipsText:message];
                                        }
                                    }];
    
}


//挑票选择
- (void)stockSelectedWithIndexArray:(NSArray *)indexArray{
    
    if (self.inquiryInfoVM.klineType != KLine_buyerInquiry &&
        self.inquiryInfoVM.klineType != KLine_buyerSpecify) {
        return;
    }
    
    [self.inquiryInfoVM setIndexArray:indexArray];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}


@end
