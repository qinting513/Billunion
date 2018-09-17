//
//  StockAddController.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockAddController.h"
#import "StockAddCell.h"

#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

#import "StockImageViewController.h"
#import "UIView+HUD.h"

#import "AddressViewController.h"
#import "CalendarViewController.h"

#import "StockAddViewModel.h"
#import "TradeViewModel.h"
#import "CounterPartySearchController.h"

@interface StockAddController ()<UITableViewDataSource,UIScrollViewDelegate,
                                    UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *titles;

@property (nonatomic,strong)NSArray *placeHolders;

@property (nonatomic,strong)NSMutableDictionary *contentDict;

@property (nonatomic,strong)NSString  *detailAddress;

//正面票据图片
@property (nonatomic,strong)UIImage  *frontImage;
//反面票据图片
@property (nonatomic,strong)UIImage  *backImage;

/** 出票日期 */
@property (nonatomic,strong)NSString *startDateStr;
/** 到期日期 */
@property (nonatomic,strong)NSString *endDateStr;
/** 票源城市 */
@property (nonatomic,strong)NSString *selectedCity;
@end

@implementation StockAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"AddStock", nil);
    [self setupBakcButton];
    self.tableView.hidden = NO;
    UIButton *btn = [UIButton buttonWithTitle:NSLocalizedString(@"Sure", nil) titleFont:13
                                        titleColor:[UIColor colorWithRGBHex:0xffffff]
                                        target:self action:@selector(btnClick:)];
    btn.frame = CGRectMake(0, 0, 60, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor  = SeparatorColor;
        _tableView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSArray *)titles
{
    if (_titles == nil) {
        _titles = [Tools getStockAddTitles];
    }
    return _titles;
}

-(NSArray *)placeHolders
{
    if (!_placeHolders) {
        _placeHolders = [Tools getStockAddPlaceHolders];
   
    }
    return _placeHolders;
}

-(NSMutableDictionary *)contentDict
{
    if (!_contentDict) {
        _contentDict = [NSMutableDictionary dictionary];
    }
    return _contentDict;
}

