//
//  IndexModel.h
//  Billunion
//
//  Created by QT on 17/3/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject

/** 产品类型指数  银承纸票 1   银承电票 2  商承电票 3  */
@property (nonatomic,strong)NSNumber *IndexType;

/** 指数 */
@property (nonatomic,strong)NSNumber *Index;
/** 波动百分比 */
@property (nonatomic,strong)NSNumber *Percent;
/** 涨幅度 */
@property (nonatomic,strong)NSNumber *Bp;

@end
