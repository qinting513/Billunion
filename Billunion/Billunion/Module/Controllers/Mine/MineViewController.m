//
//  MineViewController.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "QuestionViewController.h"
#import "AboutUsViewController.h"
#import "MyProfileViewController.h"
#import "LoginViewModel.h"
#import "LoginViewController.h"
#import "MoreNoticeViewController.h"
#import "BaseNavViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *titles;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title =  NSLocalizedString(@"Me", nil);
    self.tableView.hidden = NO;
    
//    [self layoutLoginOut];
}

-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = [Tools getMineTitles];
    }
    return _titles;
}
-(NSArray *)images
{
    if (!_images) {
        _images = @[@"icons_message",@"icons_about",@"icons_feekback",@"icons_update",@"icons_inform"];
    }
    return _images;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
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
    static NSString *cellID = @"MineCell";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            {
                vc = [[MyProfileViewController alloc]init];
                break;
            }
        case 1:
            {
                vc = [[AboutUsViewController alloc]init];
                 break;
            }
        case 2:
            {
               vc = [[QuestionViewController alloc]init];
               break;
            }
           
        case 3:
            {
                NSString *link = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewMultiRoom?cc=cn&fcId=1128984224&mt=8";
                [self checkVersionWithLink:link];
            }
            
            break;
        case 4:
        {
          MoreNoticeViewController *  viewController = [[MoreNoticeViewController alloc]init];
          viewController.noticeType = NoticeTypeSystem;
          vc = viewController;
        }
            break;
        default:
           break;
    }
     [self.navigationController pushViewController:vc animated:YES];
}

-(void)checkVersionWithLink:(NSString *)link{
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:link]
                                                encoding:NSUTF8StringEncoding error:nil];
    if (string != nil && string.length > 0 ) {
        [self checkAppUpdate:string link:link];
    }
}

-(void)checkAppUpdate:(NSString *)appInfo link:(NSString *)link{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString *appStoreVersion = [appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location + 10];
//    appStoreVersion = [[appStoreVersion substringToIndex:[appStoreVersion rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *appStoreVersion = @"1.0.2";
    if (![version isEqualToString:appStoreVersion]) {
        NSLog(@"%@ -- %@",appStoreVersion,version);
        [UIAlertController alertControllerWithTitle:@"提示"
                                            message:@"您当前版本不是最新版本,是否前往更新？"
                                            okTitle:@"确定"
                                        cancelTtile:@"取消"
                                             target:self
                                         clickBlock:^(BOOL ok, BOOL cancel) {
                                             if (ok) {
                 NSURL *url = [NSURL URLWithString:link];
             if ([[UIApplication sharedApplication] canOpenURL:url]) {
                 [[UIApplication sharedApplication] openURL:url];
                 }
                                             }
                                         }];
    }else{
       [Hud showTipsText:@"该版本已是最新版本"];
    }

}

- (void)chanegRootViewControllerWithStatus:(NSInteger)loginOutStatus{
    if (loginOutStatus == 0) {
        [Tools saveUserLoginStatus:@"NO"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[BaseNavViewController alloc]initWithRootViewController:[LoginViewController new]];
    }
}



@end
