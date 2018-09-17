//
//  BuyerInfoHeadView.h
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailBtnClickBlock)(BOOL isDetail);

@interface BuyerInfoHeadView : UIView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *detailBtn;

@property (nonatomic,copy) DetailBtnClickBlock detailBtnClickBlock;

-(instancetype)initWith:(BOOL)isDetail;

@end
