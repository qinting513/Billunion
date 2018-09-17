//
//  HeadView.h
//  Billunion
//
//  Created by QT on 17/2/17.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadViewBrowsePhotoBlock)(NSArray *imgs, NSInteger index);

@interface HeadView : UIView

/** 要展示的图片的数组 */
@property (nonatomic,strong)NSArray *imgs;

-(instancetype)initWithFrame:(CGRect)frame imgs:(NSArray *)imgs;

@property (nonatomic,copy) HeadViewBrowsePhotoBlock  headViewBrowsePhotoBlock;

@end
