
//
//  LoginViewController.m
//  PCStock
//
//  Created by Waki on 2016/12/28.
//  Copyright © 2016年 JM. All rights reserved.
//

#define verify 120
#define moveHeihtWhenEditing 50
#import "LoginViewController.h"
#import "TabbarController.h"
#import "ResetPwdViewController.h"
#import "LoginViewModel.h"
#import "UIView+HUD.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIView *_bgView;
    int _verifyTime;
    NSTimer * _verifyTimer;
    UIButton *_verifyBtn;
}

@property (nonatomic,strong)NSString *currentPhoneNum;
@property (nonatomic,strong)NSString *currentPwd;
@property (nonatomic,assign)NSInteger tfCount;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
   
    self.tfCount = [Config juddgeFirstLogin] ? 3 : 2;
    [self setupUIWithTextFieldCount:self.tfCount];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingclick)];
    [self.view addGestureRecognizer:tapGesture];
    
    if (self.isVistorPresent) {
        self.visitorBtn.hidden = YES;
        self.dismissBtn.hidden = NO;
    }else{
        self.dismissBtn.hidden = YES;
        self.visitorBtn.hidden = NO;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupUIWithTextFieldCount:(NSInteger)tfCount{
    
    NSArray * placeholders = [Tools getLoginPlaceHolders];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imgView];
    
    NSString *phoneNum = (self.currentPhoneNum != nil) ? self.currentPhoneNum : [Config getMobileNumber];

   _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor colorWithRGBHex:0x252525];
    [self.view addSubview:_bgView];
    
    for (int i = 0; i < tfCount; i++) {
        UITextField *field = [UITextField textFieldWithText:nil clearButtonMode:UITextFieldViewModeWhileEditing placeholder: placeholders[i] font:14 textColor:[UIColor whiteColor]];
        field.delegate = self;
        [field setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
        [field setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        field.tag = 120+i;
        [_bgView addSubview:field];
        
        if (i == 1) {
            field.secureTextEntry = YES;
            field.tintColor = [UIColor blueColor];
        }
        
        if (i>0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.tag = 110+i;
            [_bgView addSubview:lineView];
        }
    }
    
 
    UIButton *loginBtn = [UIButton buttonWithTitle:NSLocalizedString(@"Login", @"") titleFont:15 titleColor:[UIColor whiteColor] target:self action:@selector(loginClick)];
    loginBtn.backgroundColor = [UIColor colorWithRGBHex:0x1c4473];
    [self.view addSubview:loginBtn];
    
    UIButton *resetPwdBtn = [UIButton buttonWithTitle:NSLocalizedString(@"ForgetPassword", @"")  titleFont:14 titleColor:[UIColor colorWithRGBHex:0x2363af] target:self action:@selector(resetPwdClick)];
    [self.view addSubview:resetPwdBtn];
    
    imgView.sd_layout.topSpaceToView(self.view,STRealX(147)).leftSpaceToView(self.view,STRealY(174)).widthIs(STRealX(400)).heightIs(STRealY(300));
    
    _bgView.sd_layout.topSpaceToView(imgView,17).leftSpaceToView(self.view,30).rightSpaceToView(self.view,30).heightIs(39*tfCount);
    
    if (tfCount == 3) {
        UIButton *verifyBtn = [UIButton buttonWithTitle:NSLocalizedString(@"GetCode", @"")  titleFont:12 titleColor:[UIColor colorWithRGBHex:0x2363af] target:self action:@selector(verifyClick:)];
        [_bgView addSubview:verifyBtn];
        //验证码按钮
        verifyBtn.sd_layout.bottomEqualToView(_bgView).rightEqualToView(_bgView).widthIs(85).heightIs(_bgView.height/3);
    }
  
    //登陆按钮
    loginBtn.sd_layout.topSpaceToView(_bgView,19).rightEqualToView(_bgView).leftEqualToView(_bgView).heightIs(40);
    loginBtn.sd_cornerRadius = @2;

    resetPwdBtn.sd_layout.topSpaceToView(loginBtn,15).leftEqualToView(loginBtn).heightIs(30).widthIs(100);
    resetPwdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
  
    
    NSString *visitorTitle = NSLocalizedString(@"Visitor", @"");
    _visitorBtn = [UIButton buttonWithTitle:visitorTitle titleFont:14 titleColor:[UIColor colorWithRGBHex:0x2363af]  target:self action:@selector(visitorBtnClick)];
    [self.view addSubview:_visitorBtn];
     _visitorBtn.sd_layout.topSpaceToView(loginBtn,15).rightEqualToView(loginBtn).heightIs(30).widthIs(60);
    
    for (int i = 0; i < tfCount; i++) {
        //textField
        UITextField *field = (UITextField*)[_bgView viewWithTag:120+i];
        CGFloat fieldH = _bgView.height/tfCount;
        CGFloat rightSpace = (i==2) ? 85 : 10;

        if (i == 0) {
            field.text =  phoneNum ;
        }else if (i == 1){
            field.text =  self.currentPwd ;
        }
        
        field.sd_layout.topSpaceToView(_bgView,fieldH*i).leftSpaceToView(_bgView,35/2).rightSpaceToView(_bgView,rightSpace).heightIs(fieldH);
        
        //分割线
        UIView *lineView = [_bgView viewWithTag:110+i];
        if (lineView) {
            lineView.sd_layout.topSpaceToView(_bgView,fieldH*i).leftEqualToView(_bgView).rightEqualToView(_bgView).heightIs(1);
            lineView.backgroundColor = [UIColor colorWithRGBHex:0x333333];
        }
    }
    
//     [self getTextFieldWithTag:120].text  = @"13631228675";
//     [self getTextFieldWithTag:121].text  = @"a12345678";

//     [self getTextFieldWithTag:121].text  = @"123456aa";
    
}


#pragma mark - 结束编辑
- (void)endEditingclick
{
    [self.view endEditing:YES];
}

#pragma  mark - 登陆
- (void)loginClick{
    
   [self endEditingclick];

    NSString *phoneNum          = [self getTextFieldWithTag:120].text;
    NSString *password          = [self getTextFieldWithTag:121].text;
    NSString *validationCode    = [self getTextFieldWithTag:122].text;
    
    if (phoneNum.length > 0) {
        self.currentPhoneNum = phoneNum;
    }
    if (password.length > 0) {
        self.currentPwd = password;
    }
    
    if ( ![Config judgeHasAccountWith:phoneNum] && self.tfCount == 2){
        [self.view showWarning:@"首次登录,需要输入验证码!"];
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setupUIWithTextFieldCount:3];
        self.tfCount = 3;
        return ;
    }
    
//    //报价专用账号 1 银行 2 非银行金融机构 3 工商企业
//    phoneNum = @"13600000010";     //51550   CompanyType 2
//    password = @"123";
    
//    phoneNum = @"13600000008";     //10079 4
//    password = @"123";

//    phoneNum = @"13600000006";     //10079
//    password = @"123";
////    
//    phoneNum = @"13600000018";  //10078
//    password = @"123";
    
//    phoneNum = @"13600000090";     //1097   CompanyType 1
//    password = @"123";

    validationCode = [Config judgeHasAccountWith:phoneNum] ? @"1234" : validationCode;
    
//    //真正的登录逻辑用这注释部分
     __weak typeof(self) weakSelf = self;
    [LoginViewModel judgeLoginWithText1:phoneNum
                                  text2:password
                                  text3:validationCode
                         firstLoginFlag:[Config judgeHasAccountWith:phoneNum]
                                  blobk:^(BOOL isOk, NSString *alertStr) {
                                      if (isOk) {
                     [Hud showProgress:MBProgressHUDModeIndeterminate text:@"登录中..."];
                      [LoginViewModel loginWithUserName:phoneNum
                                               password:password
                                         validationCode:validationCode
                                         firstLoginFlag:[Config judgeHasAccountWith:phoneNum]
                                            handleBlcok:^(BOOL isSuccess,NSString *alert) {
                                    [Hud hide];
                                    if (isSuccess) {
                                         [Config setTags:nil alias:phoneNum];
                                         [Tools saveUserLoginStatus:@"YES"];
                                        if ( weakSelf.loginSuccessBlock && weakSelf.isVistorPresent) {
                                             weakSelf.loginSuccessBlock();
                                        }else{
                                          [weakSelf changeRootViewController];
                                        }
                                        
                                    }else{
                                        [weakSelf.view showWarning:alert];
                                    }
                                    }];
                                          
                          }else{
                              [weakSelf.view showWarning:alertStr];
                          }
        }];

}

