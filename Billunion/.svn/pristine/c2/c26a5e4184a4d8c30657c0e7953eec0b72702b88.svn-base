
//
//  StockViewProtocol.h
//  Billunion
//
//  Created by Waki on 2017/2/14.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class StockView;

@protocol StockViewProtocol <NSObject>

@optional

//TradeViewController
//票据资产的票据选择
- (void)stockSelectedWithIndexArray:(NSArray *)indexArray; //跳票选择

//票据列表信息的点击事件
- (void)stockDidSelectWithIndexPath:(NSIndexPath *)indexPath
                          stockView:(id)view;

//下拉刷新   传入stockView
- (void)stockViewHeaderRefresh:(id)stockView;
//上拉加载
- (void)stockViewFooterRefresh:(id)stockView;

// 选择来删除
-(void)stockView:(StockView*)stockView didSelectToDelete:(NSIndexPath*)indexPath;

@end
