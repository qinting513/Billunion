//
//  ViewController.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^SelectedDateBlock)(BOOL isStartDate,NSString *dateStr);

@interface CalendarViewController : BaseViewController

@property (nonatomic,assign) BOOL isStartDate;

@property (nonatomic,strong) NSString *startDateStr;
@property (nonatomic,strong) NSString *endDateStr;

@property (nonatomic,copy) SelectedDateBlock selectedDateBlock;

@end

