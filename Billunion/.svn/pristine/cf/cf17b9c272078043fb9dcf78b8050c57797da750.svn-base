//
//  StockView.h
//  Billunion
//
//  Created by QT on 17/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockViewProtocol.h"


@protocol StockViewProtocol;
@interface StockView : UIView

/** 左边tableView */
@property(nonatomic,strong) UITableView*  leftTableView;
/** 右边tableView */
@property(nonatomic,strong) UITableView*  subsTablView;

//挑票选择的判断类型
@property (nonatomic,assign) TransactionType transactionType;
/** stockView的数据数组 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/** stockView的筛选条件 */
@property (nonatomic,strong)NSMutableDictionary *filterDict;
/** 记录数据页数 */
@property (nonatomic,assign)NSInteger numPage;
/** 选择了哪一行 就添加到这个数组里 */
@property (nonatomic,strong)NSMutableArray *selectBtnArray;
/** 首页-> 票据交易 右按钮 是否选中 */
@property (nonatomic,assign) BOOL rightBtnIsSelected;

@property (nonatomic,assign) id<StockViewProtocol> delegate;


-(instancetype)initWithFrame:(CGRect)frame withTransactionType:(TransactionType)transactionType titles:(NSArray *)titles;

- (void)tableViewReloadData;
-(void)endRefresh;

- (void)addHeaderRefresh;
- (void)addFooterRefresh;


#pragma mark - 对网络请求后的处理
-(void)handleResponseWithDataArray:(NSArray *)dataArr errorStr:(NSString *)errorStr isPullUp:(BOOL)isPullUp;
@end
