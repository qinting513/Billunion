//
//  AppDelegate.m
//  PCStock
//
//  Created by Waki on 2016/12/26.
//  Copyright © 2016年 JM. All rights reserved.
//


static NSString *appKey = @"a48ad1ab53a069903f30e49b";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

#import "AppDelegate.h"
#import "TabbarController.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "IQKeyboardManager.h"
#import "TradeNewsModel.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置Log输出
    NSLog(@"%@",NSHomeDirectory());
#if DEBUG
    [JMLog setLogParam:JM_LOG_LEVEL_DEBUG output:JM_LOG_OUTPUT_CONSOLE];
#else
    [JMLog setLogParam:JM_LOG_LEVEL_DEBUG output:JM_LOG_OUTPUT_FILE];
#endif
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"network" ofType:@"cer"];
    DEBUGLOG(@"network.cer：%@", cerPath);
    
    [self initJPUSHWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    DEBUGLOG(@"%@",[Config getIPAddress]);
//    [self setupLoginViewController];
    self.window.rootViewController = [[TabbarController alloc] init];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";

    return YES;
}

-(void)tradeNewsNotificationWithTitle:(NSString *)title content:(NSString *)content{

        NSMutableArray *array =  [NSMutableArray arrayWithArray:[TradeNewsModel findAll]];
        while (array.count > 50) {
            TradeNewsModel *model =  array.firstObject;
            [model deleteObject];
            [array removeObject:model];
        }
        TradeNewsModel *m = [[TradeNewsModel alloc]init];
        m.Title = title;
        m.Content = content;
        m.Title =  title;
//    @"rangType：广播范围,1为指定交易用户，2为某类交易用户，3为全部交易用户,当广播范围为1时，则对应具体的终端用户ID";
        m.isNotRead = YES;
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"YYYY-MM-dd hh:mm:ss";
        m.CreateTime = [format stringFromDate:[NSDate date]];
        [m saveOrUpdate];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRADE_NOTIFICATION object:nil];
}

- (void)setupLoginViewController{
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    nav.navigationBar.tintColor = nav.navigationBar.barTintColor = [UIColor colorWithRGBHex:0x1a2d44];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.window.rootViewController = nav;
}

- (void)initJPUSHWithLaunchOptions:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 获取IDF
    NSString *advertisiogId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // init Push
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisiogId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)JPUSHCallAlias:(id)respones{
  
}

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#pragma mark - JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        
//        [rootViewController addNotificationCount];
//        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
//        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}


//自定义的消息，不经过苹果服务器
- (void)networkDidReceiveMessage:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
//    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
   // NSDictionary *extra = [userInfo valueForKey:@"extras"];
    [self tradeNewsNotificationWithTitle:content content:content];
    
    [JPUSHService handleRemoteNotification:userInfo];
    [Hud showTipsText:@"你有新的消息，请注意查收！"];
    NSLog(@"接受到pushMessage:%@",content);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
}


//当app在前台时，接收到的通知，通过苹果服务器
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];                 // 推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];    // badge数量
    NSString *sound = [aps valueForKey:@"sound"];                   // 播放的声音
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"];  // 服务端中Extras字段，key是自己定义的
    NSLog(@"\nAppDelegate:\ncontent =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
     [Hud showTipsText:@"你有新的消息，请注意查收！"];
     [self tradeNewsNotificationWithTitle:content content:content];
    
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
