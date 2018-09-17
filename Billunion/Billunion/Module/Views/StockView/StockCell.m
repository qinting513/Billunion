//
//  StockCell.m
//  Billunion
//
//  Created by QT on 17/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockCell.h"
#import "StockModel.h"

#define LableTag 360
#define kBtnWidth 50
@interface StockCell ()
{
    NSInteger _count;
    CGFloat _cellWidth;
    CGFloat _cellHeight;
    UILabel *_leftLabel;
    CGFloat _cellLastX;
    UIView *_bgView;
    StockModel *_stockModel;
}

@end

@implementation StockCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemsCount:(NSInteger)count cellWidth:(CGFloat)cellWidth cellHeigth:(CGFloat)cellHeight isLeftCell:(BOOL)isLeftCell transactionType:(TransactionType)transactionType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _count = count;
        _cellWidth = cellWidth;
        _cellHeight = cellHeight;
        self.isLeftCell = isLeftCell;
        /** 获取交易类型 是单个交易还是多个同时交易 */
        self.transactionType = transactionType;
        
        [self setupUI];
    }
    return self;
}

- (UIViewController *)getTaget{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *ctl = (UIViewController*)nextResponder;
            return ctl;
        }
    }
    return nil;
}


- (void)setupUI{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellHeight)];
    _bgView.backgroundColor = [UIColor clearColor];
   [self.contentView addSubview:_bgView];
    
    for (int i = 0; i < _count; i++) {
        
        UILabel *label = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentCenter];
        label.tag = LableTag + i;
           label.lineBreakMode = NSLineBreakByTruncatingMiddle;

            if ( self.transactionType == TransactionType_Selected && _isLeftCell) {
               
             /** 有多选按钮的情况 多加按钮跟线 */
                UIButton *btn = [UIButton buttonWithNormalImage:@"circle" selectImage:@"circle_pr" imageType:btnImgTypeSmall target:self action:@selector(multipleBtnClick:)];
                
                btn.frame = CGRectMake(0, 0, kBtnWidth, _cellHeight);
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kBtnWidth-1, 0, 1, _cellHeight)];
                lineView.backgroundColor = [UIColor colorWithRGBHex:0x1a2d44];
                [btn addSubview:lineView];
                [_bgView addSubview:btn];
            
                self.selectedBtn = btn;
                
                label.frame = CGRectMake(kBtnWidth, 0, WIDTH/3, _cellHeight);
                label.backgroundColor = [UIColor clearColor];
                
            }else{
        
                label.frame = CGRectMake(WIDTH/3*i, 0, WIDTH/3, _cellHeight);
            }
            [_bgView addSubview:label];
            
         /** 竖线 */
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width - 1, 0, 1, _cellHeight)];
            lineView.backgroundColor = [UIColor colorWithRGBHex:0x1a2d44];
            [label addSubview:lineView];

    }
    
    /** 水平线 */
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cellWidth+70, 1)];
    lineView.backgroundColor = [UIColor colorWithRGBHex:0x1a2d44];
    [_bgView addSubview:lineView];
}

- (void)setTransactionType:(TransactionType)transactionType{
    if (self.transactionType != transactionType) {
        _transactionType = transactionType;
        if (_bgView) {
            [_bgView removeFromSuperview];
            [self setupUI];
        }
    }
}


/** 多选按钮 */
-(void)multipleBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSLog(@"multipleBtnClick:%ld",btn.tag );
    if ([self.delegate respondsToSelector:@selector(stockCell:selectedAtIndex:)]) {
        [self.delegate stockCell:self selectedAtIndex: btn.tag - kSelectedBtnTag];
    }
}


- (void)setCellInfo:(id)data indexPath:(NSIndexPath *)indexPath{
        self.indexPath = indexPath;
        if ([data isKindOfClass:[StockModel class]]) {
           _stockModel = (StockModel *)data;
        }else{
            return;
        }

        self.selectedBtn.tag = indexPath.row + kSelectedBtnTag;
        if (_isLeftCell) {
            UILabel *lable =  [self.contentView viewWithTag:LableTag];
            lable.text = [_stockModel getStockCodeWithRow:indexPath.row];
        }else{
            for (int i = 0; i < _count; i++) {
                UILabel *lable =  [self.contentView viewWithTag:LableTag+i];
                lable.text = [NSString stringWithFormat:@"%@",_stockModel.keyValues[@(i)]];
            }
    }
    
}
    

//只有成为第一响应者时menu才会弹出
-(BOOL)canBecomeFirstResponder
{
    // 票据资产里的纸票才可以删除
    if (_stockModel.stockType == StockAllType_Assets && _stockModel.BillType.integerValue == 1) {
           return YES;
    }
    return NO;
}

//是否可以接收某些菜单的某些交互操作
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(deleteCell:));
}

//实现这两个方法来执行具体操作
-(void)deleteCell:(UIMenuController*)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(stockCellSelectedCellToDelete:)])
    {
        [self.delegate stockCellSelectedCellToDelete:self.indexPath];
    }
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}


@end