
//
//  MoreNoticeViewController.m
//  Billunion
//
//  Created by Waki on 2017/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreNoticeViewController.h"
#import "MoreNoticeCell.h"
#import "HomeViewModel.h"
#import "TradeNewsModel.h"

#import "YYRrefreshControl.h"
#import "YYRefreshFooterView.h"
#import "NewsDetailViewController.h"
#import "SystemDetailViewController.h"



@interface MoreNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *noticeArray;

@property (nonatomic,strong)  YYRrefreshControl *headerRefresh;
@property (nonatomic,strong)  YYRefreshFooterView *footerRefresh;
@property (nonatomic,assign)  NSInteger numPage;

@end

@implementation MoreNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setupBakcButton];
    [self layoutTableView];
    self.numPage = 1;
  
    if (self.noticeType == NoticeTypeTrade) {
        self.title =  NSLocalizedString(@"SystemInform", nil) ;
        [self ifGoToSettingNotification];
        NSArray *datas = [TradeNewsModel findAll];
        self.noticeArray = [NSMutableArray arrayWithArray:[[datas reverseObjectEnumerator] allObjects]];
        [self.tableView reloadData];
    }else{
        self.title = (self.noticeType == NoticeTypeSystem) ?
                                            NSLocalizedString(@"SystemNotice", nil) :
                                            NSLocalizedString(@"Abstract", nil) ;
        [self requestNoticeWithPage:1 isPullUp:NO];
        _headerRefresh = [[YYRrefreshControl alloc] init];
        [_headerRefresh addTarget:self action:@selector(headerRefresh:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_headerRefresh];
        
        _footerRefresh = [[YYRefreshFooterView alloc]init];
        [_footerRefresh addTarget:self action:@selector(footerRefresh:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_footerRefresh];
    }
}


-(void)ifGoToSettingNotification{
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [UIAlertController alertControllerWithTitle:@"温馨提示"
                                            message:@"请打开系统通知,以便接收交易信息"
                                            okTitle:@"确定"
                                        cancelTtile:@"取消"
                                             target:self
                                         clickBlock:^(BOOL ok, BOOL cancel) {
            if (ok) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
            }
        }];
        
    }
}



// 接收通知监听的方法
- (void)headerRefresh:(YYRrefreshControl*)refreshControl{
     [self requestNoticeWithPage:1 isPullUp:NO];
}

-(void)footerRefresh:(YYRefreshFooterView*)footerView
{
     self.numPage ++;
     [self requestNoticeWithPage:self.numPage isPullUp:YES];
}

- (void)requestNoticeWithPage:(NSInteger)page isPullUp:(BOOL)isPullUp{
   
        __weak typeof(self) weakSelf = self;
        [HomeViewModel requestNoticeWithPage:page itemNum:20  noticeType:self.noticeType response:^(NSArray *dataArray, NSString *errorStr) {
                [weakSelf.headerRefresh endRefreshing];
                [weakSelf.footerRefresh endRefreshing];
            if (errorStr) {
                 weakSelf.numPage --;
                [Hud showTipsText:errorStr];
            }else{
                if (dataArray.count == 0) {
                    weakSelf.numPage --;
                    [Hud showTipsText:NSLocalizedString(@"NO_MORE_DATA", nil)];
                
//                    return;
                }
                
                if (!isPullUp) {
                    weakSelf.numPage = 1;
                    [weakSelf.noticeArray removeAllObjects];
                }
                [weakSelf.noticeArray addObjectsFromArray:dataArray];
                [weakSelf.tableView reloadData];
            }
        }];
}


- (void)layoutTableView{
    _noticeArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorColor = SeparatorColor ;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _noticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreNoticeCell"];
    if (!cell) {
        cell = [[MoreNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreNoticeCell"];
    }
    cell.backgroundColor = MainColor;
    cell.contentView.backgroundColor = MainColor;
    
    cell.model = _noticeArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.noticeType == NoticeTypeNews){
        //选择消息，跳转到web页面
        NewsDetailViewController *newsCtl = [[NewsDetailViewController alloc] init];
        newsCtl.model = _noticeArray[indexPath.row];
        [self.navigationController pushViewController:newsCtl animated:YES];
    }else  if(self.noticeType == NoticeTypeSystem){
        // 从系统公告跳转的
        SystemDetailViewController *vc = [[SystemDetailViewController alloc]init];
        vc.model = _noticeArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:_noticeArray[indexPath.row] keyPath:@"model" cellClass:[MoreNoticeCell class] contentViewWidth:WIDTH];
}

-(void)dealloc
{
    if (_headerRefresh) {
        [_headerRefresh removeFromSuperview];
        [_footerRefresh removeFromSuperview];
    }
}

@end
