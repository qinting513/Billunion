//
//  QTAnnotation.m
//  GaoDe
//
//  Created by QT on 17/2/10.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "CustomPointAnnotation.h"

@implementation CustomPointAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                         mapModel:(MapModel*)mapModel{
    if (self = [super init]) {
        self.coordinate     = coordinate;
        self.mapModel       = mapModel;
    }
    return self;
}


@end