#pragma mark - 确定按钮点击
- (void)btnClick:(UIButton*)sender
{

#warning 图片暂时写死
//    if (!self.frontImage) {
//        self.frontImage = [UIImage imageNamed:@"billImage1"];
//    }
//    if (!self.backImage) {
//        self.backImage = [UIImage imageNamed:@"billImage2"];
//    }

    if (![self checkStockInfo]) {
        return;
    }
   
    [Hud showProgress:MBProgressHUDModeIndeterminate text:@"正在上传..."];

    //参数字典
   __block NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // 群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
 // 正面图片positiveImage  反面图片backImage 其他图片otherImage
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
       [StockAddViewModel uploadImage:self.frontImage imageName:kPositiveImage  progress:^(CGFloat progressValue) {
            
       } response:^(NSString *imageUrl, NSString *errorStr) {
           if (!errorStr) {
               NSLog(@"正面图片上传成功！--------------- ");
               params[@"PositiveImagePath"] = imageUrl;
           }else{
               [Hud showTipsText:errorStr];
           }
            dispatch_group_leave(group);
       }];
       
    });
    
    //  再次入组
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [StockAddViewModel uploadImage:self.backImage imageName:kBackImage  progress:^(CGFloat progressValue) {
    
        } response:^(NSString *imageUrl, NSString *errorStr) {
            if (!errorStr) {
                NSLog(@"反面图片上传成功！--------------- ");
                params[@"BackImagePath"] = imageUrl;
            }else{
                [Hud showTipsText:errorStr];
            }
              dispatch_group_leave(group);
        }];
      
    });
    // 群组结束
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        for (int i = 0; i< self.titles.count; i++) {
            NSIndexPath *indexp = [NSIndexPath indexPathForRow:i inSection:0];
            StockAddCell *cell = [self.tableView cellForRowAtIndexPath:indexp];
            if (i== 0) {
                // 前后去除空格
                params[@"BillNum"] = [cell.inputTF.text stringByTrimmingCharactersInSet:
                                                [NSCharacterSet whitespaceCharacterSet]];
            }else if (i == 1){
                 params[@"Amount"] = [NSNumber numberWithFloat: cell.inputTF.text.floatValue * 10000];
            }else if (i == 2){
              params[@"Acceptor"] = [cell.inputTF.text stringByTrimmingCharactersInSet:
                                                      [NSCharacterSet whitespaceCharacterSet]];;
            }else if (i == 3){
                params[@"ReleaseDate"] = cell.inputTF.text;
            }else if (i == 4){
                params[@"ExpireDate"] = cell.inputTF.text;
            }else if (i == 5){
                params[@"Remarks"] = cell.inputTF.text;
            }else if (i == 6){
                params[@"Address"] = cell.inputTF.text;
            }
        }
        params[@"BillType"] = @1;
        
        __weak typeof(self) weakSelf = self;
        [StockAddViewModel stockAddWithParams:params response:^(BOOL isSucceed, NSString *message) {
            NSLog(@"全部数据上传成功!");
            [Hud hide];
            [weakSelf.view showWarning:message completionBlock:^{
                if (isSucceed) {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
    });
}

/** 检查所有票据信息是否合格 */
-(BOOL)checkStockInfo
{
    for (int i = 0; i< self.titles.count; i++) {
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:i inSection:0];
        StockAddCell *cell = [self.tableView cellForRowAtIndexPath:indexp];
        switch (i) {
            case 0:
                {
                    if (!cell.inputTF.text.mj_isPureInt ||
                        cell.inputTF.text.length != 16 ) {
                        [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_NUM", nil) ];
                        return NO;
                    }
                }
                break;
            case 1:
            {
                if(!cell.inputTF.text.isPureFloat || cell.inputTF.text.floatValue <= 0){
                    [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_AMOUNT", nil) ];
                    return NO;
                }else if (cell.inputTF.text.floatValue > 300 ){
                    [self.view showWarning:@"单张票金额不能大于300万"];
                    return NO;
                }
            }
                break;
            case 2:
                {
                if (cell.inputTF.text.length <= 0 || cell.inputTF.text.mj_isPureInt) {
                    [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_ACCEPTOR", nil) ];
                    return NO;
                }
            }
                break;
                
            case 3:
            case 4:
                {
                    if (!cell.inputTF.hasText) {
                        [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_DATE", nil) ];
                        return NO;
                    }
                }
                break;
    
            case 5:
            case 6:
                {
                    if (!cell.inputTF.hasText) {
                        [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_ADDRESS", nil) ];
                        return NO;
                    }
                }
                break;
            default:
                break;
        }
    }
    if (self.frontImage == nil) {
        [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_FRONT_IMAGE", nil) ];
        return NO;
    }
    if (self.backImage == nil) {
        [self.view showWarning:NSLocalizedString(@"ERROR_STOCK_BACK_IMAGE", nil) ];
        return NO;
    }
     return YES;
}

#pragma  mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        StockAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockAddCell" ];
        if (cell == nil) {
            cell = [[StockAddCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StockAddCell"  indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    cell.titleLabel.text = self.titles[indexPath.row];
    
        if (indexPath.row < 2) {
                cell.inputTF.placeholder = self.placeHolders[indexPath.row];
                cell.inputTF.userInteractionEnabled = YES;
                cell.rightImgView.hidden = YES;
                [cell.inputTF setValue:[UIColor colorWithRGBHex:0x806666] forKeyPath:@"_placeholderLabel.textColor"];
        }else{
                cell.inputTF.placeholder = @"";
                cell.inputTF.userInteractionEnabled = NO;
                cell.rightImgView.hidden = NO;
        }
    
        cell.unitLabel.hidden = YES;
        if (indexPath.row == 1) {
            cell.unitLabel.hidden = NO;
        }
    
        if (indexPath.row == 3 && self.startDateStr.length > 0) {
            cell.inputTF.text = self.startDateStr;
        }
        if (indexPath.row == 4 && self.endDateStr.length > 0) {
            cell.inputTF.text = self.endDateStr;
        }
    
        if (indexPath.row == 5 && self.detailAddress.length > 0) {
            cell.inputTF.text = self.detailAddress;
        }
    
        if (indexPath.row == 6 ) {
            cell.rightImgView.hidden = YES;
            cell.inputTF.text = self.selectedCity;
        }
#warning TODO: 暂时写死

//    if (indexPath.row == 0 ) {
//
//       NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//       NSString *time1 = [[[NSString stringWithFormat:@"%f",time] componentsSeparatedByString:@"."] firstObject];
//       int timeFlag = [[time1 substringFromIndex:(time1.length - 5) ] intValue];
//        cell.inputTF.text = [NSString stringWithFormat:@"%@%d", [Config getMobileNumber],timeFlag];
//    }
//    
//    if (indexPath.row == 2 ) {
//        cell.inputTF.text = @"中国工商银行股份有限公司北京通州支行新华分理处";
//    }
//
//    if (indexPath.row == 1 ) {
//        cell.inputTF.text = [NSString stringWithFormat:@"%d",arc4random() % 300];
//    }
//
//    if (indexPath.row == 3 ) {
//        cell.inputTF.text = @"2017-04-06";
//    }
//    if (indexPath.row == 4 ) {
//        cell.inputTF.text = @"2017-05-09";
//    }

    
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma  mark - 选择图片
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        StockAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectAcceptor:cell.inputTF.text];
    }
    if (indexPath.row == 3 || indexPath.row == 4) {
        [self selectedDate:indexPath];
    }
    
    if (indexPath.row == 5) {
        [self gotoSelectCity];
    }
    if (indexPath.row == 7 || indexPath.row == 8) {
        [self selectedImage:indexPath];
    }
}

- (void)selectAcceptor:(NSString *)currentAcceptor{
        CounterPartySearchController *vc = [[CounterPartySearchController alloc] init];
        vc.currentStr = currentAcceptor;
        vc.searchType = SearchType_Acceptor;
        __weak typeof(self) weakSelf = self;
        vc.finishSelectBlock = ^(id selectObject){
            [weakSelf didSelectAcceptor:selectObject];
        };
        [self.navigationController pushViewController:vc animated:YES];
}

//写入当前的承兑人
- (void)didSelectAcceptor:(id)selectObject{
   StockAddCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.inputTF.text = selectObject;
}


-(void)selectedDate:(NSIndexPath*)indexPath
{
    CalendarViewController *vc = [[CalendarViewController alloc]init];
    vc.startDateStr = self.startDateStr;
    vc.endDateStr = self.endDateStr;
    vc.isStartDate = (indexPath.row == 3);
    __weak typeof(self) weakSelf = self;
    vc.selectedDateBlock = ^(BOOL isStartDate,NSString *dateStr){
        if (isStartDate) {
            weakSelf.startDateStr = dateStr;
        }else{
            weakSelf.endDateStr = dateStr;
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoSelectCity
{
    AddressViewController *controller = [[AddressViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    controller.normalBlock = ^(NSString *selAddress,NSString *selectedCity){
        weakSelf.detailAddress = selAddress;
        weakSelf.selectedCity = selectedCity;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)selectedImage:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7 && self.frontImage) {
        [self pushToStockImageViewControllerWithImageFromType:0 imageType:0 image:self.frontImage];
    }else if (indexPath.row == 8 && self.backImage){
        [self pushToStockImageViewControllerWithImageFromType:0 imageType:0 image:self.backImage];
    }else{
//            NSLocalizedString(@"ERROR_PLEASE_SELECT", nil)
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil
                                message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Camera", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [weakSelf openCamera:indexPath];
        }];
        
//        UIAlertAction *photoLibAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"PhotoAlbum", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
//            [weakSelf openPhotoLib:indexPath];
//        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        }];
        
        [vc addAction:cameraAction];
//        [vc addAction:photoLibAction];
        [vc addAction:cancelAction];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)openCamera:(NSIndexPath *)indexPath
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.view showWarning:NSLocalizedString(@"ERROR_CANT_USE_CAMERA", nil) ];
        return;
    }
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus == AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        [self.view showWarning:NSLocalizedString(@"ERROR_OPEN_CAMERA", nil) ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        });
        
    }
     ImageType type = indexPath.row == 7 ? ImageTypeFront: ImageTypeBack;
    [self pushToStockImageViewControllerWithImageFromType:ImageFromTypeCamera imageType:type image:nil];
}

- (void)pushToStockImageViewControllerWithImageFromType:(ImageFromType)imageFromType imageType:(ImageType)imageType image:(UIImage *)image{
    StockImageViewController *vc = [[StockImageViewController alloc]init];
    vc.imageFromType = imageFromType;
    vc.imageType = imageType;
    vc.image = image;
    __weak typeof(self) weakSelf = self;
    vc.finishShoot = ^(UIImage *finishImage, ImageType imageType){
    
        if (imageType == ImageTypeFront) {
            weakSelf.frontImage = finishImage;
        }else{
            weakSelf.backImage = finishImage;
        }
        
        NSIndexPath *indexp = [NSIndexPath indexPathForRow:(imageType + 7) inSection:0];
        StockAddCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexp];
        cell.inputTF.text = NSLocalizedString(@"HavePicture", nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openPhotoLib:(NSIndexPath *)indexPath
{
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        ImageType type = indexPath.row == 7 ? ImageTypeFront: ImageTypeBack;
         [self pushToStockImageViewControllerWithImageFromType:ImageFromTypePhotoLib imageType:type image:nil];
    }
}


@end
