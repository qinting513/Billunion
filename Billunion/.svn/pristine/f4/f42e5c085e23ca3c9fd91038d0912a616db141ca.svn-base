//
//  StockAddCell.m
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockAddCell.h"
@interface StockAddCell()<UITextFieldDelegate>
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation StockAddCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
                   indexPath:(NSIndexPath *)indexPath
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.indexPath = indexPath;
        self.backgroundColor = MainColor;
        /** 标题 */
        self.titleLabel = [UILabel labelWithText:@"" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLabel];
        
        /** 输入框 */
        self.inputTF = [UITextField textFieldWithText:@"" clearButtonMode:UITextFieldViewModeWhileEditing placeholder:@"" font:13.0f textColor:[UIColor colorWithRGBHex:0xffffff]];
        self.inputTF.delegate = self;
        [self.contentView addSubview: self.inputTF];
//        [self.inputTF setValue:[UIColor colorWithRGBHex:0x939b9b] forKeyPath:@"_placeholderLabel.textColor"];
//        NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:self.inputTF.placeholder];
//        [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x1a2d44]} range:NSMakeRange(0, self.inputTF.placeholder.length)];
//        field.attributedPlaceholder = att;
        
        /** 单位 万 */
        self.unitLabel = [UILabel labelWithText:@"万" fontSize:13.0f textColor:[UIColor colorWithRGBHex:0x939b9b] alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.unitLabel];
        
        /** 向右箭头 */
        self.rightImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        [self.contentView addSubview:self.rightImgView];
        
        CGFloat top = (self.frame.size.height - 30)/2;
        self.titleLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,top).widthIs(90);
        self.inputTF.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.titleLabel,0).bottomSpaceToView(self.contentView,top).rightSpaceToView(self.contentView,30);
        self.unitLabel.sd_layout.topSpaceToView(self.contentView,top).leftSpaceToView(self.inputTF,0).bottomSpaceToView(self.contentView,top).rightSpaceToView(self.contentView,0);
        self.rightImgView.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.inputTF,0).bottomSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10);
    }
    return self;
}



@end
