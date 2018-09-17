//
//  MqttControl.m
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MqttControl.h"
#import "HomeViewController.h"
#import "MQTTKit.h"
#import "MBProgressHUD.h"
#import "HomeAlertViews.h"
#import "AppDelegate.h"
#import "Message.h"


@interface MqttControl ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView; //!< TableView
@property (nonatomic, strong) UISwitch *switchButton; //!< 服务开启按钮
@property (nonatomic, strong) HomeAlertViews *homeAlertView; //!< 相关AlertView
@property (nonatomic, strong) MBProgressHUD *hud; //!< 提示框

@property (nonatomic, strong) MQTTClient *client; //!< 客户端对象
@property (nonatomic, strong) NSString *hostIP; //!< 服务器IP地址
@property (nonatomic, strong) NSString *hostPort; //!< 服务器端口号
@property (nonatomic, strong) NSString *hostAddress; //!< 服务器IP地址 + 端口号
@property (nonatomic, assign) NSString *serviceState; //!< 服务开启状态

@property (nonatomic, strong) NSManagedObjectContext *context; //!< Core Data 上下文

@end


@implementation MqttControl



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupMqtt];
    }
    return self;
}

- (void)setupMqtt{
    
    [self initHomeAlert];
    [self setupMessageHandler];
    
    // 默认服务是关闭状态
    _serviceState = @"Service_Off";
    // 默认服务器IP地址为空
    _hostIP = @"";
    _hostPort = @"";
    _hostAddress = @"无";
    [self openAction:YES];
}


#pragma mark - Initialization

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        _switchButton.on = NO;
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

- (void)initHomeAlert {
    _homeAlertView = [[HomeAlertViews alloc] init];
    _homeAlertView.configHostAlert.delegate = self;
    _homeAlertView.sureAlert.delegate = self;
    _homeAlertView.ipTextField.delegate = self;
}

//// 获得 NSManagedObjectContext 对象
//- (NSManagedObjectContext *)context {
//    if (!_context) {
//        AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
////        _context = appdelegate.managedObjectContext;
//    }
//    return _context;
//}


#pragma mark - HUD

- (void)showHUDWithText:(NSString *)text {
    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _hud.label.text = text;
    
    UIImage *image = [UIImage imageNamed:@"37x-Checkmark.png"];
    UIImageView *checkmarkView = [[UIImageView alloc] initWithImage:image];
    _hud.customView = checkmarkView;
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}


#pragma mark - Client & MessageHandler

// 获取客户端对象
- (MQTTClient *)client {
    if (!_client) {
        NSString *clientID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        //        NSLog(@"%@", clientID);
        _client = [[MQTTClient alloc] initWithClientId:clientID];
    }
    return _client;
}

// 设置消息处理
- (void)setupMessageHandler {
    
    __weak typeof(self) sf = self;
    [self.client setMessageHandler:^(MQTTMessage *message) {
        NSString *content = message.payloadString;
        //        NSLog(@"text --->> %@",content);
        
        // 存入数据库
        [sf addMessageToDBWithContent:content];
        
        
        UIAlertView *messageReceivedAlert = [[UIAlertView alloc] initWithTitle:@"接收到新消息"
                                                                       message:content
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:@"确定", nil];
        // 主线程弹框
        dispatch_async(dispatch_get_main_queue(), ^{
            [messageReceivedAlert show];
        });
        
    }];
}


#pragma mark - Connect / Disconnect

// 连接服务器
- (void)connectToHost {
    
    [self showHUDWithText:@"连接中..."];
    
    // 创建定时器，控制请求时长
    NSTimer *connectTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(connectTimeoutAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectTimer forMode:NSDefaultRunLoopMode];
    
    // 异步连接服务器
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 设置连接到服务器的端口
        self.client.port = _hostPort.intValue;
        self.client.clientID = @"mac_ios";
        // 开始连接
        [self.client connectToHost:_hostIP completionHandler:^(MQTTConnectionReturnCode code) {
            // 连接成功
            if (code == ConnectionAccepted) {
                
                [self.client subscribe:@"bill_topic_test" withCompletionHandler:^(NSArray *grantedQos) {
                    
                }];
                // 清空已订阅列表
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"subscribedTopics"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _serviceState = @"Service_ON";
                
                // 更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 移除定时器
                    [connectTimer invalidate];
                    
                    // 显示服务器IP
                    NSIndexPath *addressIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [_tableView reloadRowsAtIndexPaths:@[addressIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    // 转换为 CustomView 模式
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.label.text = @"连接成功";
                    sleep(1);
                    [self hideHUD];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHUD];
                    [self.switchButton setOn:NO animated:YES];
                    [_homeAlertView.failedConnectAlert show];
                });
            }
        }];
        
    });
    
}

