//
//  CityViewController.h
//  MySelectCityDemo
//
//  Created by 李阳 on 15/9/1.
//  Copyright (c) 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface CityViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,copy) void(^finishSelectCityBlock)(NSArray *cityArray);

@property (nonatomic,copy) NSString *currentCityString;

@property (nonatomic,retain) NSMutableArray *hotCityArray; // 热门城市 改为  当前选择的城市

/** 判断是不是 票据添加的  */
@property (nonatomic,assign) BOOL isAddStock;
@end
