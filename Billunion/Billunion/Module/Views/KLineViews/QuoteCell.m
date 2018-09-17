



//
//  QuoteCell.m
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "QuoteCell.h"

#define kTopMargin 10
#define kLabelHeight 20

@interface QuoteCell ()

@property (nonatomic,strong)UIView *seperatorView;

@end

@implementation QuoteCell

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
    self.quoteLabel = [UILabel labelWithText:@"报价方:普惠创新金融信息服务有限公司" fontSize:13.0 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [superView addSubview:self.quoteLabel];
    
    self.rateLabel = [UILabel labelWithText:@"卖01:2.09%" fontSize:13.0 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [superView addSubview:self.rateLabel];
    
    self.moneyLabel = [UILabel labelWithText:@"金额(万):000.00" fontSize:13.0 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [self.moneyLabel sizeToFit];
    [superView addSubview:self.moneyLabel];
    
    self.tradeModeLabel = [UILabel labelWithText:@"成交类型:挑票成交" fontSize:13.0 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [superView addSubview:self.tradeModeLabel];
    
    /** 分割线 */
    self.seperatorView = [[UIView alloc]init];
    [superView addSubview:self.seperatorView];
    self.seperatorView.sd_layout.leftEqualToView(superView).rightEqualToView(superView).bottomEqualToView(superView).heightIs(0.5);
    self.seperatorView.backgroundColor = SeparatorColor;
  
}

-(void)layoutUI{
    UIView *superView = self.contentView;
    if (!self.tradeModeLabel.hidden && IsIphone5S) {
        CGFloat kLeftMargin = 5;
        self.quoteLabel.sd_layout.topSpaceToView(superView,kTopMargin).leftSpaceToView(superView,kLeftMargin).rightSpaceToView(superView,kLeftMargin).heightIs(kLabelHeight);
        self.rateLabel.sd_layout.topSpaceToView(self.quoteLabel,kTopMargin*0.5).leftSpaceToView(superView,kLeftMargin).heightIs(kLabelHeight).widthIs(90);
        self.moneyLabel.sd_layout.centerYEqualToView(self.rateLabel).leftSpaceToView(self.rateLabel,kLeftMargin).heightIs(kLabelHeight);
        [self.moneyLabel setSingleLineAutoResizeWithMaxWidth:150];
        self.tradeModeLabel.sd_layout.centerYEqualToView(self.rateLabel).leftSpaceToView(self.moneyLabel,kLeftMargin).heightIs(kLabelHeight).rightSpaceToView(superView,kLeftMargin);
    }else{
        CGFloat kLeftMargin = 15;
        CGFloat width = (WIDTH-3*kLeftMargin)/3.0;
        self.quoteLabel.sd_layout.topSpaceToView(superView,kTopMargin).leftSpaceToView(superView,kLeftMargin).rightSpaceToView(superView,kLeftMargin).heightIs(kLabelHeight);
        self.rateLabel.sd_layout.topSpaceToView(self.quoteLabel,kTopMargin*0.5).leftSpaceToView(superView,kLeftMargin).widthIs(100).heightIs(kLabelHeight);
        self.moneyLabel.sd_layout.centerYEqualToView(self.rateLabel).leftSpaceToView(self.rateLabel,kLeftMargin).heightIs(kLabelHeight);
        [self.moneyLabel setSingleLineAutoResizeWithMaxWidth:180];
        self.tradeModeLabel.sd_layout.centerYEqualToView(self.rateLabel).leftSpaceToView(self.moneyLabel,kLeftMargin).widthIs(width).heightIs(kLabelHeight);
    }

}


-(void)setKLineType:(KLINE_TYPE)kLineType
{
    _kLineType = kLineType;
    /**有成交类型的： 询价买入 指定买入  票据详情/买方市场/纸票 */
    if (kLineType ==  KLine_buyerInquiry ||
        kLineType ==  KLine_buyerSpecify ||
        kLineType ==  KLine_sellerOffer  ||
        kLineType ==  KLine_beBuyerSpecify ) {
       // self.moneyLabel.hidden = NO;
        self.tradeModeLabel.hidden = NO;
    }else if(kLineType == KLine_sellerInquiry || kLineType == KLine_buyerOffer){
        /**
         报价方有交割时间的： 询价卖出 报价买入*/
       // self.moneyLabel.hidden = NO;
       self.tradeModeLabel.hidden = YES;
    }else{
        self.tradeModeLabel.hidden = YES;
        // self.moneyLabel.hidden = NO;
    }
    
    [self layoutUI];
}

@end
