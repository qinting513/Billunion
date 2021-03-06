//
//  TradeNewsModel.h
//  Billunion
//
//  Created by QT on 2017/3/16.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface TradeNewsModel : JKDBModel

/** 公告标题 */
@property (nonatomic, copy) NSString *Title;
/** 创建时间 */
@property (nonatomic, copy) NSString *CreateTime;
/** 内容详情 */
@property (nonatomic,strong)NSString *Content;
/** 公告ID */
@property (nonatomic, strong) NSNumber *Id;
/** 是否已读  YES未读，NO已读 */
@property (nonatomic,assign)BOOL isNotRead;

@end
