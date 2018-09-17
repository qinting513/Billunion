//
//  StockInfoViewController.m
//  Billunion
//
//  Created by QT on 17/1/18.
//  Copyright © 2017年 JM. All rights reserved.
//


#import "CounterPartyViewController.h"
#import "BuyerInfoCell.h"
#import "BuyerInfoHeadView.h"
#import "InquiryInfoViewModel.h"

#define kMargin 30
#define kBtnHeight 40

/** 这个只有在 票据交易才出现 查看交易对手信息 */
@interface CounterPartyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *sectionTitles;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) InquiryInfoViewModel *inquiryInfoVM;

@end

@implementation CounterPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = @"交易对手信息";
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
   //  self.companyId = @(1142);
    [InquiryInfoViewModel requestInqueryInfoWithTradeSide:0 CompanyId:self.companyId Response:^(id model, NSString *errorStr) {
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
        _tableView.tableFooterView = self.footerView;
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
        _titles = [Tools getCounterPartyTitles];
    }
    return _titles;
}
-(NSArray *)sectionTitles
{
    if (_sectionTitles == nil) {
        _sectionTitles = @[@"基本信息"];
    }
    return _sectionTitles;
}

-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIDTH, 200)];
        NSArray *btnNames = @[@"交易成功",@"交易失败"];
        CGFloat width = WIDTH - kMargin*2;
        for (int i=0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithTitle:btnNames[i] titleFont:13.0f titleColor:[UIColor whiteColor] target:self action:@selector(btnClick:)];
            btn.tag = i;
            if (i == 0) {
                 btn.backgroundColor = [UIColor colorWithRGBHex:0x2262ac];
              
            }else{
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitleColor:[UIColor colorWithRGBHex:0x2262ac] forState:UIControlStateNormal];
            }
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 4;
            btn.layer.borderColor = [UIColor colorWithRGBHex:0x2262ac].CGColor;
            btn.layer.masksToBounds = YES;
            
            btn.frame = CGRectMake(kMargin, kMargin+(15+kBtnHeight)*i, width, kBtnHeight);
            [_footerView addSubview:btn];
        }
    }
    return _footerView;
}

//@"交易成功",@"交易失败"
-(void)btnClick:(UIButton*)btn
{
    NSLog(@"btn");
}

#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BuyerInfoCell * cell = (BuyerInfoCell*)[self getCellWith:tableView cellID:@"BuyerInfoCell"];
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.contentLabel.text = [self.inquiryInfoVM getUserInfoWithIndexPath:indexPath isHaveContact:YES];
    return cell;
}

-(UITableViewCell*)getCellWith:(UITableView*)tableView cellID:(NSString *)cellID
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ NSClassFromString(cellID) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
    }
    cell.backgroundColor = MainColor;
    cell.contentView.backgroundColor = MainColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 39;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BuyerInfoHeadView *view = [[BuyerInfoHeadView alloc]initWith:NO];
    view.titleLabel.text = self.sectionTitles[section];
    view.detailBtn.hidden = YES;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,39-0.5, WIDTH, 0.5)];
    lineView.backgroundColor = SeparatorColor;
    [view addSubview:lineView];
    return view;
}



@end
