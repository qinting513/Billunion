//
//  StockInfoViewController.h
//  Billunion
//
//  Created by QT on 17/1/18.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseViewController.h"


@interface CounterPartyViewController : BaseViewController

 @property (nonatomic,assign) KLINE_TYPE kLineType;

 @property (nonatomic,strong)NSNumber *companyId;
@end
