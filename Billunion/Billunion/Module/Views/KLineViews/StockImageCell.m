


//
//  StockImageCell.m
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockImageCell.h"

@interface StockImageCell (){
    UIImageView *_positiveImgView;
    UIImageView *_reverseImgView;

}

@end
@implementation StockImageCell

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
    //正面
    _positiveImgView  = [[UIImageView alloc] init];
    [superView addSubview:_positiveImgView];
    //反面
    _reverseImgView  = [[UIImageView alloc] init];
    [superView addSubview:_reverseImgView];
    
    _positiveImgView.sd_layout.leftEqualToView(superView).topEqualToView(superView).bottomEqualToView(superView).widthIs((WIDTH-4)/2);
    _reverseImgView.sd_layout.rightEqualToView(superView).topEqualToView(superView).bottomEqualToView(superView).widthIs((WIDTH-4)/2);
}


- (void)setCellInfo:(NSArray *)imgArray{
    [_positiveImgView sd_setImageWithURL:[NSURL URLWithString:imgArray.firstObject]];
    [_reverseImgView sd_setImageWithURL:[NSURL URLWithString:imgArray.lastObject]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
