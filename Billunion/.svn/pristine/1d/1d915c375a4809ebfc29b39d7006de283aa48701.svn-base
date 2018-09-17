//
//  KLineView.h
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#define scrollViewWidthCount 3
#import <UIKit/UIKit.h>
#import "KlineModel.h"

@protocol KlineViewDelegate;
@interface KLineView : UIView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin;

@property (nonatomic,strong) NSArray *dataArray;

@property (assign,nonatomic) id<KlineViewDelegate>delegate;

@end

@protocol KlineViewDelegate <NSObject>

- (void)klineViewSelect:(NSInteger)index;

@end
