//
//  StockSelectViewController.h
//  Billunion
//
//  Created by Waki on 2017/2/15.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TradeConfigView.h"

@interface StockSelectViewController : BaseViewController


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL isOfferSell;

//报价卖出时会用到的参数
@property (nonatomic, strong) NSNumber *InquiryId;

@property (nonatomic, assign) TradeConfigViewType tradeConfigViewType;

@end


