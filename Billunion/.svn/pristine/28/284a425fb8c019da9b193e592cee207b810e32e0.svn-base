//
//  BuyerInfoCell.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyerInfoCell.h"

@implementation BuyerInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = MainColor;
        
        self.titleLabel = [UILabel labelWithText:@"" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [UILabel labelWithText:@"" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.contentLabel];
        
        CGFloat top = (self.height - 13.0)*0.5;
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,top).widthIs(80);
        
        self.contentLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.titleLabel,0).bottomSpaceToView(self.contentView,top).rightSpaceToView(self.contentView,10);
    }
    return self;
}

@end