- (void)changeRootViewController{
   [UIApplication sharedApplication].keyWindow.rootViewController = [[TabbarController alloc] init];
}

- (UITextField *)getTextFieldWithTag:(NSInteger)tag{
   return  [_bgView viewWithTag:tag];
}

#pragma  mark - 找回密码
- (void)resetPwdClick{
    // NSLog(@"----------- ResetPwdViewController");
    ResetPwdViewController *resetPwdCtl = [[ResetPwdViewController alloc] init];
    resetPwdCtl.resetType = Reset_verify;
    [self.navigationController pushViewController:resetPwdCtl animated:YES];
}

//Get Code
- (void)verifyClick:(UIButton *)button{
    UITextField *field1 = [_bgView viewWithTag:120];
    __weak typeof(self) weakSelf = self;
    [LoginViewModel judgeResetPwdWithText1:field1.text text2:nil withType:Reset_verify blobk:^(BOOL isOk, NSString *alertStr) {
        // 判断是正确的手机号码格式
        if (isOk) {
            [LoginViewModel requestValidateCodeWithMobileNumber:field1.text response:^(NSString *SessionId,NSString *errorStr) {
                if (errorStr) {
                    [weakSelf.view showWarning:errorStr];
                }else{
                    [weakSelf.view showWarning:NSLocalizedString(@"ERROR_VERIFY", nil) ];
                    [weakSelf fireTimer:button];
                }
            }];
        }else{
            [weakSelf.view showWarning:alertStr];
            return ;
        }
    }];
    
}

