//
//  KLineView.m
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "KLineView.h"

#import "XAxisView.h"
#import "YAxisView.h"
#import "KlineViewConfig.h"

#define buttonTag 330

@interface KLineView ()<UIScrollViewDelegate,XAxisViewDelegate>

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (strong, nonatomic) YAxisView *yAxisView;
@property (strong, nonatomic) XAxisView *xAxisView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat pointGap;
@property (assign, nonatomic) CGFloat defaultSpace;//间距

@property (assign, nonatomic) CGFloat moveDistance;

@property (strong,nonatomic) UILabel *lastLabel;
@property (strong,nonatomic) UILabel *nowLabel;

//@property (strong,nonatomic) UILabel *XPromptLabel;
@property (strong,nonatomic) UILabel *YPromptLabel;

@property (assign,nonatomic) CGPoint selectLocation;

@property (strong, nonatomic) UILabel *percentLabel;

@property (assign, nonatomic) CGFloat lastSpace;

@property (nonatomic,strong) UIButton *lastButton;

@end


@implementation KLineView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.yMax = yMax;
        self.yMin = yMin;
        [self layoutSpaceWithXArray:xTitleArray YArray:yValueArray];
        //x轴
        [self addXLine];
        //k线图
        [self creatXAxisView];
        //右边的Y轴视图
        [self creatYAxisView];
        //横纵坐标提示的label
        [self layoutPromptLabel];
        //左右两边的时间
        [self layoutBottomLabel];
        //k线图的类别按钮
        [self layoutControlButton];
     
    }
    return self;
}

- (void)addGestureRecognizer{
    // 2. 捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.xAxisView addGestureRecognizer:pinch];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
    [self.xAxisView addGestureRecognizer:longPress];
    longPress.minimumPressDuration = 0.1;
}

- (void)layoutSpaceWithXArray:(NSArray *)xTitleArray YArray:(NSArray *)yValueArray{
    self.xTitleArray = xTitleArray;
    self.yValueArray = yValueArray;
    if (xTitleArray.count > 600) {
        _defaultSpace = 5;
    }
    else if (xTitleArray.count > 400 && xTitleArray.count <= 600){
        _defaultSpace = 10;
    }
    else if (xTitleArray.count > 200 && xTitleArray.count <= 400){
        _defaultSpace = 20;
    }
    else if (xTitleArray.count > 100 && xTitleArray.count <= 200){
        _defaultSpace = 30;
    }
    else {
        _defaultSpace = 40;
    }
    _lastSpace =0;
    self.pointGap = _defaultSpace;
}



- (void)creatYAxisView {
    
    self.yAxisView = [[YAxisView alloc]initWithFrame:CGRectMake(self.frame.size.width-rightViewMargin, 0, rightViewMargin, self.frame.size.height) yMax:self.yMax yMin:self.yMin];
    [self addSubview:self.yAxisView];
    
}

- (void)creatXAxisView {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-rightViewMargin, self.frame.size.height-bottomSpace)];
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.bounces = NO;
    _scrollView.bouncesZoom = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [self reloadxAxisView];
}

- (void)reloadxAxisView{
    if (self.xAxisView) {
        [self.xAxisView removeFromSuperview];
    }
    
    CGFloat xAxisViewWidth;
    if (self.xTitleArray.count *self.pointGap + _lastSpace < _scrollView.frame.size.width) {
        xAxisViewWidth = _scrollView.frame.size.width;
    }else{
        xAxisViewWidth = self.xTitleArray.count * self.pointGap + _lastSpace;
    }
    
    self.xAxisView = [[XAxisView alloc] initWithFrame:CGRectMake(0, 0, xAxisViewWidth, _scrollView.frame.size.height) xTitleArray:self.xTitleArray yValueArray:self.yValueArray yMax:self.yMax yMin:self.yMin pointGap:_pointGap];

    self.xAxisView.isShowLabel = NO;
    self.xAxisView.delegate = self;
    self.xAxisView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:self.xAxisView];
    
    _scrollView.contentSize = self.xAxisView.frame.size;
    if (self.xAxisView.frame.size.width > _scrollView.frame.size.width) {
         [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width-self.frame.size.width+rightViewMargin, 0)];
    }
    [self addGestureRecognizer];
}


// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        
        if (self.xAxisView.frame.size.width-_lastSpace <= self.scrollView.frame.size.width) { //当缩小到小于屏幕宽时，松开回复屏幕宽度
            
            CGFloat scale = self.scrollView.frame.size.width / (self.xAxisView.frame.size.width-_lastSpace);
            
            self.pointGap *= scale;
            
            [UIView animateWithDuration:0.25 animations:^{
            
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.scrollView.frame.size.width+_lastSpace;
                self.xAxisView.frame = frame;
            }];
        
            self.xAxisView.pointGap = self.pointGap;
            
        }else if (self.xAxisView.frame.size.width-_lastSpace >= self.xTitleArray.count * _defaultSpace){
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.xTitleArray.count * _defaultSpace + _lastSpace;
                self.xAxisView.frame = frame;
                
            }];
            
            self.pointGap = _defaultSpace;
            
            self.xAxisView.pointGap = self.pointGap;
        }
    }else{
        
        CGFloat currentIndex,leftMagin;
        if( recognizer.numberOfTouches == 2 ) {
            //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.xAxisView];
            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.xAxisView];
            CGFloat centerX = (p1.x+p2.x)/2;
            leftMagin = centerX - self.scrollView.contentOffset.x;
            //            NSLog(@"centerX = %f",centerX);
            //            NSLog(@"self.scrollView.contentOffset.x = %f",self.scrollView.contentOffset.x);
            //            NSLog(@"leftMagin = %f",leftMagin);
            
            
            currentIndex = centerX / self.pointGap;
            //            NSLog(@"currentIndex = %f",currentIndex);

            self.pointGap *= recognizer.scale;
            self.pointGap = self.pointGap > _defaultSpace ? _defaultSpace : self.pointGap;
            if (self.pointGap == _defaultSpace) {
                
//                [SVProgressHUD showErrorWithStatus:@"已经放至最大"];
            }
            self.xAxisView.pointGap = self.pointGap;
            recognizer.scale = 1.0;
            
            self.xAxisView.frame = CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + _lastSpace, self.frame.size.height-bottomSpace);
            
            self.scrollView.contentOffset = CGPointMake(currentIndex*self.pointGap-leftMagin, 0);
            //            NSLog(@"contentOffset = %f",self.scrollView.contentOffset.x);
            
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, 0);
    
}


- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self.xAxisView];
        
        //相对于屏幕的位置
        CGPoint screenLoc = CGPointMake(location.x - self.scrollView.contentOffset.x, location.y);
        [self.xAxisView setScreenLoc:screenLoc];
        
        if (location.x < self.pointGap*2) {
            self.xAxisView.currentLoc = location;
            [self.xAxisView setIsShowLabel:YES];
            [self.xAxisView setIsLongPress:YES];
            _moveDistance = location.x;
        }else if (ABS(location.x - _moveDistance) > self.pointGap*0.8) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
            
            [self.xAxisView setIsShowLabel:YES];
            [self.xAxisView setIsLongPress:YES];
            self.xAxisView.currentLoc = location;
            _moveDistance = location.x;
       }
        
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        _moveDistance = 0;
       // 恢复scrollView的滑动
        [self.xAxisView setIsLongPress:NO];
        [self.xAxisView setIsShowLabel:NO];
        _percentLabel.hidden = YES;
        if (self.xAxisView.pointView) {
            self.xAxisView.pointView.hidden = YES;
        }
    }
}


#pragma mark - XAxisViewDelegate    //X轴的日期 Y轴的贴现率
- (void)returnSelectPoint:(CGPoint)point xText:(NSString *)xText yText:(NSString *)yText{
    if (!_percentLabel) {
        _percentLabel = [UILabel labelWithText:nil fontSize:9 textColor:[UIColor colorWithRGBHex:0x93b8eb] alignment:NSTextAlignmentCenter];
        _percentLabel.backgroundColor = [UIColor blackColor];
        _percentLabel.layer.borderWidth = 1;
        _percentLabel.layer.borderColor = [UIColor colorWithRGBHex:0x93b8eb].CGColor;
        [self addSubview:_percentLabel];
    }
    _percentLabel.hidden = NO;
    _percentLabel.frame = CGRectMake(self.width-rightViewMargin-15, point.y-6, 30, 12);
    _percentLabel.text = yText;
    
}


