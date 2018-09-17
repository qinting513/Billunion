//
//  MyProfileCell.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MyProfileCell.h"

@implementation MyProfileCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = MainColor;
        
        self.titleLabel = [UILabel labelWithText:@"" fontSize:15.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [UILabel labelWithText:@"" fontSize:15.0f textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.contentLabel];
        
         self.titleLabel.sd_layout.topEqualToView(self.contentView).leftSpaceToView(self.contentView,15).bottomEqualToView(self.contentView).widthIs(80);

        self.contentLabel.sd_layout.topEqualToView(self.contentView).leftSpaceToView(self.titleLabel,20).bottomEqualToView(self.contentView).rightSpaceToView(self.contentView,10);
    }
    return self;
}

@end
