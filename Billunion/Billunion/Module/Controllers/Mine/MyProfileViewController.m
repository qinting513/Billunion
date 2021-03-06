//
//  MyProfileViewController.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileCell.h"
#import "LoginViewController.h"
#import "MineViewModel.h"
#import "LoginViewModel.h"
#import "BaseNavViewController.h"

#define kFooterViewHeight 80

@interface MyProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIButton *logoutBtn;
@property (nonatomic,strong)MineViewModel *mineViewModel;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = NSLocalizedString(@"UserCenter", nil);
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self logoutBtn];
    [self loadData];
}

- (MineViewModel *)mineViewModel{
    if (!_mineViewModel) {
        _mineViewModel = [[MineViewModel alloc] init];
    }
    return _mineViewModel;
}

-(void)loadData{
    __weak typeof(self) weakSelf = self;
  [self.mineViewModel  requestDataResponse:^(NSArray *dataArray, NSString *errorStr) {
      if (errorStr == nil) {
         [weakSelf.tableView reloadData];
      }else{
          [Hud showTipsText:errorStr];
      }
  }];
}

-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = [Tools getMyProfileTitles];
    }
    return _titles;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, kFooterViewHeight)];
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.rowHeight = 48;
        _tableView.separatorColor = SeparatorColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 15)];
        _headerView.backgroundColor = [UIColor blackColor];
    }
    return _headerView;
}


-(UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor blackColor];
        _footerView.frame = CGRectMake(0, 0, WIDTH, kFooterViewHeight);
    }
    return _footerView;
}

-(UIButton *)logoutBtn
{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:0];
        [self.footerView addSubview:_logoutBtn];
        [_logoutBtn setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _logoutBtn.backgroundColor = [UIColor colorWithRGBHex:0x1c4473];
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 3;
        _logoutBtn.frame = CGRectMake(20, 20, WIDTH-40, 40);

        [_logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

-(void)logoutBtnClick
{
  
        __weak typeof(self) weakSelf = self;
    [LoginViewModel loginOutResponse:^(NSInteger loginOutStatus) {
        if (loginOutStatus != 0) {
            [weakSelf.view showWarning: NSLocalizedString(@"LogoutFail", nil)];
        }else{
            [weakSelf.view showWarning:NSLocalizedString(@"LogoutSuccess", nil) afterDelay:0.5 completionBlock:^{
                [weakSelf chanegRootViewControllerWithStatus:loginOutStatus];
            }];
        }
    }];
}

- (void)chanegRootViewControllerWithStatus:(NSInteger)loginOutStatus{
    if (loginOutStatus == 0) {
        // [Tools saveUserEverLoginStatus:@"NO"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
    }
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.mineViewModel.numberOfRows;
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyProfileCell";
    MyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MyProfileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.contentLabel.text = [self.mineViewModel getDataWithIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