// 断开服务器连接
- (void)disconnectToHost {
    
    [self showHUDWithText:@"断开连接中..."];
    
    // 创建定时器，控制请求时长
    NSTimer *disconnectTimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(disconnectTimeoutAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:disconnectTimer forMode:NSDefaultRunLoopMode];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
            if (code == ConnectionAccepted) {
                
                // 清空已订阅列表
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"subscribedTopics"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _serviceState = @"Service_Off";
                
                // 更新 UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 移除定时器
                    [disconnectTimer invalidate];
                    
                    // 重置服务器
                    _hostIP = @"";
                    _hostPort = @"";
                    _hostAddress = @"无";
                    NSIndexPath *addressIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [_tableView reloadRowsAtIndexPaths:@[addressIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    //转换为 CustomView 模式
                    _hud.mode = MBProgressHUDModeCustomView;
                    _hud.label.text = @"断开连接成功";
                    sleep(1);
                    [self hideHUD];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHUD];
                    [self.switchButton setOn:YES animated:YES];
                    [_homeAlertView.failedDisconnectAlert show];
                });
            }
        }];
        
    });
}


#pragma mark - Actions
// 滑动开关触发动作
- (void)openAction:(BOOL)open {
    if (open) {
        [_homeAlertView.configHostAlert show];
    } else {
        [_homeAlertView.sureAlert show];
    }
}

// 连接服务器超时触发动作
- (void)connectTimeoutAction {
    [self hideHUD];
    [self.switchButton setOn:NO animated:YES];
    [_homeAlertView.wrongAddressAlert show];
}

// 断开服务器超时触发动作
- (void)disconnectTimeoutAction {
    [self hideHUD];
    [self.switchButton setOn:YES animated:YES];
    [_homeAlertView.failedDisconnectAlert show];
}


#pragma mark - Core Data

- (void)addMessageToDBWithContent:(NSString *)content {
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:self.context];
    
    message.content = content;
    message.date = [NSDate date];
    message.type = @"接收";
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"存储消息错误，ERROR：%@",error);
    }
    
}


#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // 键盘隐藏
    
    return YES;
}


#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _homeAlertView.configHostAlert) {
        
        switch (buttonIndex) {
                // 点击取消，则不开启服务
            case 0:
                [self.switchButton setOn:NO animated:YES];
                _hostIP = @"";
                _hostPort = @"";
                _hostAddress = @"无";
                break;
                // 点击确定，则尝试连接服务器
            case 1:
                // 隐藏键盘
                [[alertView textFieldAtIndex:0] resignFirstResponder];
                
                _hostIP = _homeAlertView.ipTextField.text;
                _hostPort = _homeAlertView.portTextField.text;
                
                // 确保填写的IP非空才连接
                if ([_hostIP isEqualToString:@""] || [_hostPort isEqualToString:@""]) {
                    [self.switchButton setOn:NO animated:YES];
                    _hostIP = @"";
                    _hostPort = @"";
                    _hostAddress = @"无";
                } else {
                    [self connectToHost];
                }
                
                break;
                
        }
        
    } else if (alertView == _homeAlertView.sureAlert) {
        
        switch (buttonIndex) {
                // 点击取消，则不关闭服务
            case 0:
                [self.switchButton setOn:YES animated:YES];
                break;
                // 点击确定，则尝试断开服务器连接
            case 1:
                [self disconnectToHost];
                break;
                
        }
        
    }
    
}


@end
