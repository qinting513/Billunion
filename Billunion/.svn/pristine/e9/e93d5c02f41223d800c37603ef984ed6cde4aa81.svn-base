//
//  LocationViewModel.m
//  Billunion
//
//  Created by QT on 17/2/16.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "LocationViewModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define DefaultLocationTimeout  6

@interface LocationViewModel()<UIAlertViewDelegate>
/** 定位 */
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@end

@implementation LocationViewModel


+ (LocationViewModel *)shareInstance{
    static LocationViewModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        [AMapServices sharedServices].apiKey = @"621bd5612c3b7735fd771f2152619a09";
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            NSLog(@"没有权限，引导用户去开启定位");
            [[[UIAlertView alloc]initWithTitle:@"请打开定位功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定",nil] show];
        }
    });
    return instance;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

-(AMapLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setLocationTimeout:DefaultLocationTimeout];
    }
    return _locationManager;
}

-(void)getCurrentCityCompletionBlock:(void(^)(NSString *address,NSString *city))block{
    [Hud showActivityIndicator];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
     {
         [Hud  hide];
         if (error)
         {
             NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
             if (error.code == AMapLocationErrorLocateFailed)
             {
                 return;
             }
         }
         //  获取到定位点
         if (location)
         {
             NSLog(@"定位结果==== %@",regeocode);
            !block ?: block(regeocode.formattedAddress,regeocode.city);
            
         }
     }];

}

@end
