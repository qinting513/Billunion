//
//  MapViewController.h
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseViewController.h"

@interface MapViewController : BaseViewController

@property (nonatomic,strong)  NSMutableArray  *dataArray;

//询价信息Id
@property (nonatomic, strong) NSNumber *InquiryId;

@property (nonatomic, assign) KLINE_TYPE kLineType;

@end

