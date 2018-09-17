//
//  StockCell.h
//  Billunion
//
//  Created by QT on 17/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectedBtnTag 10000

@protocol StockCellDelegate;
@interface StockCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;

/** 交易的时候 左边的圈圈 按钮 */
@property (nonatomic,strong)UIButton *selectedBtn;

/** 单个交易 还是多个交易 */
@property (nonatomic,assign) TransactionType transactionType;

@property (nonatomic,assign) id<StockCellDelegate> delegate;



/** 判断是左边tableView还是右边tableView的Cell */
@property (nonatomic,assign)  BOOL isLeftCell;;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemsCount:(NSInteger)count cellWidth:(CGFloat)cellWidth cellHeigth:(CGFloat)cellHeight isLeftCell:(BOOL)isLeftCell transactionType:(TransactionType)transactionType;

- (void)setCellInfo:(id)data indexPath:(NSIndexPath *)indexPath;



@end

@protocol StockCellDelegate <NSObject>

-(void)stockCell:(StockCell*)cell  selectedAtIndex:(NSInteger)index ;

/** 选择cell弹出删除按钮后 点击删除按钮调用的方法 */
-(void)stockCellSelectedCellToDelete:(NSIndexPath*)indexPath;

@end
