//
//  UITabBarController+Location.h
//  Billunion
//
//  Created by QT on 2017/4/1.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>


///** 存储当前选中的城市 */
//#define kCurrentCityName  @"kCurrentCityName"
///** 当前城市 */
//#define kCurrentCity [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCityName]
//
///** 存储当前详细地址 */
//#define kDetailAddressName  @"kDetailAddressName"
//#define kDetailAddress [[NSUserDefaults standardUserDefaults] objectForKey:kDetailAddressName]
//
///** 当前城市变化的通知 */
//#define kCurrentCityChangedNotification @"kCurrentCityChangedNotification"

//@import Xcode7之后的新特性, 好处就是不需要到Build Phaze里面去引入类库了
@import CoreLocation;

@interface UITabBarController (Location) <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)setupLocation;

@end
