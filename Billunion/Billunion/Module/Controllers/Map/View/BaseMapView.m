//
//  MapView.m
//  Billunion
//
//  Created by QT on 2017/4/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseMapView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation BaseMapView

static BaseMapView *_mapView = nil;

+ (BaseMapView *)shareMapView {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [AMapServices sharedServices].apiKey = kMapKey;
  
                CGRect frame = [[UIScreen mainScreen] bounds];
                _mapView = [[BaseMapView alloc] initWithFrame:CGRectMake(0, 64,
                                                                         frame.size.width,
                                                                         frame.size.height - 64)];
                _mapView.autoresizingMask =
                UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                _mapView.rotateEnabled = NO;
                _mapView.zoomEnabled = YES;
                _mapView.mapType = MAMapTypeStandard;
        });

        return _mapView;
}


//重写allocWithZone保证分配内存alloc相同
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        
        if (_mapView == nil) {
            _mapView = [super allocWithZone:zone];
            return _mapView; // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

//保证copy相同
+ (id)copyWithZone:(NSZone *)zone {
    return _mapView;
}

@end
