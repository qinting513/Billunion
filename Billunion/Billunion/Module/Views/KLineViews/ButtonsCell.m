//
//  ButtonsCell.m
//  Billunion
//
//  Created by QT on 17/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "ButtonsCell.h"

#define kTopMargin 10
#define kLeftMargin 5
//#define kLabelHeight 20
#define kBtnTag 200

@interface ButtonsCell ()

@property (nonatomic,assign) KLINE_TYPE kLineType;

@end

@implementation ButtonsCell

/** 
 KLine_buyerInquiry,         //询价买入           2 票源距离 撤销
 KLine_buyerSpecify,   //指定买入           2 票源距离 撤销
 KLine_buyerOffer,       //报价买入           3 票源距离 撤销报价 修改报价
 KLine_beSellerSpecify,   //被指定卖出          3 票源距离 撤销报价 修改报价
 KLine_sellerInquiry,           //询价卖出  有头视图    2 票源距离 撤销
 KLine_sellerSpecify,     //指定卖出            2 票源距离 撤销
 KLine_sellerOffer,         //报价卖出            3 票源距离 撤销报价 修改报价
 KLine_beBuyerSpecify,  //被指定买入         3 票源距离 取消交易 修改报价
 KLine_buyerMarket,        //买方市场           1 卖出
 KLine_sellerMarket        //卖方市场  有头视图   2 票源距离 买入
 */

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier KLineType:(KLINE_TYPE)kLineType{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUIWithKLineType:kLineType];
    }
    return self;
}

-(void)setupUIWithKLineType:(KLINE_TYPE)kLineType{
    _kLineType = kLineType;
    switch (kLineType) {
            /** 1 个按钮的 */
        case KLine_buyerMarket:
        {
         [self setupButtonsWithTitles:@[ NSLocalizedString(@"Selling", nil) ] imgs:@[@"seller"]];
          break;
        }
                  /** 2个按钮的 */
        case KLine_buyerInquiry:
        case KLine_sellerInquiry:
        case KLine_buyerSpecify:
        case KLine_sellerSpecify:
        {
            NSArray *titles = @[ NSLocalizedString(@"StockDistance", nil),
                                 NSLocalizedString(@"UndoStock", nil),
                                 NSLocalizedString(@"ModifyOffer", nil)];
            NSArray *imgs = @[@"distance",@"recall",@"modify"];
            [self setupButtonsWithTitles:titles imgs:imgs];
            break;
        }
        case KLine_sellerMarket:
        {
            NSArray *titles = @[NSLocalizedString(@"StockDistance", nil),NSLocalizedString(@"Buying", nil)];
            NSArray *imgs = @[@"distance",@"buying"];
            [self setupButtonsWithTitles:titles imgs:imgs];
            break;
        }
        case KLine_buyerOffer:
        case KLine_beSellerSpecify:
        case KLine_sellerOffer:
        {
            NSArray *titles = @[ NSLocalizedString(@"StockDistance", nil),
                                 NSLocalizedString(@"UndoOffer", nil),
                                 NSLocalizedString(@"ModifyOffer", nil)];
            NSArray *imgs = @[@"distance",@"recall",@"modify"];
              [self setupButtonsWithTitles:titles imgs:imgs];
            break;
        }
        case KLine_beBuyerSpecify:
        {
            NSArray *titles = @[NSLocalizedString(@"StockDistance", nil),
                                NSLocalizedString(@"CancelTrade", nil),
                                NSLocalizedString(@"ModifyOffer", nil)];
            NSArray *imgs = @[@"distance",@"recall",@"modify"];
            [self setupButtonsWithTitles:titles imgs:imgs];
            break;
        }
        case KLine_nearStock:
        {
            NSArray *titles = @[NSLocalizedString(@"Buying", nil)];
            NSArray *imgs = @[@"buying"];
            [self setupButtonsWithTitles:titles imgs:imgs];
        }
        default:
            break;
    }
}

-(void)setupButtonsWithTitles:(NSArray *)titles imgs:(NSArray *)imgs
{
    UIView *superView = self.contentView;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithTitle:titles[i] titleFont:13.0 titleColor:[UIColor whiteColor] target:self action:@selector(btnClick:)];
        btn.tag = i + kBtnTag;
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [superView addSubview:btn];
        btn.backgroundColor = [UIColor colorWithRGBHex:0x2262ac];
        CGFloat width = (WIDTH - kLeftMargin*titles.count*2)/titles.count;
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        
        btn.sd_layout.topSpaceToView(superView,kTopMargin).leftSpaceToView(superView,kLeftMargin + (2*kLeftMargin+width)*i).bottomSpaceToView(superView,kTopMargin).widthIs(width);
    }
}

-(void)updateButtonTitleWithTitles:(NSArray *)titles{
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = (UIButton*)[self.contentView viewWithTag:(i+kBtnTag)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
    }
}

-(void)btnClick:(UIButton *)btn
{
    NSLog(@"btn tag:%ld",btn.tag);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonsCell:clickBtnAtIndex:kLineType:)]) {
        [self.delegate  buttonsCell:self clickBtnAtIndex:(btn.tag-kBtnTag) kLineType:self.kLineType];
    }
}

@end
