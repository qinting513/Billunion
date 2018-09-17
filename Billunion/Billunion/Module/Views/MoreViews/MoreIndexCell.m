//
//  MoreIndexCell.m
//  Billunion
//
//  Created by QT on 17/1/4.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreIndexCell.h"


@interface MoreIndexCell()

/**  平均值 */
@property (nonatomic,strong)UILabel *avgLabel;
/** 名字 */
@property (nonatomic,strong)UILabel *nameLabel;
/**  上涨点 */
@property (nonatomic,strong)UILabel *upLabel;
/** 下降点 */
@property (nonatomic,strong)UILabel *downLabel;

@end

@implementation MoreIndexCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRGBHex:0x161616];
        UIView *superView = [[UIView alloc]init];
        [self.contentView addSubview:superView];
      
        CGFloat font = IsIphone5 ? 11 : 14;
        /** create */
        self.avgLabel = [UILabel labelWithText:nil fontSize:28.5f textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [superView addSubview:self.avgLabel];
        
        self.nameLabel = [UILabel labelWithText:@"政策银行" fontSize:font textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [superView addSubview:self.nameLabel];
        
        self.upLabel = [UILabel labelWithText:@"+1.98" fontSize:font textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [superView addSubview:self.upLabel];
        
        self.downLabel = [UILabel labelWithText:@"-0.08%" fontSize:font textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [superView addSubview:self.downLabel];
        
        /** layout */
        CGFloat topHreight = (frame.size.height-28.5-15-12-12-12)/2;
        CGFloat leftSpace  = STRealX(30);
        superView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(topHreight, leftSpace, topHreight, leftSpace));
        
        self.avgLabel.sd_layout.topSpaceToView(superView,0).leftSpaceToView(superView,0).widthIs(frame.size.width).heightIs(28.5);
        
        self.nameLabel.sd_layout.topSpaceToView(self.avgLabel,15).leftEqualToView(self.avgLabel).widthIs(self.avgLabel.width).heightIs(12);
        
        self.upLabel.sd_layout.topSpaceToView(self.nameLabel,7.5).leftSpaceToView(superView,0).widthIs( (frame.size.width - leftSpace*2)*0.5).heightIs(12);
        //        self.upLabel.backgroundColor = [UIColor blueColor];
        
        self.downLabel.sd_layout.centerYEqualToView(self.upLabel).leftSpaceToView(self.upLabel,0).widthIs((frame.size.width - leftSpace*2)*0.5).heightIs(12);

    }
    return self;
}



-(void)setModel:(MoreIndexModel *)model
{
    _model = model;
    self.avgLabel.text = [NSString stringWithFormat:@"%.2f %%",model.Rate.floatValue];
    
    if (model.BillType.integerValue != 3) {
          self.nameLabel.text = [Tools getAcceptor1:model.AcceptorType.integerValue];
    }else{
         self.nameLabel.text = [Tools getAcceptor2:model.AcceptorType.integerValue];
    }
  

    if (model.Bp.floatValue >= 0) {
        self.upLabel.text = [NSString stringWithFormat:@"+%.2f",model.Bp.floatValue];
    }else{
        self.upLabel.text = [NSString stringWithFormat:@"%.2f",model.Bp.floatValue];
    }

    if (model.Percent.floatValue > 0) {
        self.downLabel.text = [NSString stringWithFormat:@"+%.2f%%",model.Percent.floatValue];
    }else{
        self.downLabel.text = [NSString stringWithFormat:@"%.2f%%",model.Percent.floatValue];
    }
    
    NSRange range = [self.avgLabel.text rangeOfString:@"%"];
    NSMutableAttributedString *numText=[[NSMutableAttributedString alloc]initWithString:self.avgLabel.text attributes:nil];
    [numText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    self.avgLabel.attributedText = numText;
}

@end
