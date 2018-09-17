

//
//  BaseViewController.m
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//


#define KScreenheight [UIScreen mainScreen].bounds.size.height
#define IsIphone5 KScreenSize.height==568

#ifdef IsIphone5
     #define btnSpace  10
#else
     #define btnSpace  30
#endif

#define bottomViewHeight 2
#define buttonTag 191000
#define baseTag  190000
#define selectViewBaseTag 1000
#define buttonBaseTag  100
#define StockViewBaseTag  (10 + baseTag)
#define bottomViewBaseTag  390

#define selectViewHeight STRealX(80)

#import "BaseViewController.h"
#import "AskBuyTableView.h"
#import "StockView.h"
#import "UIDevice+DeviceModel.h"
#import "BaseNavViewController.h"
#import "LoginViewController.h"
#import "TabbarController.h"

@interface BaseViewController ()<UIScrollViewDelegate>
{
    CGFloat  _btnWidth;
    NSArray *_titles;
    UISegmentedControl *_segment;
    UIScrollView *_mainScrollView;
}

@property (nonatomic,strong) UIButton *bakcButton;


@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}

- (void)setupBakcButton{
    _bakcButton = [UIButton buttonWithNormalImage:@"back" selectImage:@"bakc_pr" imageType:btnImgTypeSmall target:self action:@selector(backClick)];
    _bakcButton.frame = CGRectMake(0, 0, 50, 30);
    _bakcButton.contentEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
//    _bakcButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_bakcButton];
    self.navigationItem.leftBarButtonItem = item;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        [self.tabBarController.tabBar setHidden:YES];
    }else{
        [self.tabBarController.tabBar setHidden:NO];
    }
}

- (void)backClick{
    [Hud hide];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutMainSelectViweWithTitles:(NSArray *)titles{
    if (titles.count>1) {
        _segment = [[UISegmentedControl alloc] initWithItems:titles];
        //_segment.frame = CGRectMake(0, 0, 100, 30);
        [_segment sizeToFit];
        _segment.tintColor = [UIColor colorWithRGBHex:0x93a6be];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(stockSelect:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = _segment;
  
    }else{
        self.title = titles[0];
    }
    
    
    //配置scrollView
   
    if (self.stockType == stock_buying || self.stockType == stock_sell) {
         _mainScrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, WIDTH,HEIGHT-64 - 49)];
    }else{
       _mainScrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, WIDTH,HEIGHT-64)];
    }
    
    _mainScrollView.contentSize = CGSizeMake(WIDTH*titles.count, 0);
    _mainScrollView.delegate  = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
}

- (void)layoutSelectViweWithTitles:(NSArray *)titles{
      for (int i = 0; i < _mainScrollView.contentSize.width/WIDTH; i++) {
    
        _titles = titles;
        UIView * tradingWaySelectView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, selectViewHeight)];
        tradingWaySelectView.backgroundColor = [UIColor colorWithRGBHex:0x141414];
          
          //tradingWaySelectView 的tag设置 （重要）
        tradingWaySelectView.tag = selectViewBaseTag *(i+1);
          
        _btnWidth = (WIDTH-btnSpace*(titles.count+1))/titles.count;
        for (int j = 0; j < titles.count; j++) {
            UIButton *button = [UIButton buttonWithTitle:titles[j] titleFont:12 titleColor:[UIColor colorWithRGBHex:0x93a6be] target:self action:@selector(tradingWaySelected:)];
            button.frame = CGRectMake(btnSpace+(_btnWidth+btnSpace)*j, 0, _btnWidth, selectViewHeight);
            button.tag =  selectViewBaseTag*i+buttonBaseTag*j;
            [tradingWaySelectView addSubview:button];
            if (j == 0) {
              UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(btnSpace, selectViewHeight-bottomViewHeight,_btnWidth, bottomViewHeight)];
                bottomView.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                [tradingWaySelectView addSubview:bottomView];
                
                bottomView.tag = bottomViewBaseTag;
            }
        }
        [_mainScrollView addSubview:tradingWaySelectView];
    }
}


- (void)tradingWaySelected:(UIButton *)btn{
    if (self.stockType ==  stock_trading) {
        [self.view endEditing:YES];
    }
    
    static NSInteger butBaseTag = buttonBaseTag;
    NSInteger lastBtnTag = selectViewBaseTag*_mainScrollView.contentOffset.x/WIDTH+butBaseTag;

    UIButton * button = (UIButton *)[self getCurrentButton:lastBtnTag];
    button.selected = NO;
    btn.selected = YES;
    butBaseTag = btn.tag%1000;
    NSInteger index = btn.tag%1000/100;
    
    UIView *bottomView =  [self getCurrentBottomView:btn.tag];
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(btnSpace+(_btnWidth+btnSpace)*index, btn.height-bottomViewHeight,_btnWidth, bottomViewHeight);
    }];
  
   // 点击button scrollView开始滚动
    UIScrollView *scrollView = [self getCurrentSrollView];
    if (scrollView) {
        [scrollView setContentOffset:CGPointMake(WIDTH*index, 0) animated:YES];
    }
    [self addRightBarButtonItem:index];
}

  /** 右上角的 票据添加 或选择 按钮  让子类重写*/
-(void)addRightBarButtonItem:(NSInteger)index{
}

