//
//  UINavigationController+Extention.m
//  Billunion
//
//  Created by QT on 17/1/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "UINavigationController+Extention.h"

#import <objc/runtime.h>

@interface HMFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation HMFullScreenPopGestureRecognizerDelegate

/** UIView的系统的方法 手势识别的判断 询问一个手势接收者(即这里的UIView)是否应该开始解释执行一个触摸接收事件 */
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //如果是根视图，则返回
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // 如果正在转场动画，取消手势
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    //判断手指移动方向
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end


@implementation UINavigationController (Extention)
+ (void)load {
    /** 在运行时，交换方法 */
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(hm_pushViewController:animated:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)hm_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    /** 从整个交互式的手势数组里找，如果手势没有添加，则添加这个手势到数组里 */
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.hm_popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.hm_popGestureRecognizer];
        
        /** 添加的这个手势替代了系统的 handleNavigationTransition 这个方法 */
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        self.hm_popGestureRecognizer.delegate = [self hm_fullScreenPopGestureRecognizerDelegate];
        [self.hm_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // 禁用系统的交互手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (![self.viewControllers containsObject:viewController]) {
        [self hm_pushViewController:viewController animated:animated];
    }
}

//懒加载
- (HMFullScreenPopGestureRecognizerDelegate *)hm_fullScreenPopGestureRecognizerDelegate {
    HMFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [[HMFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

//懒加载
- (UIPanGestureRecognizer *)hm_popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

@end
