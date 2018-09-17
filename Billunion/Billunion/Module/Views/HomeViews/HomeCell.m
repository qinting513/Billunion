//
//  HomeCell.m
//  Billunion
//
//  Created by QT on 2017/3/30.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "HomeCell.h"
#import "QTVerticalButton.h"

@implementation HomeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSArray *titleArr = @[  NSLocalizedString(@"Market", nil),
                                NSLocalizedString(@"Trade", nil),
                                NSLocalizedString(@"Assets", nil),
                                NSLocalizedString(@"Record", nil),
                                ];
        NSArray *imgArr   =   @[@"market",@"deal",@"property",@"record"];
        NSArray *selImgArr = @[@"marker_pr",@"deal_pr",@"property_pr",@"record_pr"];
        
        for (int i = 0; i < titleArr.count; i++) {
            CGRect rect = STRect(58+(i*(100+74)), 30, 120, 120);
            UIColor *titleColor = [UIColor colorWithRGBHex:0x93a6be];
            QTVerticalButton *button = [QTVerticalButton buttonTitle:titleArr[i] img:imgArr[i] selectImg:selImgArr[i] font:12 titleColor:titleColor target:self action:@selector(buttonClick:)];
            button.frame = rect;
            button.tag = 40 + i;
            [self.contentView addSubview:button];
        }
        
    }
    return self;
    
}

-(void)buttonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(homeCell:didSelectedIndex:)]) {
        [self.delegate homeCell:self didSelectedIndex:btn.tag - 40];
    }
}

@end
