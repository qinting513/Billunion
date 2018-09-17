//
//  AskBuyCell.h
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AskBuyCell : UITableViewCell

@property (nonatomic,assign) KLINE_TYPE kLineType;

/** 询价方 */
@property (nonatomic,strong)UILabel *askBuyLabel;
/** 贴现率 */
@property (nonatomic,strong)UILabel *rateLabel;
/** 金额 */
@property (nonatomic,strong)UILabel *moneyLabel;

/** 成交类型 */
@property (nonatomic,strong)UILabel *tradeModeLabel;

@end