
//
//  YAxisView.m
//  Billunion
//
//  Created by Waki on 2017/1/11.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "YAxisView.h"
#import "KlineViewConfig.h"

@interface YAxisView ()

@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

@end

@implementation YAxisView

- (id)initWithFrame:(CGRect)frame yMax:(CGFloat)yMax yMin:(CGFloat)yMin {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.yMax = yMax;
        self.yMin = yMin;
    }
    return self;
}



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 计算坐标轴的位置以及大小
   // NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
    
    //Y轴
    [self drawLine:context startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, self.frame.size.height-YAxisBottomSpace) lineColor:[UIColor whiteColor] lineWidth:1];
    
    
    NSDictionary *waterAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:9]};
     CGSize labelSize = [@"Y" sizeWithAttributes:waterAttr];
    
//    CGSize waterLabelSize = [@"贴现率" sizeWithAttributes:waterAttr];
//    CGRect waterRect = CGRectMake(self.frame.size.width - 1-5 - waterLabelSize.width, 0,waterLabelSize.width,waterLabelSize.height);
//    [@"贴现率" drawInRect:waterRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
    
    // Label做占据的高度
    CGFloat allLabelHeight = self.frame.size.height - topMargin-YAxisBottomSpace;
    // Label之间的间隙
//    CGFloat labelMargin = (allLabelHeight + labelSize.height - (numberOfYAxisElements + 1) * labelSize.height) / numberOfYAxisElements;
    CGFloat labelMargin = (allLabelHeight - numberOfYAxisElements * labelSize.height) / numberOfYAxisElements;
    
    // 添加Label
    for (int i = 0; i < numberOfYAxisElements + 1; i++) {
        
//        if (i == 0) {
//            continue;
//        }
        CGFloat avgValue = (self.yMax - self.yMin) / numberOfYAxisElements;
        
        // 判断是不是小数
        if ([self isPureFloat:self.yMin + avgValue * i]) {
            CGSize yLabelSize = [[NSString stringWithFormat:@"%.3f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
            
//            CGRect labelFrame = CGRectMake(3, self.frame.size.height - labelSize.height - 5 - labelMargin* i - yLabelSize.height/2, yLabelSize.width, yLabelSize.height);
            
            CGRect labelFrame = CGRectMake(3, self.frame.size.height - YAxisBottomSpace - (yLabelSize.height+labelMargin)*i-yLabelSize.height/2, yLabelSize.width, yLabelSize.height);
            
            [[NSString stringWithFormat:@"%.3f", self.yMin + avgValue * i] drawInRect:labelFrame withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
        }
        else {
            CGSize yLabelSize = [[NSString stringWithFormat:@"%.3f", self.yMin + avgValue * i] sizeWithAttributes:waterAttr];
            CGRect labelFrame = CGRectMake(3, self.frame.size.height - YAxisBottomSpace - (yLabelSize.height+labelMargin)*i-yLabelSize.height/2, yLabelSize.width, yLabelSize.height);
            
            [[NSString stringWithFormat:@"%.3f", self.yMin + avgValue * i] drawInRect:labelFrame withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
        }
        
    }
}

// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num
{
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
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



@end
