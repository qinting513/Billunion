//
//  CityViewController.m
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import "CityViewController.h"
#import "CustomTopView.h"
#import "CustomSearchView.h"
#import "ResultCityController.h"
#import "QTCityModel.h"
#import "CityTableViewCell.h"
#import "UIView+HUD.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface CityViewController ()<CustomTopViewDelegate,CustomSearchViewDelegate,ResultCityControllerDelegate>
@property (nonatomic,retain) CustomSearchView *searchView; //searchBar所在的view
@property (nonatomic,retain)UIView *blackView; //输入框编辑时的黑色背景view
@property (nonatomic,retain)NSDictionary *bigDic; // 读取本地plist文件的字典
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *rightIndexArray; // 右边索引数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@property (nonatomic,retain)NSMutableArray *pinYinArray; // 地区名字转化为拼音的数组
@property (nonatomic,retain)ResultCityController *resultController;//显示结果的controller

@property (nonatomic,retain) NSArray *currentCityArray;// 当前城市

@end

@implementation CityViewController

-(UIView *)blackView
{
    if(!_blackView)
    {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _blackView.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6];
        _blackView.alpha = 0;
        [self.view addSubview:_blackView];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectCancelBtn)];
        [_blackView addGestureRecognizer:ges];
    }
    return _blackView;
}
-(ResultCityController *)resultController
{
    if(!_resultController)
    {
        _resultController = [[ResultCityController alloc] init];
        
        _resultController.view.frame = CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT);
        _resultController.delegate = self;
        [self.view addSubview:_resultController.view];
    }
    return _resultController;
}
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
    [self loadData];
    self.searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 44)];
    self.searchView.backgroundColor = MainColor;
    self.searchView.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView  = _searchView;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor colorWithRGBHex:0x939b9b];
    _tableView.sectionIndexBackgroundColor = MainColor;
    [self.view addSubview:_tableView];
    if (!self.isAddStock) {
        UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(@"Sure", nil) titleFont:13.0 titleColor:[UIColor colorWithRGBHex:0xfefefe] target:self action:@selector(rightBtnClick)];
        btn.frame = CGRectMake(0, 0, 50, 44);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }

}

-(NSMutableArray *)hotCityArray
{
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray array];
    }
    return _hotCityArray;
}

/** 右侧的确定按钮 */
-(void)rightBtnClick{
    
    !self.finishSelectCityBlock ?: self.finishSelectCityBlock(self.hotCityArray);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==1)
    {
        return 1;
    }
    else
    {
        return [self.dataArray[section-2] count];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderIdentifier = @"header";
   UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRGBHex:0xffffff];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = MainColor;
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.text = self.sectionTitlesArray[section];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 40;
    }
    else if (indexPath.section==1)
    {
        return 40;
    }
    else
    {
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CityTableViewCell*)getCellWith:(UITableView *)tableView data:(NSArray *)arr
{
    __weak typeof(self) weakSelf = self;
    static NSString *cellID = @"CityTableViewCell";
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
        cell.backgroundColor = MainColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.didSelectedBtnBlcok = ^(NSArray *cityArray){
            if (weakSelf.isAddStock) {
                !weakSelf.finishSelectCityBlock ?: weakSelf.finishSelectCityBlock(cityArray);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [weakSelf.hotCityArray removeAllObjects];
                [weakSelf.hotCityArray addObjectsFromArray:cityArray];
                weakSelf.title = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"SelectedAddress", nil),weakSelf.hotCityArray.count];
                if (weakSelf.hotCityArray.count == 0) {
                    weakSelf.title = NSLocalizedString(@"SelectedAddress", nil);
                }
            }
        };
    }
    
    [cell setCellInfo:arr isAddStock:self.isAddStock];
    return cell;

}

-(UITableViewCell*)getCellWithTableView:(UITableView*)tableView Title:(NSString *)title{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.textLabel.textColor = [UIColor colorWithRGBHex:0x939b9b];
    cell.backgroundColor = MainColor;
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [self getCellWithTableView:tableView Title:self.currentCityArray.firstObject];
    }else if(indexPath.section == 1)
    {
        return  [self getCellWith:tableView   data:self.hotCityArray];
    }else
    {
        NSArray *array = self.dataArray[indexPath.section - 2 ];
        return [self getCellWithTableView:tableView Title:array[indexPath.row]];
    }
    return nil;
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(_blackView)
    {
        return nil;
    }
    else
    {
        return self.rightIndexArray;
    }

}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //此方法返回的是section的值
   //  NSLog(@"%d",(int)index);
    if(index==0)
    {
        [tableView setContentOffset:CGPointZero animated:YES];
        
        return -1;
    }
    else
    {
        return index+1;
    }
}

