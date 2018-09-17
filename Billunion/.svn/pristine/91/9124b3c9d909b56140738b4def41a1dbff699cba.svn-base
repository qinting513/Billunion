//
//  BillInfoCell.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BillInfoCell.h"

@interface BillInfoCell ()

@end

@implementation BillInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)height transactionType:(TransactionType)transactionType subTitles:(NSArray *)subTitles
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.stockView = [[StockView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, height) withTransactionType:transactionType titles:subTitles];
        self.stockView.transactionType = transactionType;
        [self addSubview:self.stockView];
           }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray{
    self.stockView.dataArray = [dataArray mutableCopy];
    [self.stockView tableViewReloadData];
}


@end
