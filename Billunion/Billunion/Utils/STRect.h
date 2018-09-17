//
//  STRect.h
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  将像素frame转换实际frame
 *
 *  @param x      像素x
 *  @param y      像素y
 *  @param width  像素宽
 *  @param height 像素高
 *
 *  @return CGRect对象
 */
#define STRect(x,y,width,height)  [STRect returnSelfFrameWork:CGRectMake(x, y, width, height)]

/**
 *  获取实际x或宽度
 *
 *  @param x 像素x or 像素width
 *
 *  @return 实际尺寸
 */
#define STRealX(pixelX) [STRect returnRealWidthFromPixel:pixelX]

/**
 *  获取实际y或高度
 *
 *  @param y 像素y or 像素height
 *
 *  @return 实际尺寸
 */
#define STRealY(pixelY) [STRect returnRealHeightFromPixel:pixelY]

/**
 *  获取像素x或宽度
 *
 *  @param x 实际x or Width
 *
 *  @return 像素值
 */
#define STPixelX(realX) [STRect returnPixelWidth:realX]

/**
 *  获取像Y或素高度
 *
 *  @param y 实际y or Height
 *
 *  @return 像素值
 */
#define STPixelY(realY) [STRect returnPixelHeight:realY]

@interface STRect : NSObject

+ (CGRect)returnSelfFrameWork:(CGRect)frame;
+ (CGFloat)returnPixelWidth:(CGFloat)realX;
+ (CGFloat)returnPixelHeight:(CGFloat)realY;
+ (CGFloat)returnRealWidthFromPixel:(CGFloat)pixelX;
+ (CGFloat)returnRealHeightFromPixel:(CGFloat)pixelY;

//传入适配6的frame，转换各个版本的frame
#define WidthScale(a) a * WIDTH / 375
#define HeightScale(a) a * HEIGHT / 667
#define CGRectMakeScale(x, y, width, height) CGRectMake(WidthScale(x), HeightScale(y), WidthScale(width), HeightScale(height))


@end
