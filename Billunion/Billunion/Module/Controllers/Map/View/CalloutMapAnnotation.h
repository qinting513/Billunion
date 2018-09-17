//
//  CalloutMapAnnotation.h
//  ZNBC
//
//  Created by 杨晓龙 on 13-4-11.
//  Copyright (c) 2013年 yangxiaolong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@class MapModel;

@interface CalloutMapAnnotation : NSObject<MAAnnotation>


@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) MapModel *mapModel; //callout吹出框要显示的各信息


- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;



@end
