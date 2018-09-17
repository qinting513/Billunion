//
//  MoreNoticeCell.m
//  Billunion
//
//  Created by Waki on 2017/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreNoticeCell.h"
#import "NoticeModel.h"
#import "TradeNewsModel.h"

@interface MoreNoticeCell ()
{
    UILabel *_contentLabel;
    UILabel *_timeLabel;
}

@end
@implementation MoreNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *superView = self.contentView;
    _contentLabel = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [superView addSubview:_contentLabel];
    
    _timeLabel = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentRight];
    [superView addSubview:_timeLabel];
    
    _contentLabel.sd_layout.leftSpaceToView(superView,STRealX(34)).rightSpaceToView(superView,STRealX(34)).topSpaceToView(superView,STRealY(30)).autoHeightRatio(0);

    _timeLabel.sd_layout.rightSpaceToView(superView,STRealX(34)).bottomSpaceToView(superView,STRealY(30)).widthIs(200).heightIs(13);
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:30];
}

- (void)setCellInfo:(NSString *)content time:(NSString *)time{
    _contentLabel.text = content;
    _timeLabel.text = time;
}

- (void)setModel:(id)model{
    if ([model isKindOfClass:[NoticeModel class]]) {
        _contentLabel.text =   ((NoticeModel *)model).Title;
        _timeLabel.text = ((NoticeModel *)model).CreateTime;
//        NSTimeInterval interval = [((NoticeModel *)model).createTime integerValue];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yyyy-MM-dd";
//        //1000是精确到毫秒
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval/1000];
//        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//        _timeLabel.text = confromTimespStr;
    }else if ([model isKindOfClass:[TradeNewsModel class]]){
        _contentLabel.text =   ((TradeNewsModel *)model).Title;
        _timeLabel.text = ((TradeNewsModel *)model).CreateTime;
    }
}

@end
