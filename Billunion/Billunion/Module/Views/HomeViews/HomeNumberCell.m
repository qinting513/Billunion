//
//  HomeNumberCell.m
//  PCStock
//
//  Created by Waki on 2016/12/29.
//  Copyright © 2016年 JM. All rights reserved.
//

#define buttonTag  110
#define lableTag (110+5)
#define Label1Px  24
#define Label2Px  40
#define LabelSpace 30

#import "HomeNumberCell.h"
#import "MoreIndexModel.h"
#import "IndexModel.h"

@interface HomeNumberCell ()
{
    UIView *_bgView;
    UILabel *_titleLabel;
    UIImageView *_logo;
    UIButton *_moreBtn;
}

@end
@implementation HomeNumberCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _bgView = [[UIView alloc] init];
    [self.contentView addSubview:_bgView];
    //图标
    _logo = [[UIImageView alloc] init];
    _logo.image = [UIImage imageNamed:@"icon_logo"];
    [_bgView addSubview:_logo];
    //标题
     _titleLabel = [UILabel labelWithText:NSLocalizedString(@"Index", nil)  fontSize:15 textColor:[UIColor colorWithRGBHex:0x93a6be] alignment:NSTextAlignmentLeft];
    [_bgView addSubview:_titleLabel];
    //更多
    _moreBtn = [UIButton buttonWithNormalImage:@"more" selectImage:@"more_pr" imageType:btnImgTypeFull target:self action:@selector(moreClick)];
    [_moreBtn setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_moreBtn];
    
    _bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    _logo.sd_layout.leftSpaceToView(_bgView,STRealX(30)).topSpaceToView(_bgView,STRealY(30)).widthIs(STRealX(20)).heightIs(STRealY(34));
    _titleLabel.sd_layout.leftSpaceToView(_logo,10).centerYEqualToView(_logo).widthIs(100).autoHeightRatio(0);
    _moreBtn.sd_layout.topSpaceToView(_bgView,STRealY(30)).rightSpaceToView(_bgView,0).widthIs(STRealX(90)).heightIs(STRealY(39));
//    _moreBtn.frame = CGRectMake(WIDTH-STRealX(90)+2, STRealX(30), STRealX(90), STRealX(39));
    
    CGFloat spacePx = (750-313*2-20)/2;
    for (int i = 0; i < 4; i++) {
        CGRect rect =  STRect(spacePx+(313+20)*(i%2), 108+(220+20)*(i/2), 313, 220);
        UIButton *button = [self layoutBgViewWithframe:rect index:i];
        [_bgView addSubview:button];
    }
}

