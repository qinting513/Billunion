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

@interface BuyerInfoViewController ()<UITableViewDataSource,UITableViewDelegate,BuyerInfoLastCellDelegate>

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *sectionTitles;

@property (nonatomic,assign) NSInteger sectionZeroRows;
@property (nonatomic,assign) BOOL isDetail;
@end

@implementation BuyerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = @"买家信息";
    self.sectionZeroRows = 1;
    self.isDetail = NO;
    self.tableView.hidden = NO;
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
        _tableView.rowHeight = 48;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"报价方",@"联系人",@"联系电话",@"交易笔数",@"成功笔数",@"失败笔数"];
    }
    return _titles;
}
-(NSArray *)sectionTitles
{
    if (_sectionTitles == nil) {
        _sectionTitles = @[@"票据详情",@"基本资料"];
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
            cell = [self getCellWith:tableView cellID:@"BillInfoCell"];
            break;
        }
        case 1:
        {
           
            BuyerInfoCell * buyerInfoCell = (BuyerInfoCell*)[self getCellWith:tableView cellID:@"BuyerInfoCell"];
            buyerInfoCell.titleLabel.text = self.titles[indexPath.row];
            cell = buyerInfoCell;
            break;
        }
        default:
        {
            BuyerInfoLastCell *lastCell = (BuyerInfoLastCell*)[self getCellWith:tableView cellID:@"BuyerInfoLastCell"];
            lastCell.delegate = self;
            cell = lastCell;
        }
    }
    
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
        return 36*6;
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
        view.detailBtnClickBlock = ^(BOOL isDetail){
            NSLog(@"详情按钮点击");
            self.isDetail = isDetail;
            self.sectionZeroRows = isDetail ? 0 : 1;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        
        if (section == 1) {
            view.detailBtn.hidden = YES;
        }
        return view;
    }else{
        return nil;
    }
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 成交btn
-(void)transactionBtnClick{
    
    NSLog(@"transactionBtnClick");
    
}

@end
