
//
//  KLineCell.m
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//


#define Space 8

#import "KLineCell.h"
#import "KLineView.h"

@interface KLineCell ()<UIScrollViewDelegate,KlineViewDelegate>
{
    CGFloat _cellHeight;
}

@property (strong,nonatomic) KLineView *klineView;

@end
@implementation KLineCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizesSubviews = NO;
        _cellHeight = cellHeight;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        KlineModel *model = self.dataArray[i];

        [xArray addObject:model.timeDate];
        [yArray addObject:model.percent];
    }
    _klineView = [[KLineView alloc] initWithFrame:CGRectMake(Space, Space, WIDTH-Space*2, _cellHeight-Space*2) xTitleArray:xArray yValueArray:yArray yMax:10 yMin:0];
    _klineView.delegate = self;
    [self.contentView addSubview:_klineView];
}

- (void)setDataArray:(NSArray *)dataArray{
//    if (dataArray.count ==  0) {
//         dataArray = [KlineModel getDatas];
//    }
    
    _dataArray = dataArray;
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        KlineModel *model = dataArray[i];
        [xArray addObject:model.timeDate];
        [yArray addObject:model.percent];
    }
    _klineView.dataArray = @[xArray,yArray];
}

- (void)klineViewSelect:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(klineViewTypeSelect:)]) {
        [self.delegate klineViewTypeSelect:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
