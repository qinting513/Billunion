//
//  XAxisView.m
//  Billunion
//
//  Created by Waki on 2017/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "XAxisView.h"
#import "KlineViewConfig.h"

@interface XAxisView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

/**
 *  记录坐标轴的第一个frame
 */
@property (assign, nonatomic) CGRect firstFrame;
@property (assign, nonatomic) CGRect firstStrFrame;//第一个点的文字的frame
@end

@implementation XAxisView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin pointGap:(CGFloat)pointGap{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.xTitleArray = xTitleArray;
        self.yValueArray = yValueArray;
        self.yMax = yMax;
        self.yMin = yMin;
        self.pointViewStyle = pointViewType;
        
        self.pointGap = pointGap;
    }
    
    return self;
}

- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    
    [self setNeedsDisplay];
}

- (void)setIsLongPress:(BOOL)isLongPress {
    _isLongPress = isLongPress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat custonHeight  = YAxisBottomSpace - bottomSpace;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ////////////////////// X轴文字 //////////////////////////
    // 添加坐标轴Label
    //    for (int i = 0; i < self.xTitleArray.count; i++) {
    //        NSString *title = self.xTitleArray[i];
    //
    //        [[UIColor blackColor] set];
    //        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
    //        CGSize labelSize = [title sizeWithAttributes:attr];
    //
    //        CGRect titleRect = CGRectMake((i + 1) * self.pointGap - labelSize.width / 2,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
    //
    //        if (i == 0) {
    //            self.firstFrame = titleRect;
    //            if (titleRect.origin.x < 0) {
    //                titleRect.origin.x = 0;
    //            }
    //
    //            [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
    //
    //            //画垂直X轴的竖线
    //            [self drawLine:context
    //                startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
    //                  endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-10)
    //                 lineColor:kChartLineColor
    //                 lineWidth:1];
    //        }
    //        // 如果Label的文字有重叠，那么不绘制
    //        CGFloat maxX = CGRectGetMaxX(self.firstFrame);
    //        if (i != 0) {
    //            if ((maxX + 3) > titleRect.origin.x) {
    //                //不绘制
    //
    //            }else{
    //
    //                [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
    //                //画垂直X轴的竖线
    //                [self drawLine:context
    //                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
    //                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-10)
    //                     lineColor:kChartLineColor
    //                     lineWidth:1];
    //
    //                self.firstFrame = titleRect;
    //            }
    //        }else {
    //            if (self.firstFrame.origin.x < 0) {
    //
    //                CGRect frame = self.firstFrame;
    //                frame.origin.x = 0;
    //                self.firstFrame = frame;
    //            }
    //        }
    //
    //    }
    
    
    //    NSArray *titleArr = @[@"2016.10.10",@"2017.1.7"];
    //    for (int i = 0; i < titleArr.count; i++) {
    //        NSString *title = titleArr[i];
    //        [[UIColor blackColor] set];
    //        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
    //        CGSize labelSize = [title sizeWithAttributes:attr];
    //
    //        CGRect titleRect;
    //        if (i == 0) {
    ////            self.firstFrame = titleRect;
    ////            if (titleRect.origin.x < 0) {
    ////                titleRect.origin.x = 0;
    ////            }
    //            titleRect  = CGRectMake(0,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
    //        }else{
    //           titleRect  = CGRectMake(self.frame.size.width - labelSize.width,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
    //        }
    //
    //        [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
    //    }
    
    
    //////////////// 画原点上的x轴 ///////////////////////
//    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
//    CGSize textSize = [@"x" sizeWithAttributes:attribute];
//    textSize.height = 0;
//    
//    [self drawLine:context
//        startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5)
//          endPoint:CGPointMake(self.frame.size.width, self.frame.size.height - textSize.height - 5)
//         lineColor:kChartLineColor
//         lineWidth:1];
    
    
    //////////////// 画横向分割线 ///////////////////////
    //    CGFloat separateMargin = (self.frame.size.height - topMargin - textSize.height - 5 - 5 * 1) / 5;
    //    for (int i = 0; i < 5; i++) {
    //
    //        [self drawLine:context
    //            startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
    //              endPoint:CGPointMake(0+self.frame.size.width, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
    //             lineColor:[UIColor lightGrayColor]
    //             lineWidth:.1];
    //    }
    
    NSMutableArray *pointValueArray = [[NSMutableArray alloc] init];
    
    /////////////////////// 根据数据源画折线 /////////////////////////
    if (self.yValueArray && self.yValueArray.count > 0) {
        
        //画折线
        for (NSInteger i = 0; i < self.yValueArray.count; i++) {
            
            //如果是最后一个点
            if (i == self.yValueArray.count-1) {
                
                NSNumber *endValue = self.yValueArray[i];
                CGFloat chartHeight = self.frame.size.height - topMargin-custonHeight;
                CGPoint endPoint = CGPointMake((i+1)*self.pointGap, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                
                //画最后一个点
                UIColor*aColor = [UIColor lightGrayColor]; //点的颜色
                CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                CGContextAddArc(context, endPoint.x, endPoint.y, 1, 0, 2*M_PI, 0); //添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
                
                [pointValueArray addObject:[NSValue valueWithCGPoint:endPoint]];
                
                //                //画点上的文字
                //                NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                //                // 判断是不是小数
                //                if ([self isPureFloat:endValue.floatValue]) {
                //                    str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                //                }
                //                else {
                //                    str = [NSString stringWithFormat:@"%.0f", endValue.floatValue];
                //                }
                //
                //                NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                //                CGSize strSize = [str sizeWithAttributes:attr];
                //
                //                CGRect strRect = CGRectMake(endPoint.x-strSize.width/2,endPoint.y-strSize.height,strSize.width,strSize.height);
                //
                //                // 如果点的文字有重叠，那么不绘制
                //                CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                //                if (i != 0) {
                //                    if ((maxX + 3) > strRect.origin.x) {
                //                        //不绘制
                //
                //                    }else{
                //
                //                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                //
                //                        self.firstStrFrame = strRect;
                //                    }
                //                }else {
                //                    if (self.firstStrFrame.origin.x < 0) {
                //
                //                        CGRect frame = self.firstStrFrame;
                //                        frame.origin.x = 0;
                //                        self.firstStrFrame = frame;
                //                    }
                //                }
                
            }else {
                
                NSNumber *startValue = self.yValueArray[i];
                NSNumber *endValue = self.yValueArray[i+1];
                 CGFloat chartHeight = self.frame.size.height - topMargin-custonHeight;
                
                CGPoint startPoint = CGPointMake((i+1)*self.pointGap, chartHeight -  (startValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                CGPoint endPoint = CGPointMake((i+2)*self.pointGap, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                
                CGFloat normal[1]={1};
                CGContextSetLineDash(context,0,normal,0); //画实线
                
                [self drawLine:context startPoint:startPoint endPoint:endPoint lineColor:KlineColor lineWidth:line_width];
                
                [pointValueArray addObject:[NSValue valueWithCGPoint:startPoint]];
                //画点
                UIColor*aColor = [UIColor lightGrayColor]; //点的颜色
                CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                CGContextAddArc(context, startPoint.x, startPoint.y, 1, 0, 2*M_PI, 0); //添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
                
                
                //                if (!_isShowLabel) {
                //
                //                    //画点上的文字
                //                    NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                //                    // 判断是不是小数
                //                    if ([self isPureFloat:startValue.floatValue]) {
                //                        str = [NSString stringWithFormat:@"%.2f", startValue.floatValue];
                //                    }
                //                    else {
                //                        str = [NSString stringWithFormat:@"%.0f", startValue.floatValue];
                //                    }
                //
                //                    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                //                    CGSize strSize = [str sizeWithAttributes:attr];
                //
                //                    CGRect strRect = CGRectMake(startPoint.x-strSize.width/2,startPoint.y-strSize.height,strSize.width,strSize.height);
                //                    if (i == 0) {
                //                        self.firstStrFrame = strRect;
                //                        if (strRect.origin.x < 0) {
                //                            strRect.origin.x = 0;
                //                        }
                //
                //                        [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                //                    }
                //                    // 如果点的文字有重叠，那么不绘制
                //                    CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                //                    //            NSLog(@"%f   %f",maxX,strRect.origin.x);
                //                    if (i != 0) {
                //                        if ((maxX + 3) > strRect.origin.x) {
                //                            //不绘制
                //
                //                        }else{
                //
                //                            [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                //
                //                            self.firstStrFrame = strRect;
                //                        }
                //                    }else {
                //                        if (self.firstStrFrame.origin.x < 0) {
                //
                //                            CGRect frame = self.firstStrFrame;
                //                            frame.origin.x = 0;
                //                            self.firstStrFrame = frame;
                //                        }
                //                    }
                //                }
            }
            
            
        }
        
    }
    
    if (useYingyin) {
        [self drawYingyinRect:self.frame withPoints:pointValueArray index:0];
    }
    
    
    //长按时进入
    if(self.isLongPress)
    {
//        
//        ceil(x)返回不小于x的最小整数值（然后转换为double型）。
//        floor(x)返回不大于x的最大整数值。
//        round(x)返回x的四舍五入整数值。
        int nowPoint = round(_currentLoc.x/self.pointGap);
        if (nowPoint != 0) {
            nowPoint -= 1;
        }
        if(nowPoint >= 0 && nowPoint < [self.yValueArray count]) {
            
            NSString *num = [self.yValueArray objectAtIndex:nowPoint];
            CGFloat chartHeight = self.frame.size.height - topMargin-custonHeight;
            CGPoint selectPoint = CGPointMake((nowPoint+1)*self.pointGap, chartHeight -  (num.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            
            //            NSLog(@"_screenLoc=%@",NSStringFromCGPoint(_screenLoc));
            //            NSLog(@"_currentLoc=%@",NSStringFromCGPoint(_currentLoc));
            
            // 显示的时间和水位
            //            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSaveGState(context);
            
            
            //            NSString *timeStr = ;
            NSDictionary *timeAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
            CGSize timeSize = [[NSString stringWithFormat:@"时间:%@",self.xTitleArray[nowPoint]] sizeWithAttributes:timeAttr];
            
            
            //画文字所在的位置  动态变化
            CGPoint drawPoint = CGPointZero;
            if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠右边边并且在屏幕靠上面的地方   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, 80-60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, self.frame.size.height-20 -60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠右边边   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, _currentLoc.y-60);
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠左边边并且在屏幕靠上面的地方   那么字就显示在按住位置的右上角上角40 40位置
                drawPoint = CGPointMake(_currentLoc.x+40, 80-60);
                
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                
                drawPoint = CGPointMake(_currentLoc.x+40, self.frame.size.height-20 -60);
                
            }
            else if(_screenLoc.x  <= ((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠左边   那么字就显示在按住位置的右上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x+40, _currentLoc.y-60);
            }
            
            //画选中的数值 x轴数据
            [[NSString stringWithFormat:@"时间:%@",self.xTitleArray[nowPoint]] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            
            // 判断是不是小数  y轴数据
            if ([num isPureFloat]) {
                [[NSString stringWithFormat:@"贴现率:%.3f%@", [num floatValue],@"%"] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            }
            else {
                [[NSString stringWithFormat:@"贴现率:%.3f%@", [num floatValue],@"%"] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15)withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];

            }
            

            
            if (self.pointViewStyle == 0) {
                if (!_pointView) {
                    _pointView = [[LinePointView alloc] initWithFrame:self.bounds];
                    _pointView.backgroundColor = [UIColor clearColor];
                    [self.superview.superview addSubview:_pointView];
                }else{
                    _pointView.hidden = NO;
                }
                _pointView.percent = num;
                _pointView.timeDate = [NSString stringWithFormat:@"%@",self.xTitleArray[nowPoint]];
                _pointView.stockScrollView = (UIScrollView *)self.superview;
                _pointView.selectedPoint = selectPoint;
                
                [_pointView setNeedsDisplay];
                
            }else{
                
                //画十字线
                CGContextRestoreGState(context);
                CGContextSetLineWidth(context, selectLine_width);
                CGContextSetFillColorWithColor(context, [UIColor colorWithRGBHex:0x5094b8eb].CGColor);
                CGContextSetStrokeColorWithColor(context, [UIColor colorWithRGBHex:0x5094b8eb].CGColor);
                
                // 选中横线
                CGContextMoveToPoint(context, selectPoint.x, selectPoint.y);
                CGContextAddLineToPoint(context, self.frame.size.width, selectPoint.y);
                
                // 选中竖线
                CGContextMoveToPoint(context, selectPoint.x, selectPoint.y);
                CGContextAddLineToPoint(context, selectPoint.x, self.frame.size.height);
                
                CGContextStrokePath(context);
                
//                [self drawLine:context startPoint:CGPointMake(selectPoint.x, 0) endPoint:CGPointMake(selectPoint.x, self.frame.size.height- textSize.height - 5) lineColor:[UIColor lightGrayColor] lineWidth:selectLine_width];
                
//                // 交界点
//                CGRect myOval = {selectPoint.x-2, selectPoint.y-2, 4, 4};
//                CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//                CGContextAddEllipseInRect(context, myOval);
//                CGContextFillPath(context);
                
                //绘制交叉圆点
                CGContextSetStrokeColorWithColor(context,  [UIColor whiteColor].CGColor);
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextSetLineWidth(context, 1.5);
                CGContextSetLineDash(context, 0, NULL, 0);
                CGContextAddArc(context, selectPoint.x, selectPoint.y, 5, 0, 2 * M_PI, 0);
                CGContextDrawPath(context, kCGPathFillStroke);


                //绘制选中日期
                NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x93b8eb]};
                NSString *dayText = self.xTitleArray[nowPoint];
                
//                if (dayText.length > 6) {
//                    dayText = [dayText substringFromIndex:5];
//                }
                
                CGRect textRect = [self rectOfNSString:dayText attribute:attribute];

                    CGContextSetFillColorWithColor(context, [UIColor colorWithRGBHex:0x93b8eb].CGColor);
                    CGContextFillRect(context, CGRectMake(selectPoint.x-textRect.size.width/2.f-2, self.height-textRect.size.height-1, textRect.size.width+6, textRect.size.height + 4));
                
                  CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                  CGContextFillRect(context, CGRectMake(selectPoint.x-textRect.size.width/2.f-1, self.height-textRect.size.height, textRect.size.width+4, textRect.size.height-1));
                
                    [dayText drawInRect:CGRectMake(selectPoint.x-textRect.size.width/2.f + 2,self.height-textRect.size.height-1, textRect.size.width, textRect.size.height) withAttributes:attribute];
                
                //贴现率的label设置
                [self selectPoint:selectPoint xText:dayText yText:num];
                
            }
        }
    }
    
    
    
}
    

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}


-(void)drawYingyinRect:(CGRect)rect withPoints:(NSArray*)arr index:(NSInteger)index
{
    double height = rect.size.height;
    // height = height/_zoomYScale;
    rect.size.height = height;
    
    
    if  (!arr || [arr count]<=0) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        //先画出要裁剪的区域
        CGPoint firstPoint = [[arr objectAtIndex:0] CGPointValue];
        
        //  firstPoint.y = firstPoint.y/_zoomYScale;
        CGContextMoveToPoint(context, firstPoint.x, rect.size.height);
        CGContextSetLineWidth(context, 2);
        for (int i=0; i<[arr count]; i++) {
            //画中间的区域
            CGPoint point = [[arr objectAtIndex:i] CGPointValue];
            //  point.y = point.y/_zoomYScale;
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGPoint lastPoint = [[arr objectAtIndex:([arr count]-1)] CGPointValue];
        //  lastPoint.y = lastPoint.y/_zoomYScale;
        {
            //画边框
            CGContextAddLineToPoint(context, lastPoint.x, rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width, 0);
            CGContextAddLineToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, rect.size.height);
        }
        CGContextClosePath(context);
        CGContextAddRect(context, CGContextGetClipBoundingBox(context));
        CGContextEOClip(context);
        //裁剪
        CGContextMoveToPoint(context, firstPoint.x, 0);
        CGContextAddLineToPoint(context, firstPoint.x, rect.size.height);
        CGContextSetLineWidth(context,rect.size.width*2);
        CGContextReplacePathWithStrokedPath(context);
        CGContextClip(context);
        // 填充渐变
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        if (index == 0) {
            CGFloat colors[] = {
                68/255.0,192/255.0,254/255.0,0.6,
                68/255.0,192/255.0,254/255.0,0.0,
                68/255.0,192/255.0,254/255.0,0.0
                //                255/255.0,0,0,1.0,
                //                255/255.0,0,0,0
            };
            CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(firstPoint.x, 0), CGPointMake(firstPoint.x, rect.size.height), 0);
            CGGradientRelease(gradient);
        }
        else
        {
            CGFloat colors[] = {
                
                239/255.0,0/255.0,180/255.0,0.6,
                239/255.0,0/255.0,180/255.0,0.0,
                239/255.0,0/255.0,180/255.0,0.0
            };
            CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(firstPoint.x, 0), CGPointMake(firstPoint.x, rect.size.height), 0);
            CGGradientRelease(gradient);
        }
    }
    CGContextRestoreGState(context);
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}



// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num {
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}

- (void)selectPoint:(CGPoint)point xText:(NSString *)xText yText:(NSString *)yText{
    if(_delegate && [_delegate respondsToSelector:@selector(returnSelectPoint:xText:yText:)]){
        [_delegate returnSelectPoint:point xText:xText yText:yText];
    }
}

@end


@implementation LinePointView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawDashLine];
}

#define YYStockScrollViewLeftGap 62

#define YYStockLineDayHeight 12
/**
 * 圆点的半径
 */
#define YYStockPointRadius 3



- (void)drawDashLine {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRGBHex:0xACAAA9].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    
    CGFloat x = self.stockScrollView.frame.origin.x + self.selectedPoint.x - self.stockScrollView.contentOffset.x;
    
    //绘制横线
    CGContextMoveToPoint(ctx, self.stockScrollView.frame.origin.x, self.stockScrollView.frame.origin.y + self.selectedPoint.y);
    CGContextAddLineToPoint(ctx, self.stockScrollView.frame.origin.x + self.stockScrollView.frame.size.width, self.stockScrollView.frame.origin.y + self.selectedPoint.y);
    
    //绘制竖线
    CGContextMoveToPoint(ctx, x, self.stockScrollView.frame.origin.y);
    CGContextAddLineToPoint(ctx, x, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - YYStockLineDayHeight/2.f);
    CGContextStrokePath(ctx);
    
    //绘制交叉圆点
    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRGBHex:0xE74C3C].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGBHex:0xffffff].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextAddArc(ctx, x, self.stockScrollView.frame.origin.y + self.selectedPoint.y, YYStockPointRadius, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //绘制选中日期
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0xffffff]};
    NSString *dayText = [self timeDate];
    CGRect textRect = [self rectOfNSString:dayText attribute:attribute];
    
    if (x + textRect.size.width/2.f + 2 > CGRectGetMaxX(self.stockScrollView.frame)) {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGBHex:0x659EE0].CGColor);
        CGContextFillRect(ctx, CGRectMake(CGRectGetMaxX(self.stockScrollView.frame) - 4 - textRect.size.width, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - YYStockLineDayHeight, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(CGRectGetMaxX(self.stockScrollView.frame) - 4 - textRect.size.width + 2, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - YYStockLineDayHeight + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGBHex:0x659EE0].CGColor);
        CGContextFillRect(ctx, CGRectMake(x-textRect.size.width/2.f, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - YYStockLineDayHeight, textRect.size.width + 4, textRect.size.height + 4));
        [dayText drawInRect:CGRectMake(x-textRect.size.width/2.f + 2, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height - YYStockLineDayHeight + 2, textRect.size.width, textRect.size.height) withAttributes:attribute];
    }
    
    //绘制选中贴现率
    NSString *priceText = self.percent;
    CGRect priceRect = [self rectOfNSString:priceText attribute:attribute];
    priceRect  =  CGRectMake(0, 0, priceRect.size.width, 10.7);
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGBHex:0x659EE0].CGColor);
    CGContextFillRect(ctx, CGRectMake(YYStockScrollViewLeftGap - priceRect.size.width - 4, self.stockScrollView.frame.origin.y + self.selectedPoint.y - priceRect.size.height/2.f - 2, priceRect.size.width + 4, priceRect.size.height + 4));
    //    [priceText drawInRect:CGRectMake(YYStockScrollViewLeftGap - priceRect.size.width - 4 + 2, self.stockScrollView.frame.origin.y + self.selectedPoint.y - priceRect.size.height/2.f, priceRect.size.width, priceRect.size.height) withAttributes:attribute];
    
    [priceText drawInRect:CGRectMake(YYStockScrollViewLeftGap - priceRect.size.width - 4 + 2, self.stockScrollView.frame.origin.y + self.selectedPoint.y - priceRect.size.height/2.f, priceRect.size.width, priceRect.size.height) withAttributes:attribute];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}



@end