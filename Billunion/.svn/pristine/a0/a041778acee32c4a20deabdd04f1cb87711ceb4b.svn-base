/*!
 @abstract
 作者Github址：https://github.com/wubianxiaoxian
 作者微博 敲代码的树懒
 作者简书地址:http://www.jianshu.com/users/61b9640c876a/latest_articles
 作者Blog地址 http://www.cnblogs.com/sunkaifeng/
 @author   Created by sunkaifeng on  16/1/17
 Copyright © 2016年 孙凯峰. All rights reserved.
 Created by 孙凯峰 on 2016/10/18.
 */

#import "SKFCamera.h"
#import "TOCropViewController.h"
#import "LLSimpleCamera.h"

#import "ImageSizeCustonConfig.h"

@interface SKFCamera ()<TOCropViewControllerDelegate>
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation SKFCamera

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self InitializeCamera];
    
    
    //------------------------JM----------------------------------
    
    for (int i = 0; i < 4; i++) {
        UIView*view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        view.clipsToBounds = YES;
        if (i == 0) {
            view.frame = CGRectMake(0, 0,WIDTH, TopSpace);
        }else if (i == 1){
            view.frame = CGRectMake(0, TopSpace,(WIDTH-ViewWidth)/2,ViewHeight);
        }else if (i == 2){
            view.frame = CGRectMake(WIDTH-(WIDTH-ViewWidth)/2, TopSpace,(WIDTH-ViewWidth)/2, ViewHeight);
        }else{
            view.frame = CGRectMake(0, TopSpace+ViewHeight,WIDTH, HEIGHT-TopSpace-ViewHeight);
        }
        [self.view addSubview:view];
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            lineView2.frame = CGRectMake((WIDTH-ViewWidth)/2-1, TopSpace-1,ViewWidth+2, 1);
        }else if (i == 1){
            lineView2.frame = CGRectMake((WIDTH-ViewWidth)/2-1,0,1,ViewHeight);
        }else if (i == 2){
            lineView2.frame = CGRectMake(0, 0,1, ViewHeight);
        }else{
            lineView2.frame = CGRectMake((WIDTH-ViewWidth)/2-1, 0,ViewWidth+2, 1);
        }
        [view addSubview:lineView2];
    }
    
    
    
    
    //拍照按钮
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius =75 / 2.0f;
    [self.snapButton setImage:[UIImage imageNamed:@"SKFCamera.bundle/cameraButton"] forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    //闪关灯按钮
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.flashButton.tintColor = [UIColor whiteColor];
//     UIImage *image = [UIImage imageNamed:@"SKFCamera.bundle/camera-flash.png"];
    [self.flashButton setImage:[UIImage imageNamed:@"SKFCamera.bundle/camera-flash"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        //摄像头转换按钮
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //        self.switchButton.tintColor = [UIColor whiteColor];
        [self.switchButton setImage:[UIImage imageNamed:@"SKFCamera.bundle/swapButton"] forState:UIControlStateNormal];
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
        //返回按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.backButton setImage:[UIImage imageNamed:@"SKFCamera.bundle/closeButton"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
    }
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // snap button to capture image
    
    //判断前后摄像头是否可用
    
    
    // start the camera
    [self.camera start];
}
#pragma mark   ------------- 初始化相机--------------
-(void)InitializeCamera{
    CGRect screenRect = self.view.frame;
    
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"未获取相机权限";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button
{
    [self.camera togglePosition];
}
-(void)backButtonPressed:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}
#pragma mark   -------------拍照--------------

- (void)snapButtonPressed:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    // 去拍照
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
    
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = self;
            [weakSelf presentViewController:cropController animated:YES completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.camera.view.frame=self.view.frame;
    self.snapButton.frame=CGRectMake((KScreenwidth-KIphoneSize_Widith(75))/2, KScreenheight-KIphoneSize_Widith(90) + 10, KIphoneSize_Widith(75), KIphoneSize_Widith(75));
    self.flashButton.frame=CGRectMake((KScreenwidth-KIphoneSize_Widith(36))/2, 25, KIphoneSize_Widith(36), KIphoneSize_Widith(44));
    self.switchButton.frame=CGRectMake(KScreenwidth-50, KScreenheight-KIphoneSize_Widith(75) + 10, KIphoneSize_Widith(45), KIphoneSize_Widith(45));
    self.backButton.frame=CGRectMake(5, KScreenheight-KIphoneSize_Widith(75) + 10, KIphoneSize_Widith(45), KIphoneSize_Widith(45));
}
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    self.view.alpha = 0;
    self.fininshcapture(image);
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