-(void)fireTimer:(UIButton *)button
{
    _verifyTime = verify;
//    [self endEditingclick];
    _verifyBtn = button;
    [self unClick:button];
    _verifyTimer=  [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_verifyTimer forMode:NSRunLoopCommonModes];
    [_verifyTimer fire];
}

- (void)unClick:(UIButton *)button{
    button.userInteractionEnabled = NO;
    button.alpha = 0.4;
    [button setImage:nil forState:UIControlStateNormal];
}

- (void)resumeClick:(UIButton *)button{
    button.userInteractionEnabled = YES;
    button.alpha = 1.0;
    [button setTitle:NSLocalizedString(@"GetCode", @"") forState:UIControlStateNormal];
}

#pragma mark - 验证码倒计时
- (void)timeOut{
    _verifyTime--;
    [_verifyBtn setTitle:[NSString stringWithFormat:@"%d",_verifyTime] forState:UIControlStateNormal];
//    [_verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (_verifyTime == 0) {
        [_verifyTimer invalidate];
        _verifyTime = verify;
        [self resumeClick:_verifyBtn];
    }
}


- (void)visitorBtnClick{
    [Tools saveUserLoginStatus:@"NO"];
    [self changeRootViewController];
}

- (void)dismissBtnClick{
    if (self.dismissBlock) {
        self.dismissBlock();
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(UIButton *)dismissBtn
{
    if (!_dismissBtn) {
        _dismissBtn =[UIButton buttonWithNormalImage:@"drop-down" selectImage:nil imageType:btnImgTypeSmall target:self action:@selector(dismissBtnClick)];
        [_dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _dismissBtn.frame = CGRectMake(WIDTH-50, 30, 50, 30);
        [self.view addSubview:_dismissBtn];;;
    }
    return _dismissBtn;
}

@end
