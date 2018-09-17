
//
//  AddressCell.m
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell()
{
    UILabel *_label;
    UIButton *_addressBtn;
    NSInteger _section;
}


@end
@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    UIView *bgView = self.contentView;
    _label = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [bgView addSubview:_label];
    
    _addressBtn = [self getButtonWithNalImage:@"circle" selImage:@"select" title:NSLocalizedString(@"DefaultAddress", nil) tag:100];
    [bgView addSubview:_addressBtn];

    UIButton *editBtn = [self getButtonWithNalImage:@"edit" selImage:nil title:NSLocalizedString(@"Edit", nil) tag:101];
    [bgView addSubview:editBtn];
    
    UIButton *deleteBtn = [self getButtonWithNalImage:@"delete" selImage:nil title:NSLocalizedString(@"Delete", nil) tag:102];
    [bgView addSubview:deleteBtn];
    
    
    _label.sd_layout.leftSpaceToView(bgView,15).topSpaceToView(bgView,10).widthIs(WIDTH-30).heightIs(20);
    _addressBtn.sd_layout.leftSpaceToView(bgView,7).bottomSpaceToView(bgView,10).widthIs(100).heightIs(20);
    deleteBtn.sd_layout.rightSpaceToView(bgView,15).centerYEqualToView(_addressBtn).widthIs(60).heightIs(30);
    editBtn.sd_layout.rightSpaceToView(deleteBtn,0).centerYEqualToView(_addressBtn).widthIs(60).heightIs(30);

}

- (UIButton *)getButtonWithNalImage:(NSString *)nalImage
                           selImage:(NSString *)selImage
                              title:(NSString *)title
                                tag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithNormalImage:nalImage
                                           selectImage:selImage
                                             imageType:btnImgTypeSmall target:self action:@selector(btnSelect:)];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRGBHex:0x3788e9] forState:UIControlStateSelected];
    if (tag == 100) {
         button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }else{
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
   
    button.titleLabel.font = [UIFont systemFontOfSize:12];
   // button.backgroundColor = [UIColor redColor];
    return button;
}


- (void)btnSelect:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWithButtonIndex: section:)]) {
        [self.delegate didSelectWithButtonIndex:button.tag-100 section:_section];
    }
}


- (void)setCellInfo:(NSString *)address isSelect:(BOOL)isSelect section:(NSInteger)section{
    NSMutableString *MString = [[NSMutableString alloc] init];
    for (NSString *aString in [address componentsSeparatedByString:@"&"]) {
        [MString appendString:aString];
    }
    _label.text = MString;
    _addressBtn.selected = isSelect;
    _section = section;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end