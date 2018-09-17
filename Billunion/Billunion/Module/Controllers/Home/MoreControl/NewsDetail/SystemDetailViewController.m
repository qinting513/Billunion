//
//  SystemDetailViewController.m
//  Billunion
//
//  Created by QT on 17/3/2.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "SystemDetailViewController.h"
#import "HomeViewModel.h"
#import "NoticeModel.h"

#define kLeftMargin 15
#define kTopMargin 10

@interface SystemDetailViewController ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView  *separatorView;
@property (nonatomic,strong)UILabel *sourceLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *contentLabel;

@end

@implementation SystemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = @"系统公告";
    [self loadData];
    [self setupUI];
}

-(void)loadData{
    __weak typeof(self) weakSelf = self;
    [HomeViewModel requestNoticeDetailWithId:[HomeViewModel getNewsId:self.model]
                                  noticeType:NoticeTypeSystem
                                    response:^(id model, NSString *errorStr) {
                if (!errorStr) {
                    [weakSelf layoutUI:model];
                }else{
                    [Hud showTipsText:errorStr];
                }
        }];
}

-(void)setupUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT);
    [self.view addSubview:self.scrollView];
    
    self.titleLabel = [UILabel labelWithText:@"标题" fontSize:16
                                   textColor:[UIColor colorWithRGBHex:0xbdd4f1]
                                   alignment:NSTextAlignmentCenter];
    self.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.titleLabel];
    
    self.separatorView = [[UIView alloc]init];
    self.separatorView.backgroundColor = [UIColor colorWithRGBHex:0x363b41];
    [self.scrollView addSubview:self.separatorView];

    self.sourceLabel = [UILabel labelWithText:@"来源:" fontSize:12
                                   textColor:[UIColor colorWithRGBHex:0x666666]
                                   alignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:self.sourceLabel];
    
    self.timeLabel = [UILabel labelWithText:@"时间" fontSize:12
                                    textColor:[UIColor colorWithRGBHex:0x666666]
                                    alignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:self.timeLabel];
    
    self.contentLabel = [UILabel labelWithText:@"" fontSize:14
                                  textColor:[UIColor colorWithRGBHex:0x93a6be]
                                  alignment:NSTextAlignmentLeft];
    self.contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.contentLabel];
}

-(void)layoutUI:(id)model{
    if (![model isKindOfClass:[NoticeModel class]]) {
        return;
    }
    NoticeModel *noticeModel = (NoticeModel *)model;
    self.titleLabel.text = noticeModel.Title;
    if (noticeModel.source) {
          self.sourceLabel.text = [NSString stringWithFormat:@"来源:%@",noticeModel.source];
    }
    self.timeLabel.text = noticeModel.CreateTime;
    self.contentLabel.text = noticeModel.Content;
    
    
    CGFloat titleHeight = [self.titleLabel.text getHeightWithLimitWidth:(WIDTH - 30 * 2) fontSize:16];
    self.titleLabel.sd_layout.topSpaceToView(self.scrollView,kTopMargin).leftSpaceToView(self.scrollView,30).rightSpaceToView(self.scrollView,30).heightIs(titleHeight);
    self.separatorView.sd_layout.topSpaceToView(self.titleLabel,kTopMargin).leftSpaceToView(self.scrollView,kLeftMargin).rightSpaceToView(self.scrollView,kLeftMargin).heightIs(2);
    
    CGFloat sWidth = [self.sourceLabel.text getWidthWithLimitHeight:20 fontSize:12];
    self.sourceLabel.sd_layout.topSpaceToView(self.separatorView,kTopMargin).leftSpaceToView(self.scrollView,kLeftMargin).widthIs(sWidth).heightIs(20);
    self.timeLabel.sd_layout.topSpaceToView(self.separatorView,kTopMargin).leftSpaceToView(self.sourceLabel,kLeftMargin).widthIs(WIDTH - sWidth).heightIs(20);
    
    CGFloat cHeight = [self.contentLabel.text getHeightWithLimitWidth:(WIDTH - kLeftMargin*2) fontSize:14];
    self.contentLabel.sd_layout.topSpaceToView(self.sourceLabel,kTopMargin).leftSpaceToView(self.scrollView,kLeftMargin).rightSpaceToView(self.scrollView,kLeftMargin).heightIs(cHeight);
    
    CGFloat height =  titleHeight + kTopMargin*5 + self.sourceLabel.height + cHeight + 100;
    self.scrollView.contentSize = CGSizeMake(WIDTH, height);
}


@end
