//
//  BuyerInfoLastCell.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyerInfoLastCell.h"

@implementation BuyerInfoLastCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = MainColor;
        
        self.moneyLabel = [UILabel labelWithText:@"金额(万):2012" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.moneyLabel];
        
        self.rateLabel = [UILabel labelWithText:@"贴现率:00.00" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.rateLabel];
        
        self.transactionBtn = [UIButton buttonWithTitle:@"成交" titleFont:13.0f titleColor:[UIColor colorWithRGBHex:0xfefefe] target:self action:@selector(btnClick)];
        self.transactionBtn.backgroundColor = [UIColor colorWithRGBHex:0x2262ac];
        self.transactionBtn.layer.masksToBounds = YES;
        self.transactionBtn.layer.cornerRadius = 3;
        [self.contentView addSubview:self.transactionBtn];
       
        CGFloat top = (self.height - 13.0)*0.5;
        self.rateLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,top);
        [self.rateLabel setSingleLineAutoResizeWithMaxWidth:100];
        self.moneyLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.rateLabel,10).bottomSpaceToView(self.contentView,top);
        [self.moneyLabel setSingleLineAutoResizeWithMaxWidth:150];
        self.transactionBtn .sd_layout.centerYEqualToView(self.rateLabel).leftSpaceToView(self.moneyLabel,10).rightSpaceToView(self.contentView,10).heightIs(36);
    }
    return self;
}
/** 成交按钮点击 */
-(void)btnClick{
   if(self.delegate && [self.delegate respondsToSelector:@selector(transactionBtnClick)])
   {
       [self.delegate transactionBtnClick];
   }
}



@end
