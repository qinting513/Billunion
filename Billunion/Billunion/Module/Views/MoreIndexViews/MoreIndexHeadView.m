//
//  MoreIndexHeadView.m
//  Billunion
//
//  Created by QT on 17/1/4.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreIndexHeadView.h"

@interface MoreIndexHeadView ()

/**  平均值 */
@property (nonatomic,strong)UILabel *avgLabel;
/** 名字 */
@property (nonatomic,strong)UILabel *nameLabel;
/**  上涨点 */
@property (nonatomic,strong)UILabel *upLabel;
/** 下降点 */
@property (nonatomic,strong)UILabel *downLabel;

@property (nonatomic,strong)UIView *blackView;
@end

@implementation MoreIndexHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor colorWithRGBHex:0x161616];
        
        /** create */
        self.avgLabel = [UILabel labelWithText:@"3.84" fontSize:49.5f textColor:[UIColor colorWithRGBHex:0xffffff] alignment:NSTextAlignmentRight];
//        self.avgLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.avgLabel];
        
        self.nameLabel = [UILabel labelWithText:@"政策银行" fontSize:17.5f textColor:[UIColor colorWithRGBHex:0xffffff] alignment:NSTextAlignmentLeft];
        [self addSubview:self.nameLabel];
        
        self.upLabel = [UILabel labelWithText:@"+1.98" fontSize:17.5f textColor:[UIColor colorWithRGBHex:0xffffff] alignment:NSTextAlignmentLeft];
        [self addSubview:self.upLabel];
        
        self.downLabel = [UILabel labelWithText:@"-0.08%" fontSize:17.5f textColor:[UIColor colorWithRGBHex:0xffffff] alignment:NSTextAlignmentLeft];
        [self addSubview:self.downLabel];
        
        self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 8, WIDTH, 8)];
        self.blackView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.blackView];
        
        /** layout */
        CGFloat width = self.frame.size.width*0.5;
    self.avgLabel.sd_layout.topSpaceToView(self,(self.frame.size.height-49.5)*0.5).leftSpaceToView(self,0).widthIs(width).heightIs(49.5);
    
    self.nameLabel.sd_layout.topEqualToView(self.avgLabel).leftSpaceToView(self.avgLabel,37.5).widthIs(width).heightIs(17.5);
    [self.upLabel setSingleLineAutoResizeWithMaxWidth:width*0.5];
    self.upLabel.sd_layout.topSpaceToView(self.nameLabel,19.5).leftEqualToView(self.nameLabel).heightIs(17.5);
            
      self.downLabel.sd_layout.centerYEqualToView(self.upLabel).leftSpaceToView(self.upLabel,15.5).widthIs(width*0.5).heightIs(17.5);
        
    
    }
    return self;
}



@end