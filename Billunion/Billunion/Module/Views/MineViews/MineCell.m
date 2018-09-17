//
//  MineCell.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MineCell.h"
@interface MineCell()
@property (nonatomic,strong)UIView *bottomView;
@end

@implementation MineCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor colorWithRGBHex:0xffffff];
        self.backgroundColor = MainColor;
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 2)];
        self.bottomView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview: self.bottomView];
        
    }
    return self;
}

@end
