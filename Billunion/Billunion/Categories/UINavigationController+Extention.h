//
//  UINavigationController+Extention.h
//  Billunion
//
//  Created by QT on 17/1/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extention)

/// 自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *hm_popGestureRecognizer;

@end