- (void)layoutBottomLabel{
    _lastLabel = [UILabel labelWithText:@"0" fontSize:9 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [self addSubview:_lastLabel];
    _nowLabel = [UILabel labelWithText:@"0" fontSize:9 textColor:[UIColor whiteColor] alignment:NSTextAlignmentRight];
    [self addSubview:_nowLabel];
   
    _lastLabel.sd_layout.leftEqualToView(self).bottomEqualToView(self).widthIs(100).heightIs(bottomSpace);
    _nowLabel.sd_layout.rightSpaceToView(self,rightViewMargin).bottomEqualToView(self).widthIs(100).heightIs(bottomSpace);

    //_nowLabel.text = [_xTitleArray lastObject];
    [self setDateLabel];
}

//重设日期
- (void)setDateLabel{
    //向上取整
    int leftIndex =  ceilf((_scrollView.contentOffset.x-self.pointGap)/self.pointGap);
    if (leftIndex < 0) {
        leftIndex = 0;
    }
    if (leftIndex < _xTitleArray.count && leftIndex >=0 ) {
//        NSString * lastTime = (NSString *)_xTitleArray[leftIndex];
//        if (lastTime.length > 5) {
//            _lastLabel.text = [(NSString *)_xTitleArray[leftIndex] substringFromIndex:5];
//        }else{
//            _lastLabel.text = (NSString *)_xTitleArray[leftIndex];
//        }
         _lastLabel.text = (NSString *)_xTitleArray[leftIndex];
    }else{
       _lastLabel.text = @"0";
    }
    
    //向下取整
    int rightIndex =  floor((_scrollView.contentOffset.x+_scrollView.frame.size.width-_lastSpace)/self.pointGap);
    if (rightIndex >= _xTitleArray.count) {
        rightIndex = (int)_xTitleArray.count-1;
    }
    if (rightIndex < _xTitleArray.count) {
 //      NSString * nowTime = (NSString *)_xTitleArray[rightIndex];
//        if (nowTime.length > 5) {
//            _nowLabel.text = [(NSString *)_xTitleArray[rightIndex] substringFromIndex:5];
//        }else{
//            _nowLabel.text = (NSString *)_xTitleArray[rightIndex];
//        }
        _nowLabel.text = (NSString *)_xTitleArray[rightIndex];
    }else{
        _nowLabel.text = @"0";
    }
    
//    if (rightIndex < _xTitleArray.count && (leftIndex < _xTitleArray.count && leftIndex >=0)) {
//        NSString *year1 = [[_xTitleArray[leftIndex] componentsSeparatedByString:@"-"] firstObject];
//        NSString *year2 = [[_xTitleArray[rightIndex] componentsSeparatedByString:@"-"] firstObject];
//        
//        if ([year1 isEqualToString:year2]){
//            _XPromptLabel.text = [NSString stringWithFormat:@"日期(%@年)",year1];
//        }else{
//            _XPromptLabel.text = [NSString stringWithFormat:@"日期(%@~%@年)",year1,year2];
//        }
//    }
}

- (void)layoutPromptLabel{
//    if (!_XPromptLabel) {
//        _XPromptLabel = [UILabel labelWithText:nil fontSize:10 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
//        [self addSubview:_XPromptLabel];
//        _XPromptLabel.sd_layout.leftSpaceToView(self,10).bottomSpaceToView(self,35).widthIs(100).autoHeightRatio(0);
//    }
    
    if (!_YPromptLabel) {
        _YPromptLabel = [UILabel labelWithText:nil fontSize:10 textColor:[UIColor whiteColor] alignment:NSTextAlignmentRight];
        [self addSubview:_YPromptLabel];
        _YPromptLabel.sd_layout.rightSpaceToView(self,rightViewMargin+3).topSpaceToView(self,10).widthIs(50).autoHeightRatio(0);
        _YPromptLabel.text = @"贴现率(%)";
    }
}

//x轴
- (void)addXLine{
    UIView *xLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-YAxisBottomSpace, self.width-rightViewMargin+1, 0.7)];
    xLine.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:0.9];
    [self addSubview:xLine];
}

- (void)layoutControlButton{
    NSArray *titleArr = @[@"时线",@"日线",@"周线",@"月线",@"年线"];
    CGFloat buttonHeight = STRealY(40);
    CGFloat buttonWidth  = STRealY(90);
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithTitle:titleArr[i] titleFont:10 titleColor:[UIColor colorWithRGBHex:0x93a6be] target:self action:@selector(controlButtonClick:)];
        button.tag = buttonTag+i;
        button.layer.borderWidth = 1;
        button.backgroundColor = [UIColor blackColor];
        button.layer.cornerRadius = 2;
        button.layer.borderColor = [UIColor colorWithRGBHex:0x93a6be].CGColor;
        [self addSubview:button];
        
        if (i == 0) {
            button.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _lastButton = button;
        }

        button.frame = CGRectMake(0+(i*(buttonWidth+7)), 5, buttonWidth, buttonHeight);

    }
}

/**
 写入数据，刷新K线图

 @param dataArray K线图的数据源，里面两个数组，0为X数组 1为Y数据

 */
- (void)setDataArray:(NSArray *)dataArray{
    
    [self layoutSpaceWithXArray:[dataArray firstObject] YArray:[dataArray lastObject]];
    [self reloadxAxisView];
    [self layoutPromptLabel];
    [self setDateLabel];
}

- (void)controlButtonClick:(UIButton *)btn{
    _lastButton.backgroundColor = [UIColor blackColor];
    btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lastButton = btn;
    
    NSInteger intex = btn.tag-buttonTag+1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(klineViewSelect:)]) {
        [self.delegate klineViewSelect:intex];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setDateLabel];
}

@end
