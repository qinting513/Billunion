//
//  BuyerInfoHeadView.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyerInfoHeadView.h"
@interface BuyerInfoHeadView()

@end

@implementation BuyerInfoHeadView

-(instancetype)initWith:(BOOL)isDetail
{
    if (self = [super init] ) {

        self.backgroundColor = MainColor;
        
        self.titleLabel = [UILabel labelWithText:@"票据信息" fontSize:15.0f textColor:[UIColor colorWithRGBHex:0xffffff] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        CGFloat top = (self.height - 15.0)*0.5;
        self.titleLabel.sd_layout.topSpaceToView(self,top).leftSpaceToView(self,20).bottomSpaceToView(self,top).widthIs(100);
     
        self.detailBtn = [UIButton buttonWithNormalImage:@"pull" selectImage:@"up" imageType:btnImgTypeSmall target:self action:@selector(click)];
        self.detailBtn.selected = isDetail;
        [self  addSubview: self.detailBtn];
        self.detailBtn.sd_layout.centerYEqualToView(self.titleLabel).rightSpaceToView(self,15).widthIs(76/2).heightIs(28);
    }
    return self;
}

-(void)click{

    !self.detailBtnClickBlock ?: self.detailBtnClickBlock(!self.detailBtn.selected);

}

@end
