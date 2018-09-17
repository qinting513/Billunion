//
//  HomeNoticeCell.m
//  Billunion
//
//  Created by Waki on 2016/12/30.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "HomeNoticeCell.h"
#import "NoticeModel.h"

@interface HomeNoticeCell ()
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
}

@end
@implementation HomeNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    _contentLabel = [UILabel labelWithText:nil fontSize:13 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [superView addSubview:_contentLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SeparatorColor;
    [superView addSubview:lineView];
    
    _contentLabel.sd_layout.leftSpaceToView(superView,STRealX(34)).rightSpaceToView(superView,STRealX(34)).centerYEqualToView(superView).heightIs(superView.height);
    
    lineView.sd_layout.topEqualToView(superView).leftSpaceToView(superView,STRealX(34)).rightEqualToView(superView).heightIs(0.5);
    
}

- (void)setCellInfo:(id)noticeModel{
    if ([noticeModel isKindOfClass:[NoticeModel class]]) {
        _contentLabel.text  =  ((NoticeModel *)noticeModel).Title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
