//
//  StockImageViewController.m
//  Billunion
//
//  Created by QT on 17/1/17.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockImageViewController.h"
#import "TOCropViewController.h"
#import "ImageSizeCustonConfig.h"

@interface StockImageViewController ()<UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView   *imageView;

@end

@implementation StockImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
         [self setupUI];
    if (!self.image) {
        if (self.imageFromType == ImageFromTypeCamera) {
            [self openCamera];
        }else  if (self.imageFromType == ImageFromTypePhotoLib){
            [self openPhotoLib];
        }
    }
}

-(void)setupUI{
    [self setupBakcButton];
    self.title = @"票据预览";
    self.view.backgroundColor = MainColor;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        _scrollView.contentSize = CGSizeMake(WIDTH, _scrollView.height);
        _scrollView.backgroundColor = MainColor;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.minimumZoomScale = 1;
        [self.view addSubview:_scrollView];
        
    
    UIView *bgView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    [_scrollView addSubview:bgView];
    
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.width-ViewWidth)/2, (bgView.height-ViewHeight)/2, ViewWidth, ViewHeight)];
        _imageView.userInteractionEnabled = YES;
        bgView.tag = 500;
        [bgView addSubview:_imageView];
    
        _imageView.image = self.image;
    
    UIButton *rightBtn = [UIButton buttonWithNormalImage:@"camare" selectImage:@"camare" imageType:btnImgTypeSmall target:self action:@selector(rightBarBtnClick)];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

}

-(void)rightBarBtnClick
{
//    NSLocalizedString(@"ERROR_PLEASE_SELECT", nil)
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [weakSelf openCamera];
    }];
    
//    UIAlertAction *photoLibAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//        [weakSelf openPhotoLib];
//    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
    }];
    
    [vc addAction:cameraAction];
//    [vc addAction:photoLibAction];
    [vc addAction:cancelAction];
    [self presentViewController:vc animated:YES completion:nil];

}

-(void)openCamera
{
    // 打开相机
    SKFCamera *homec = [[SKFCamera alloc] init];
    __weak typeof(self) myself = self;
    homec.fininshcapture = ^(UIImage *ss) {
        if (ss) {
            // NSLog(@"照片存在");
            myself.imageView.image = ss;
            myself.finishShoot(ss,myself.imageType);
        }
    };
    [myself presentViewController:homec animated:NO  completion:nil];
}

- (void)dismiss {
 [self.navigationController popViewControllerAnimated:YES];
}

-(void)openPhotoLib
{
    // 打开相册
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage * image =info[UIImagePickerControllerEditedImage];
        self.imageView.image = image;
         self.finishShoot(image,self.imageType);
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:500];
}




@end
