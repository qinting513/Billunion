//
//  BillInfoCell.h
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockView.h"



@class StockTableViewCell;
@interface BillInfoCell : UITableViewCell
/** 是否是多个同时交易 */
@property (nonatomic,assign) TransactionType transactionType;

@property (nonatomic ,strong) NSArray *dataArray;

@property (nonatomic,strong) StockView *stockView;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)height transactionType:(TransactionType)transactionType subTitles:(NSArray *)subTitles;

@end

