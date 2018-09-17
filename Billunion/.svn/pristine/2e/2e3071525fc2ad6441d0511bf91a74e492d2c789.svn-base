//
//  CounterPartySearchController.h
//  Billunion
//
//  Created by Waki on 2017/4/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



typedef NS_ENUM(NSInteger, SearchType) {
    SearchType_CounterParty, // 交易对手
    SearchType_Acceptor  //承兑人
};

@interface CounterPartySearchController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,copy) void(^finishSelectBlock)(id selectObject);

@property (nonatomic,copy) NSString *currentStr;

@property (nonatomic,assign) SearchType searchType;



@end
