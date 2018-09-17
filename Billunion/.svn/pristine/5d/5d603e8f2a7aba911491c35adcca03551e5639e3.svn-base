//
//  CalloutView.m
//  Billunion
//
//  Created by QT on 2017/3/30.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "CalloutView.h"
#import "MapModel.h"

@interface CalloutView ()
//@property (nonatomic,assign) BOOL isHaveDetail;
@property (nonatomic,strong) UIImageView *iconImageView;
@end

@implementation CalloutView

-(instancetype)initWithFrame:(CGRect)frame isHaveDetail:(BOOL)isHaveDetail{
    if (self = [super initWithFrame:frame]) {
    
//        self.isHaveDetail = isHaveDetail;
        
        self.titleLabel = [UILabel labelWithText:@"" fontSize:14 textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        self.amountLabel = [UILabel labelWithText:@"" fontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.amountLabel];
        self.distanceLabel = [UILabel labelWithText:@"" fontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentLeft];
        [self addSubview:self.distanceLabel];
        
        self.maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.maskBtn.backgroundColor = [UIColor clearColor];
        self.maskBtn.frame = self.frame;
        [self addSubview:self.maskBtn];
        
        self.iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"details"]];
        self.iconImageView.hidden = !isHaveDetail;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];

        [self layoutAllSubViews];
    }
    return self;
}

-(void)layoutAllSubViews{
 
    CGFloat left = self.iconImageView.hidden ? 10 : 30;
    CGFloat right = 10;
    CGFloat labelH = 16;
    CGFloat top =  (self.height - 3*labelH - 6) / 4.0;
    self.titleLabel.sd_layout.topSpaceToView(self,top).leftSpaceToView(self,left).rightSpaceToView(self,right).heightIs(labelH);
   self.amountLabel.sd_layout.topSpaceToView(self.titleLabel,top).leftSpaceToView(self,left).rightSpaceToView(self,right).heightIs(labelH);
   self.distanceLabel.sd_layout.topSpaceToView(self.amountLabel,top).leftSpaceToView(self,left).rightSpaceToView(self,right).heightIs(labelH);
    self.iconImageView.sd_layout.leftSpaceToView(self,4).widthIs(22).heightIs(22).centerYIs( (self.height - 6)/2.0);
}

-(void)setMapModel:(MapModel *)mapModel{
    _mapModel = mapModel;
    self.titleLabel.text = mapModel.Remarks;
    self.amountLabel.text = [NSString stringWithFormat:@"金额(万):%.2f   贴现率:%.3f%%",
                             mapModel.Amount.floatValue/10000.0,
                             mapModel.DiscountRate.floatValue];
    self.distanceLabel.text = mapModel.distanceStr;
}

@end
