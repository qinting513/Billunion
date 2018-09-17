
//
//  CounterPartySearchController.m
//  Billunion
//
//  Created by Waki on 2017/4/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "CounterPartySearchController.h"
#import "CityViewController.h"
#import "CustomTopView.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "QTCityModel.h"
#import "CityTableViewCell.h"
#import "UIView+HUD.h"
#import "TradeViewModel.h"
#import "YYRefreshFooterView.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface CounterPartySearchController ()<CustomSearchViewDelegate>
@property (nonatomic,retain) CustomSearchView *searchView; //searchBar所在的view
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组

@property (nonatomic,retain) NSArray *currentCityArray;// 当前城市

/** 搜索相关 */
@property (nonatomic,strong)YYRefreshFooterView *footerRefresh;
@property (nonatomic,assign)NSInteger currentPage;

@end

@implementation CounterPartySearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setupUI
{
    self.dataArray = [NSMutableArray array];
    self.searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    self.searchView.backgroundColor = MainColor;
    self.searchView.delegate = self;
    
    if (self.searchType == SearchType_CounterParty) {
        self.title = @"交易对手选择";
        self.searchView.searchBar.placeholder = @"请输入交易对手";
    }else{
        self.title = @"承兑人选择";
        self.searchView.searchBar.placeholder = @"请输入承兑人";
    }
    if (self.currentStr) {
        self.searchView.searchBar.text = self.currentStr;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.searchView.searchBar becomeFirstResponder];
//    });
//
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.searchView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    if (self.searchType == SearchType_Acceptor) {
        self.footerRefresh = [[YYRefreshFooterView alloc] init];
        [self.footerRefresh addTarget:self action:@selector(footerRefresh:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:self.footerRefresh];
    }
    [self.searchView.searchBar becomeFirstResponder];
    
}

- (void)endEditSearch{
    [self.searchView.searchBar resignFirstResponder];
}
#pragma mark - 加载更多
-(void)footerRefresh:(YYRefreshFooterView*)refresh{
    self.currentPage ++;
    [self acceptorLoadDataWithKeyWord:self.searchView.searchBar.text page:self.currentPage];
}

-(void)acceptorLoadDataWithKeyWord:(NSString*)searchStr page:(NSInteger)page{
    __weak typeof(self) weakSelf = self;
    __weak UITableView *weakTableView = _tableView;
    [TradeViewModel searchAcceptorWithBillType:@1 keyWord:@[searchStr] page:page response:^(NSArray *array) {
        [weakSelf.footerRefresh endRefreshing];
        if (array.count == 0) {
            [Hud showTipsText:@"没有更多数据!"];
            weakSelf.currentPage --;
        }
        
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakTableView reloadData];
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditSearch];
}

#pragma mark --UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _searchView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 54;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *CounterParty = nil;
    if (self.searchType == SearchType_CounterParty) {
       CounterParty =  [TradeViewModel getCounterPartyNameWithModel:self.dataArray[indexPath.row]];
    }else{
        CounterParty = self.dataArray[indexPath.row];
    }
    cell.textLabel.text = CounterParty;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x939b9b];
    cell.backgroundColor = MainColor;

    return cell;
}

#pragma  mark - 选择方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.finishSelectBlock ?: self.finishSelectBlock(self.dataArray[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --CustomSearchViewDelegate
- (void)didSearchAction:(NSString *)searchStr{
    if (searchStr.length == 0) {
        return;
    }
    [self.dataArray removeAllObjects];
    self.currentStr = searchStr;
    if (self.searchType == SearchType_CounterParty) {
        __weak typeof(self) weakSelf = self;
        __weak UITableView *weakTableView = _tableView;
        [TradeViewModel searchVisitorWithKeyWord:searchStr response:^(NSArray *array) {
            weakSelf.dataArray = (NSMutableArray *)array;
            [weakTableView reloadData];
        }];
    }else{
        if (!searchStr || searchStr.length == 0) {
            return;
        }
   
        self.currentPage = 1;
        // 承兑人才需要翻页
        [self acceptorLoadDataWithKeyWord:searchStr page:self.currentPage];
    }
}

-(void)didSelectCancelBtn
{
     [self.searchView.searchBar resignFirstResponder];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
    [self.footerRefresh removeFromSuperview];
}

//
//- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
//{
//    //转成了可变字符串
//    NSMutableString *str = [NSMutableString stringWithString:aString];
//    //先转换为带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    //再转换为不带声调的拼音
//    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
//    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
//    NSString *pinYin = [str capitalizedString];
//    //转化为大写拼音
//    if(isGetFirst)
//    {
//        //获取并返回首字母
//        return [pinYin substringToIndex:1];
//    }
//    else
//    {
//        return pinYin;
//    }
//}
//-(BOOL)isZimuWithstring:(NSString *)string
//{
//    NSString* number=@"^[A-Za-z]+$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
//    return  [numberPre evaluateWithObject:string];
//}
@end
