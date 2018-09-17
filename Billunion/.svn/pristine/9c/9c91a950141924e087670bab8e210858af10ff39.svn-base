//
//  StockImageViewController.h
//  Billunion
//
//  Created by QT on 17/1/17.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseViewController.h"
/** 自定义相机的库 */
#import "SKFCamera.h"

typedef NS_ENUM(NSInteger,ImageFromType) {
    ImageFromTypeCamera,
    ImageFromTypePhotoLib
};

typedef NS_ENUM(NSInteger,ImageType) {
    ImageTypeFront,
    ImageTypeBack
};


@interface StockImageViewController : BaseViewController

@property (nonatomic,assign) fininshcapture fininshcapture;
@property (nonatomic,assign) ImageFromType imageFromType;
@property (nonatomic,assign) ImageType imageType;

@property (nonatomic,copy) void(^finishShoot)(UIImage *image, ImageType imageType);
@property (nonatomic ,strong) UIImage *image;

@end
