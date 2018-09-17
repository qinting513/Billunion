//
//  FilterViewController.h
//  Billunion
//
//  Created by QT on 17/2/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FinishFilterBlock)(NSDictionary *dict);



@interface FilterViewController : BaseViewController

@property (nonatomic,copy) FinishFilterBlock finishFilterBlock;

/** 判断是否是附近票源 */
@property (nonatomic,assign) BOOL isNearStock;

/** 1 纸票 2\3 电票  注意： 此数组只能存一个值*/
@property (nonatomic ,strong) NSArray *billType;

/** 将所有刷选条件放到字典里 */
@property (nonatomic,strong) NSMutableDictionary *filterDict;

@end
