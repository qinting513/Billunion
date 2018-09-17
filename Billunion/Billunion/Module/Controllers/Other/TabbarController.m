//
//  TabbarController.m
//  PCStock
//
//  Created by Waki on 2016/12/27.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "TabbarController.h"
#import "HomeViewController.h"
#import "SellViewController.h"
#import "BuyViewController.h"
#import "BaseNavViewController.h"
#import "LoginViewController.h"
#import "UITabBarController+Location.h"

@interface TabbarController ()<UITabBarControllerDelegate>
@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.barTintColor = [UIColor colorWithRGBHex:0x1a2d44];
    [self setupControllers];
    // 开始定位
    [self setupLocation];
}

- (void)setupControllers{
    NSArray *viewControllers =  @[NSStringFromClass([HomeViewController class]),
                                  NSStringFromClass([BuyViewController class]),
                                  NSStringFromClass([SellViewController class])];
    NSArray *titleArray = @[NSLocalizedString(@"Home", nil),
                            NSLocalizedString(@"MyBuy", nil),
                            NSLocalizedString(@"MySell", nil)
                            ];
    NSArray * selImages  = @[@"home",@"buying",@"seller"];
    NSArray * nalImages =  @[@"home_pr",@"buying_pr",@"seller_pr"];
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = [[NSClassFromString(viewControllers[i]) alloc] init];
        [self addChildController:vc title:titleArray[i] imageStr:nalImages[i] selectedImage:selImages[i]];
    }

}

- (void)addChildController:(UIViewController *)childController title:(NSString *)title imageStr:(NSString *)imageStr selectedImage:(NSString *)selectedImage
{
    childController.title = title;
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
   // childController.view.backgroundColor = MainColor;
    //图片
    UIImage *normalImage   = [[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedIamge = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:normalImage  selectedImage:selectedIamge];
    
    // 字体样式
    [childController.tabBarItem setTitleTextAttributes: @{ NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"ffffff" andAlpha:0.8] } forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes: @{ NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    //nav
    BaseNavViewController *nav = [[BaseNavViewController alloc] initWithRootViewController:childController];
    nav.navigationBar.barTintColor = [UIColor colorWithRGBHex:0x1a2d44];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self addChildViewController:nav];
}


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
   BaseNavViewController *nav = (BaseNavViewController*)viewController;
    if ([nav.viewControllers.firstObject isKindOfClass:[HomeViewController class]]) {
        return YES;
    }
    if(![Tools isUserLogin] ){
        LoginViewController *loginVc = [LoginViewController new];
        loginVc.isVistorPresent = YES;
         __weak LoginViewController *weakVc = loginVc;
        loginVc.loginSuccessBlock = ^{
            [weakVc dismissViewControllerAnimated:NO completion:nil];
            if([nav.viewControllers.firstObject isKindOfClass:[BuyViewController class]]){
               tabBarController.selectedIndex = 1;
            }else{
               tabBarController.selectedIndex = 2;
            }
        };
        BaseNavViewController *baseVC = [[BaseNavViewController alloc]initWithRootViewController:loginVc];
        [viewController presentViewController:baseVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
