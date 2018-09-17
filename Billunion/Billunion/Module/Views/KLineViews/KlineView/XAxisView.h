//
//  XAxisView.h
//  Billunion
//
//  Created by Waki on 2017/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>


#define firstSpace 10

typedef  enum {
    PointViewType1,
    PointViewType2
}POINTVIEW_STYLE;
@class LinePointView;

@protocol XAxisViewDelegate;
@interface XAxisView : UIView


@property (assign, nonatomic) CGFloat pointGap;//点之间的距离
@property (assign,nonatomic)BOOL isShowLabel;//是否显示文字

@property (assign,nonatomic)BOOL isLongPress;//是不是长按状态
@property (assign, nonatomic) CGPoint currentLoc; //长按时当前定位位置
@property (assign, nonatomic) CGPoint screenLoc; //相对于屏幕位置

@property (assign,nonatomic) POINTVIEW_STYLE pointViewStyle;

@property (strong,nonatomic) LinePointView *pointView;

@property (assign, nonatomic) id<XAxisViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin pointGap:(CGFloat)pointGap;

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute;


@end

@protocol XAxisViewDelegate <NSObject>

- (void)returnSelectPoint:(CGPoint)point xText:(NSString *)xText yText:(NSString *)yText;

@end


@interface LinePointView : UIView

//当前长按选中的时间
@property (nonatomic,copy) NSString *timeDate;

//当前长按时选中的贴现率
@property (nonatomic,copy) NSString *percent;

//当前长按选中的位置model
@property (nonatomic, assign) CGPoint selectedPoint;

//当前的滑动scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

@property (nonatomic,strong) UIView *bgView;


@end
