//
//  NewsDetailViewController.m
//  Billunion
//
//  Created by Waki on 2017/3/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "HomeViewModel.h"
#import "NoticeModel.h"

@interface NewsDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    [self setupBakcButton];
    [self requestData];
}

- (void)requestData{
    [Hud showActivityIndicator];
    __weak typeof(self) weakSelf = self;
   [HomeViewModel requestNoticeDetailWithId:[HomeViewModel getNewsId:self.model]
                                 noticeType:NoticeTypeNews
                                   response:^(id model, NSString *errorStr) {
        if (!errorStr) {
            [weakSelf layoutWebViweWithUrlStr:model];
        }else{
            [Hud hide];
            [Hud showTipsText:errorStr];
        }
    }];
}

- (void)layoutWebViweWithUrlStr:(id)model{
    if ([model isKindOfClass:[NoticeModel class]]) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _webView.delegate = self;
        _webView.opaque=NO;
        _webView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_webView];
        NoticeModel *mm = model;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:mm.Content]];
        DEBUGLOG(@"URL:%@",mm.Content);
//         NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        [_webView loadRequest:request];
    }
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
     [Hud hide];
}



@end
