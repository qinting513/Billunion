//
//  ViewController.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "CalendarViewController.h"
#import "ZYCalendarView.h"
#import "UIView+HUD.h"

@interface CalendarViewController ()
@property (nonatomic,strong) NSString *startDate;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBakcButton];
    self.title = @"日期选择";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    weekTitlesView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:weekTitlesView];
    CGFloat weekW = self.view.frame.size.width/7;
    NSArray *titles = @[@"日", @"一", @"二", @"三",
                        @"四", @"五", @"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 0, weekW, 44)];
        week.textAlignment = NSTextAlignmentCenter;
        week.textColor = ZYHEXCOLOR(0xffffff);
        
        [weekTitlesView addSubview:week];
        week.text = titles[i];
    }
    
    
    ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0, 64+44, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    // 是否可以点击已经过去的日期
    view.manager.canSelectPastDays = YES;
    // 可以选择时间段
    view.manager.selectionType = ZYCalendarSelectionTypeSingle;
    // 设置当前日期
    view.date = [NSDate date];
    __weak typeof(self) weakSelf = self;
    view.dayViewBlock = ^(NSDate *dayDate) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr = [format stringFromDate:dayDate];
        
        if(weakSelf.isStartDate){
            NSDate *today = [NSDate date];
            NSComparisonResult result = [dayDate compare:today];
            if (result == NSOrderedDescending) {
                [weakSelf.view showWarning:@"出票日期不能大于今日"];
                return;
            }
        }
      
        /** 先选择了 到票日期 再选择出票日期 */
        if (weakSelf.isStartDate && weakSelf.endDateStr != nil) {
            NSDate *endDate   = [format dateFromString:weakSelf.endDateStr];
            NSComparisonResult result = [dayDate compare:endDate];
            if (result == NSOrderedDescending) {
                [weakSelf.view showWarning:@"到票日期不能小于出票日期"];
                return;
            }
        } else if (!weakSelf.isStartDate && weakSelf.startDateStr != nil) {
             /** 先选择了 出票日期 */
            NSDate *startDate   = [format dateFromString:weakSelf.startDateStr];
            NSComparisonResult result = [startDate compare:dayDate];
            if (result == NSOrderedDescending) {
                [weakSelf.view showWarning:@"到票日期不能小于出票日期"];
                return;
            }
           
        }
        
        !weakSelf.selectedDateBlock ?: weakSelf.selectedDateBlock(weakSelf.isStartDate, dateStr);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:view];
}


@end
