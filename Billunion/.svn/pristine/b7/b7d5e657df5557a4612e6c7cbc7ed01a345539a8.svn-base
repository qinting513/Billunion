
//
//  STRect.m
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "STRect.h"

@implementation STRect

+(CGRect)returnSelfFrameWork:(CGRect)frame
{
    return CGRectMake(frame.origin.x/2*WIDTH/375.0, frame.origin.y/2*HEIGHT/667.0, frame.size.width/2*WIDTH/375.0, frame.size.height/2*HEIGHT/667.0);
}

+ (CGFloat)returnPixelWidth:(CGFloat)realX
{
    return realX*2*375.0/WIDTH;
}

+ (CGFloat)returnPixelHeight:(CGFloat)realY
{
    return realY*2*667.0/HEIGHT;
}

+ (CGFloat)returnRealWidthFromPixel:(CGFloat)pixelX
{
    return pixelX*WIDTH/375.0/2;
}

+ (CGFloat)returnRealHeightFromPixel:(CGFloat)pixelY
{
    return pixelY*HEIGHT /667.0/2;
}


@end
