//
//  BuyerInfoLastCell.h
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuyerInfoLastCellDelegate <NSObject>

-(void)transactionBtnClick;

@end

@interface BuyerInfoLastCell : UITableViewCell


@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *rateLabel;
/** 成交  完成按钮*/
@property (nonatomic,strong)UIButton *transactionBtn;

@property (nonatomic,assign) id<BuyerInfoLastCellDelegate> delegate;

@end
