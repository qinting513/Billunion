//
//  DeliveryView.m
//  Billunion
//
//  Created by QT on 17/2/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "DeliveryView.h"
#import "UIView+HUD.h"

#define kLeftMargin 10
#define kBtnTag 500

/** 票据行情 -》卖方市场-》k线图界面 -》点击 买入 ： 弹出的 交割时间View   */

@interface DeliveryView()

/** 交割时间 */
@property (nonatomic,strong)UIButton  *deliveryBtn;
/** 是否是匿名 */
@property (nonatomic,strong)UIButton  *anonymousBtn;
/** 贴现率 */
@property (nonatomic,strong)UITextField *rateTF;

@property (nonatomic,strong)NSArray *titles;

@property (nonatomic,strong) UIView *bgView;

@end

/** 交割时间 */
@implementation DeliveryView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        CGFloat w = WIDTH-40;
        CGFloat h = 240;
        CGFloat x = 20;
        CGFloat y = HEIGHT*0.5 - h * 0.5;
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        [self addSubview:_bgView];
        _bgView.tag = 100;
        _bgView.backgroundColor = [UIColor colorWithRGBHex:0x252429];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        
        CGFloat top = 20;
        CGFloat left = 9;
        UILabel *timeLabel = [UILabel labelWithText:@"交割时间:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [_bgView addSubview:timeLabel];
        timeLabel.sd_layout.topSpaceToView(_bgView,top).leftSpaceToView(_bgView,left).rightSpaceToView(_bgView,left).heightIs(15);
        
        self.titles = @[@"T+0",@"T+1",@"T+2",@"T+3"];
        CGFloat btnW = (_bgView.frame.size.width - kLeftMargin * (_titles.count+1) ) / _titles.count;
        CGFloat btnY = top + timeLabel.height + 12;
        CGFloat btnH = 25;
        for(int i = 0;i<_titles.count;i++) {
            UIButton *btn = [self getButton:_titles[i] frame:CGRectMake(kLeftMargin + (btnW+kLeftMargin)*i,btnY, btnW, btnH)];
            [_bgView addSubview:btn];
            btn.tag = kBtnTag;
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                self.deliveryBtn = btn;
            }
        }
        
        CGFloat aY = btnY + btnH + 18;
        UILabel *anonymousLabel = [UILabel labelWithText:@"是否匿名:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [_bgView addSubview:anonymousLabel];
        anonymousLabel.sd_layout.topSpaceToView(_bgView,aY).leftSpaceToView(_bgView,left).heightIs(btnH).widthIs(80);
        
        NSArray *yesOrNo = @[@"否",@"是"];
        CGFloat yesX = CGRectGetMaxX(anonymousLabel.frame);
        for (int i= 0; i<yesOrNo.count; i++) {
            UIButton *btn = [self getButton:yesOrNo[i] frame:CGRectMake(yesX + (btnW+kLeftMargin)*i,aY, btnW, btnH)];
            [_bgView addSubview:btn];
            btn.tag = kBtnTag + 10;
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                self.anonymousBtn = btn; // 是否匿名
            }
        }
        
        CGFloat rateY = aY + btnH + 18;
        UILabel *rateLabel = [UILabel labelWithText:@"贴现率:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [_bgView addSubview:rateLabel];
        rateLabel.sd_layout.topSpaceToView(_bgView,rateY).leftSpaceToView(_bgView,left).heightIs(30).widthIs(60);
        
        UITextField *tf = [UITextField textFieldWithText:@"" clearButtonMode:UITextFieldViewModeWhileEditing placeholder:@"0.00" font:18 textColor:[UIColor colorWithRGBHex:0xffffff]];
        [_bgView addSubview:tf];
        tf.sd_layout.topEqualToView(rateLabel).leftSpaceToView(rateLabel,0).rightSpaceToView(_bgView,10).heightIs(30);
         [tf setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
        tf.layer.borderWidth = 1;
        tf.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
        UILabel *rightLabel = [UILabel labelWithText:@"%" fontSize:18 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        rightLabel.frame = CGRectMake(0, 0, 20, 30);
        tf.rightView = rightLabel;
        tf.rightViewMode = UITextFieldViewModeAlways;
        self.rateTF = tf;
       
        UIButton *cancelBtn = [self getButton:@"取消"  bgColor:[UIColor colorWithRGBHex:0x383838] target:@selector(cancelBtnClick) superView:_bgView];
        cancelBtn.sd_layout.topSpaceToView(tf,20).leftSpaceToView(_bgView,28).heightIs(38).widthIs(100);
        UIButton *sureBtn = [self getButton:@"确定"  bgColor:[UIColor colorWithRGBHex:0x1c4473] target:@selector(sureBtnClick) superView:_bgView];
        sureBtn.sd_layout.topSpaceToView(tf,20).rightSpaceToView(_bgView,28).heightIs(38).widthIs(100);
    }
    return self;
}

- (UIButton *)getButton:(NSString *)string frame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithTitle:string titleFont:13 titleColor:[UIColor colorWithRGBHex:0xffffff] target:self action:@selector(deliveryBtnClick:)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.frame = frame;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
    return button;
}

