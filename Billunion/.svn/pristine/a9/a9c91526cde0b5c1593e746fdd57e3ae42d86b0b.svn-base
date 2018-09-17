//
//  KLineTableView.h
//  Billunion
//
//  Created by QT on 17/2/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonsCell;
@class AskBuyCell;
@protocol KLineTableViewDelegate;

@interface KLineTableView : UITableView

@property (nonatomic,assign) KLINE_TYPE kLineType;

/** k线图数据 */
@property (nonatomic,strong)   NSArray * klineDataArray;
/** 报价方的数据 */
@property (nonatomic,strong)   NSArray *quoteArray;
/** 询价方 信息 */
@property (nonatomic,strong)  id askBuyData;


@property (nonatomic,assign)  id<KLineTableViewDelegate> kLineTableViewDelegate;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style kLineType:(KLINE_TYPE)kLineType images:(NSArray *)images;

@end

@protocol KLineTableViewDelegate <NSObject>

-(void)KLineTableView:(KLineTableView*)tableView buttonsCell:(ButtonsCell *)cell clickBtnAtIndex:(NSInteger)index kLineType:(KLINE_TYPE)kLineType;

-(void)KLineTableView:(KLineTableView*)tableView klineViewTypeSelect:(NSInteger)index;


-(void)KLineTableView:(KLineTableView*)tableView browsePhotos:(NSArray *)imgs beginIndex:(NSInteger)index;

-(void)KLineTableView:(KLineTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