- (void)layoutScrollViewWithSubTitles:(NSArray *)subTitles{
//    NSLog(@"_mainScrollView.contentSize.width/WIDTH:%f",_mainScrollView.contentSize.width/WIDTH);
    for (int i = 0; i < _mainScrollView.contentSize.width/WIDTH; i++) {
        //配置scrollView
        
        CGRect scrollViewRect;
        if ([[subTitles lastObject] count] == 1) {
            //StockViewController 的页面没有上面的选择栏，所以Y从0开始
           scrollViewRect = CGRectMake(WIDTH*i,0, WIDTH,_mainScrollView.height);
        }else{
           scrollViewRect = CGRectMake(WIDTH*i,selectViewHeight+4, WIDTH,_mainScrollView.height-selectViewHeight-4);
        }

       UIScrollView * scrollView =  [[UIScrollView alloc] initWithFrame:scrollViewRect];
        scrollView.contentSize = CGSizeMake(WIDTH*_titles.count, CGRectGetHeight(scrollView.frame));
        scrollView.delegate  = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollEnabled = NO;
        scrollView.tag = baseTag+i;
            [_mainScrollView addSubview:scrollView];
        
        [self layoutTableView:subTitles[i] superView:scrollView];
    }
}

- (void)layoutTableView:(NSArray *)subTitles superView:(UIView *)superView{
    for (int i = 0; i < _titles.count; i++) {
        if (self.stockType == stock_trading && (i == 0 || i == 2)) {
            BUYING_TYPE type = AskBuying;
            if (i == 2) {
                type = SpecifiedBuying;
            }
            AskBuyTableView *askTableView = [[AskBuyTableView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH,superView.height) style:UITableViewStyleGrouped];
            askTableView.buyType = type;
            [superView addSubview:askTableView];
            askTableView.tag = 10*i+StockViewBaseTag;
        }else{
            int j = 0;
            if (self.stockType == stock_trading) {
                if (i == 1) {
                    j = 0;
                }else if (i == 3){
                    j = 1;
                }
            }else{
                j = i;
            }
            TransactionType type = TransactionType_SelectAll;
            StockView *stockView = [[StockView alloc] initWithFrame:CGRectMake(WIDTH*i, 0,WIDTH, superView.height) withTransactionType:type titles:subTitles[j]];
           stockView.tag = 10*i+StockViewBaseTag;
            [stockView addHeaderRefresh];
            [stockView addFooterRefresh];
            [superView addSubview:stockView];
        }
        
    }
}

- (UIScrollView *)getCurrentSrollView{
    UIView *view = [_mainScrollView viewWithTag:baseTag+_mainScrollView.contentOffset.x/WIDTH];
    return (UIScrollView *)view;
}

- (UIView *)getCurrentSelectView{
    UIView *view = [_mainScrollView viewWithTag:selectViewBaseTag*(_mainScrollView.contentOffset.x/WIDTH+1)];
   // NSLog(@"getCurrentSelectViewTag:%ld",);
    return view;
}

- (UIView *)getCurrentBottomView:(NSInteger)tag{
   UIView *selectView = [self getCurrentSelectView];
    return [selectView viewWithTag:bottomViewBaseTag];
}

- (UIView *)getCurrentButton:(NSInteger)tag{
    UIView *selectView =  [self getCurrentSelectView];
    UIView *view = [selectView viewWithTag:tag];
    return view;
}

- (UIView *)getCurrentStockView{
    UIScrollView *scrollView =  [self getCurrentSrollView];
    return [scrollView viewWithTag:StockViewBaseTag+10*scrollView.contentOffset.x/WIDTH];
}

- (UIView *)getStockViewWithIndex:(NSInteger)index{
    UIView *view = [[self getCurrentSrollView] viewWithTag:StockViewBaseTag+index*10];
    return view;
}


- (void)stockSelect:(UISegmentedControl *)seg{
    [_mainScrollView setContentOffset:CGPointMake(WIDTH*seg.selectedSegmentIndex,0) animated:YES];
    self.segmentSelectIndex = seg.selectedSegmentIndex;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        [self mainSelectedWithPage:_mainScrollView.contentOffset.x/WIDTH];
    }else{
        [self subSelectedWithPage:scrollView.contentOffset.x/WIDTH];
    }
}

- (void)mainSelectedWithPage:(NSInteger)page{};

- (void)subSelectedWithPage:(NSInteger)page{};


-(void)loginWithLoginOkBlock:(void(^)())loginOkBlock{
    LoginViewController *vc = [[LoginViewController alloc]init];
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
    
    vc.isVistorPresent = YES;
    __weak LoginViewController *weakVc = vc;
    vc.loginSuccessBlock = ^{
        [weakVc dismissViewControllerAnimated:NO completion:^{
            !loginOkBlock ?: loginOkBlock(); //点击登录 登录成功 可以加载当前控制器的数据
        }];
    };
    
    vc.dismissBlock = ^{
        [weakVc dismissViewControllerAnimated:NO completion:^{
            // 点击dismiss按钮 退出 并选择首页来显示
            if ([self.tabBarController isKindOfClass:[TabbarController class]] ) {
                TabbarController *tab = (TabbarController *)self.tabBarController;
                tab.selectedIndex = 0;
            }
        }];
    };
    
    [self  presentViewController:nav animated:YES completion:nil];
}


@end