-(UIButton *)getButton:(NSString *)title bgColor:(UIColor *)bgColor target:(SEL)method superView:(UIView*)bgView
{
      UIButton *btn = [UIButton buttonWithTitle:title titleFont:15 titleColor:[UIColor whiteColor] target:self action:method];
      [btn setBackgroundColor:bgColor];
      btn.layer.cornerRadius = 5;
      btn.clipsToBounds = YES;
      [bgView addSubview:btn];
      return btn;
}

/** 交割时间按钮 */
-(void)deliveryBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
    if (btn.tag == kBtnTag) {
        if (self.deliveryBtn == btn) {
            return;
        }
        self.deliveryBtn.selected = !btn.selected;
        self.deliveryBtn.backgroundColor = [UIColor clearColor];
        self.deliveryBtn = btn;
    }else{
        if (self.anonymousBtn == btn) {
            return;
        }
        self.anonymousBtn.selected = !btn.selected;
        self.anonymousBtn.backgroundColor = [UIColor clearColor];
        self.anonymousBtn = btn;
    }
 
}

/** 取消按钮 */
-(void)cancelBtnClick
{
    !self.deliveryViewBlock ?: self.deliveryViewBlock(NO,nil);
}

/** 确定按钮 */
-(void)sureBtnClick
{
    if (![self.rateTF.text isPureFloat]) {
        [self showWarning:@"贴现率不正确!"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"delivery"] = [self getDeliveryWithTitle:self.deliveryBtn.currentTitle];
    dict[@"anonymous"] = [self getAnonymousWithTitle:self.anonymousBtn.currentTitle];
    dict[@"discountRate"] = @(self.rateTF.text.floatValue);
    
   !self.deliveryViewBlock ?: self.deliveryViewBlock(YES,dict);
}

-(NSNumber *)getDeliveryWithTitle:(NSString *)title{
    NSInteger index = [self.titles indexOfObject:title];
    return @(index);
}

-(NSNumber *)getAnonymousWithTitle:(NSString *)title
{
    if ([self.anonymousBtn.currentTitle isEqualToString:@"否"]) {
      return @(0);
    }else
    {
      return @(1);
    }
}


#pragma mark - 显示
-(void)show
{
    _bgView.frame = CGRectMake(self.width/2, self.height/2, 0, 0);
    CGFloat w = WIDTH-40;
    CGFloat h = 240;
    CGFloat x = 20;
    CGFloat y = HEIGHT*0.5 - h * 0.5;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(x,y,w,h)];
    _bgView.frame=CGRectMake(x, y, x,y);
    [UIView commitAnimations];
}
#pragma mark - 隐藏
-(void)hide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self removeFromSuperview];
    [UIView commitAnimations];
}



@end