- (UIButton *)layoutBgViewWithframe:(CGRect)rect index:(NSInteger)index{
    UIColor *color = [UIColor colorWithRGBHex:0x2262ac];
    
    //底边的button
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.tag = buttonTag+index*10;
    bgButton.frame = rect;
    UIView *cornerRadiusView = [[UIView alloc] initWithFrame:bgButton.bounds];
    cornerRadiusView.layer.cornerRadius = STRealX(40);
    cornerRadiusView.backgroundColor = color;
    [bgButton addSubview:cornerRadiusView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = color;
    
    if (index == 0) {
        view.frame =  CGRectMake(0, 0, 50, bgButton.height);
        view2.frame = CGRectMake(0, 0, bgButton.width, bgButton.height-50);
    }else if (index == 1){
        view.frame =  CGRectMake(bgButton.width-50, 0, 50, bgButton.height);
        view2.frame = CGRectMake(0, 0, bgButton.width, bgButton.height-50);
    }else if (index == 2){
        view.frame =  CGRectMake(0, 0, 50, bgButton.height);
        view2.frame = CGRectMake(0, bgButton.height-50, bgButton.width, 50);
    }else{
        view.frame =  CGRectMake(bgButton.width-50, 0, 50, bgButton.height);
        view2.frame = CGRectMake(0, bgButton.height-50, bgButton.width, 50);
    }
    [bgButton addSubview:view];
    [bgButton addSubview:view2];

    //每一个button上的label
    if (index == 0 || index == 1) {
        CGFloat topSpacePx = (STPixelX(bgButton.height) - (Label1Px*2+Label2Px+LabelSpace*2))/2;
        for (int i = 0; i < 3; i++) {
            UILabel *label;
            if (i == 1) {
                label = [UILabel labelWithText:nil fontSize:20 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
                label.frame = STRect(0, topSpacePx+Label1Px+LabelSpace, STPixelX(bgButton.width), Label2Px);
            }else{
                label = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
                if (i == 0) {
                    label.frame = STRect(0, topSpacePx, STPixelX(bgButton.width), Label1Px);
                }else{
                    label.frame = STRect(0, topSpacePx+Label1Px+Label2Px+LabelSpace*2, STPixelX(bgButton.width), Label1Px);
                }
            }
            label.tag = lableTag + i;
//            label.backgroundColor = [UIColor redColor];
            [bgButton addSubview:label];
        }
    }else{
        CGFloat topSpacePx = (STPixelX(bgButton.height) - (Label1Px+Label2Px+LabelSpace))/2;
        for (int i = 0; i < 2; i++) {
            UILabel *label;
            if (i == 0) {
                label = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
                label.frame = STRect(0, topSpacePx, STPixelX(bgButton.width), Label1Px);
            }else{
                label = [UILabel labelWithText:nil fontSize:20 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
                    label.frame = STRect(0, topSpacePx+Label1Px+LabelSpace, STPixelX(bgButton.width),Label2Px);
            }
            label.tag = lableTag + i;
//            label.backgroundColor = [UIColor redColor];
            [bgButton addSubview:label];
        }
    }
    
    return bgButton;
}

- (void)setCellInfo:(NSArray *)dataArray{
  
//    if (dataArray.count == 0) {
//        return;
//    }
    
    NSString *bankIndex = @"0.00";
    NSString *bankOther = @"0000  +0.00%";
    NSString *companyIndex = @"0.00";
    NSString *companyOther = @"0000  +0.00%";
    NSString *today = @"0亿";
    NSString *history = @"0亿";
    IndexModel *firstIndex = nil;
    IndexModel * secondeIndex = nil;
    
    for (id mm in dataArray) {
        if ([mm isKindOfClass:[IndexModel class]]) {
            IndexModel *model = mm;
            if (model.IndexType.integerValue == 1) {
                firstIndex = model;
            }else if (model.IndexType.integerValue == 2){
                secondeIndex = model;
            }
            bankIndex = [NSString stringWithFormat:@"%.2lf",firstIndex.Index.floatValue];
            bankOther = [NSString stringWithFormat:@"%.2lf %.2lf%%",firstIndex.Bp.floatValue,firstIndex.Percent.floatValue];
            companyIndex = [NSString stringWithFormat:@"%.2lf",secondeIndex.Index.floatValue];
            companyOther = [NSString stringWithFormat:@"%.2lf %.2lf%%",secondeIndex.Bp.floatValue,secondeIndex.Percent.floatValue];
            
        }else if ([mm isKindOfClass:[MoreIndexModel class]]){
         MoreIndexModel *m = mm;
            if (![m.Today isKindOfClass:[NSNull class]]  && m.Today != nil ) {
                today = [NSString stringWithFormat:@"%.2lf亿", m.Today.doubleValue/100000000.0 ];
            }
        
            if (![m.History isKindOfClass:[NSNull class]]  && m.History != nil ) {
                history = [NSString stringWithFormat:@"%.2lf亿", m.History.doubleValue/100000000.0  ];
            }
        }
      
    }

    NSArray *array =  @[@[NSLocalizedString(@"YinCheng", nil),bankIndex,bankOther],
                        @[NSLocalizedString(@"ShangCheng", nil) ,companyIndex,companyOther],
                        @[NSLocalizedString(@"TodayTrade", nil),today],
                        @[NSLocalizedString(@"TotalTrade", nil),history]];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [self getBtnWithIndex:i];
        if (i == 0 || i == 1) {
            for (int j = 0; j < 3; j++) {
                UILabel *lable = (UILabel *)[button viewWithTag:lableTag+j];
                NSString *string = array[i][j];
                lable.text = string;
            }
        }else{
            for (int j = 0; j < 2; j++) {
                 UILabel *lable = (UILabel *)[button viewWithTag:lableTag+j];
                 NSString *string = array[i][j];
                lable.text = string;
            }
        }
    }
}



- (void)moreClick{
    if (_delegate && [_delegate respondsToSelector:@selector(moreAction)]) {
        [_delegate moreAction];
    }
}


- (UIButton *)getBtnWithIndex:(NSInteger)i{
   UIButton *button = [_bgView viewWithTag:buttonTag+i*10];
    return button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