#pragma  mark - 选择方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.hotCityArray.count == 5) {
        [self.view showWarning:@"最多能选5个城市"];
        return;
    }
    
    NSString *selectedCity = nil;
    if(indexPath.section == 0){
        selectedCity = self.currentCityArray.firstObject;
    }else if (indexPath.section != 1) {
        selectedCity = self.dataArray[indexPath.section-2][indexPath.row];
    }
    if(selectedCity == nil)
    {
        return;
    }
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:1];
        if (self.isAddStock) {  //单选 直接返回
            [self.hotCityArray removeAllObjects];
            [self.hotCityArray addObject:selectedCity];
            !self.finishSelectCityBlock ?: self.finishSelectCityBlock(self.hotCityArray);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
           
            if (![self.hotCityArray containsObject:selectedCity]) {
                [self.hotCityArray  insertObject:selectedCity atIndex:self.hotCityArray.count];
            }
            self.title = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"SelectedAddress", nil),self.hotCityArray.count];
        }
    [_tableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (self.hotCityArray.count == 0 ) {
        self.title = NSLocalizedString(@"SelectedAddress", nil);
    }

}
#pragma mark --CustomTopViewDelegate
-(void)didSelectBackButton
{
       [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --CustomSearchViewDelegate
-(void)searchString:(NSString *)string
{
    
  // ”^[A-Za-z]+$”
     NSMutableArray *resultArray  =  [NSMutableArray array];
    if([self isZimuWithstring:string])
    {
        //证明输入的是字母
        self.pinYinArray = [NSMutableArray array]; //和输入的拼音首字母相同的地区的拼音
        NSString *upperCaseString2 = string.uppercaseString;
        NSString *firstString = [upperCaseString2 substringToIndex:1];
        NSArray *array = [self.bigDic objectForKey:firstString];
        [array enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL * _Nonnull stop) {
            QTCityModel *model = [[QTCityModel alloc] init];
            NSString *pinYin = [self Charactor:cityName getFirstCharactor:NO];
            model.name = cityName;
            model.pinYinName = pinYin;
            [self.pinYinArray addObject:model];
        }];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"pinYinName BEGINSWITH[c] %@",string];
        NSArray *smallArray = [self.pinYinArray filteredArrayUsingPredicate:pred];
        [smallArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    QTCityModel *model = obj;
                    [resultArray addObject:model.name];
        }];
    }
    else
    {
        //证明输入的是汉字
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *sectionArray  = obj;
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@",string];
            NSArray *array = [sectionArray filteredArrayUsingPredicate:pred];
            [resultArray addObjectsFromArray:array];
            
        }];
    }
    self.resultController.dataArray = resultArray;
    [self.resultController.tableView reloadData];
}
-(void)searchBeginEditing
{
    [self.view addSubview:_blackView];

    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.blackView.alpha = 0.6;
        
    } completion:^(BOOL finished) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view1.tag = 333;
        view1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self.view addSubview:view1];

    }];
    [_tableView reloadData];
}
-(void)didSelectCancelBtn
{
    UIView *view1 = (UIView *)[self.view viewWithTag:333];
    [view1 removeFromSuperview];
    [_blackView removeFromSuperview];
    _blackView = nil;
    [self.resultController.view removeFromSuperview];
    self.resultController=nil;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.searchView.searchBar.text = @"";
        [self.searchView.searchBar  setShowsCancelButton:NO animated:YES];
        [self.searchView.searchBar resignFirstResponder];
    } completion:^(BOOL finished) {
    }];
    
    [_tableView reloadData];
}

#pragma mark --ResultCityControllerDelegate
-(void)didScroll
{
    [self.searchView.searchBar resignFirstResponder];
}

-(void)didSelectedString:(NSString *)string
{
    if (![self.hotCityArray containsObject:string]) {
        [self.hotCityArray  insertObject:string atIndex:self.hotCityArray.count];
    }
    self.title = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"SelectedAddress", nil),self.hotCityArray.count];
    [self didSelectCancelBtn];
}

-(void)loadData
{
    self.rightIndexArray = [NSMutableArray array];
    self.sectionTitlesArray = [NSMutableArray array]; //区头字母数组
    self.dataArray = [NSMutableArray array]; //包含所有区数组的大数组
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.bigDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * allKeys = [self.bigDic allKeys];
    [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
    [self.sectionTitlesArray enumerateObjectsUsingBlock:^(NSString *zimu, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *smallArray = self.bigDic[zimu];
        [self.dataArray addObject:smallArray];
    }];
    [self.rightIndexArray addObjectsFromArray:self.sectionTitlesArray];
    [self.rightIndexArray insertObject:UITableViewIndexSearch atIndex:0];
    [self.sectionTitlesArray insertObject:NSLocalizedString(@"SelectedCity", nil) atIndex:0];
    [self.sectionTitlesArray insertObject:NSLocalizedString(@"CurrentLocation", nil) atIndex:0];
    
    NSString *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"kCurrentCityName"];
    if (currentCity.length != 0) {
         self.currentCityArray = @[currentCity];
    }else{
        self.currentCityArray = @[@"广州"];
    }
    
    if (self.hotCityArray.count == 0 ) {
        self.title = NSLocalizedString(@"SelectedAddress", nil);
    }else{
     self.title = [NSString stringWithFormat:@"%@(%ld)",NSLocalizedString(@"SelectedAddress", nil),self.hotCityArray.count];
    }
}

- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}
-(BOOL)isZimuWithstring:(NSString *)string
{
    NSString* number=@"^[A-Za-z]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return  [numberPre evaluateWithObject:string];
}
@end
