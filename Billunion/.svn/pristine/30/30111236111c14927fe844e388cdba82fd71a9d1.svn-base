//
//  InfoMationView.m
//  Billunion
//
//  Created by Waki on 2017/2/28.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "InfoMationView.h"
#import "UIView+HUD.h"
#import "UIView+Animation.h"

@interface InfoMationView()

@property (nonatomic,assign) InfoMationViewType type;

@property (nonatomic,strong) IsAnonymousView *isAnonymousView;
@property (nonatomic,strong) DeliveryView *deliveryView;
@property (nonatomic,strong) InPutTextView *inPutTextView;

@end

@implementation InfoMationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

- (void)layoutWithType:(InfoMationViewType)type{
    __weak typeof(self) weakSelf = self;
    if (type == InfoMationViewType_IsAnonymous) {
        _isAnonymousView = [[IsAnonymousView alloc] init];
        _isAnonymousView.isAnonymousViewBlock  = ^(BOOL isSureBtn,BOOL isAnoymous){
            if (isSureBtn && weakSelf.isAnonymousViewBlock) {
                weakSelf.isAnonymousViewBlock(isSureBtn,isAnoymous);
            }
            [weakSelf hideWithType:InfoMationViewType_IsAnonymous];
        };       
    }else if(type == InfoMationViewType_Delivery){
        _deliveryView = [[DeliveryView alloc] init];
        _deliveryView.deliveryViewBlock = ^(BOOL isSureBtn,NSDictionary *dict){
            if (isSureBtn && weakSelf.deliveryViewBlock) {
                weakSelf.deliveryViewBlock(isSureBtn,dict);
            }
            [weakSelf hideWithType:InfoMationViewType_Delivery];
        };
    }else if (type == InfoMationViewType_InPut_DiscountRate ||
              type ==InfoMationViewType_InPut_counterPartyId){
        _inPutTextView = [[InPutTextView alloc] init];
        _inPutTextView.inputTextViewBlock = ^(BOOL isSureBtn,NSString *message){
            if (isSureBtn && weakSelf.inputTextViewBlock) {
                weakSelf.inputTextViewBlock(isSureBtn,message);
            }
            [weakSelf hideWithType:InfoMationViewType_InPut_DiscountRate];
        };
    }
}

- (void)showWithType:(InfoMationViewType)type{
    self.hidden = NO;
    _type = type;
    [self layoutWithType:type];
    
    if (type == InfoMationViewType_Delivery) {
         [self showView:_deliveryView animated:YES];
    }else if (type == InfoMationViewType_IsAnonymous){
         [self showView:_isAnonymousView animated:YES];
    }else{
        if (type == InfoMationViewType_InPut_DiscountRate) {
            if (_type == InfoMationViewType_InPut_DiscountRate && self.inputViewStr.length > 0) {
                _inPutTextView.discountRate = self.inputViewStr;
            }
            _inPutTextView.placeholder = @"0.00";
            _inPutTextView.title = @"贴现率：";
        }else{
            _inPutTextView.placeholder = @"请输入交易对手";
            _inPutTextView.title = @"交易对手：";
        }
        _inPutTextView.type = type;
         [self showView:_inPutTextView animated:YES];
    }
}

- (void)hideWithType:(InfoMationViewType)type{
    if (type == InfoMationViewType_Delivery) {
        [self closeView:_deliveryView animated:YES];
    }else if (type == InfoMationViewType_IsAnonymous){
        [self closeView:_isAnonymousView animated:YES];
    }else{
        [self closeView:_inPutTextView animated:YES];
    }
}



@end



#define kLeftMargin  STRealX(10)
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

@end

/** 交割时间 */
@implementation DeliveryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        CGFloat w = STRealX(670);
        CGFloat h = STRealY(500);
        CGFloat x = (WIDTH-STRealX(670))/2;
        CGFloat y = HEIGHT*0.5 - h * 0.5;

        self.frame = CGRectMake(x, y, w, h);
        self.backgroundColor = [UIColor colorWithRGBHex:0x252429];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        CGFloat top = STRealY(44);
        CGFloat left = STRealX(18);
        UILabel *timeLabel = [UILabel labelWithText:@"交割时间:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [self addSubview:timeLabel];
        timeLabel.sd_layout.topSpaceToView(self,top).leftSpaceToView(self,left).rightSpaceToView(self,left).heightIs(15);
        
        self.titles = @[@"T+0",@"T+1",@"T+2",@"T+3"];
        CGFloat btnW = (self.width - STRealX(18)*2- kLeftMargin * (_titles.count-1) ) / _titles.count;
        CGFloat btnY = top + timeLabel.height + STRealY(24);
        CGFloat btnH = STRealY(48);
        for(int i = 0;i<_titles.count;i++) {
            UIButton *btn = [self getButton:_titles[i] frame:CGRectMake(STRealX(18) + (btnW+kLeftMargin)*i,btnY, btnW, btnH)];
            [self addSubview:btn];
            btn.tag = kBtnTag;
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                self.deliveryBtn = btn;
            }
        }
        
        CGFloat aY = btnY + btnH + STRealY(36);
        UILabel *anonymousLabel = [UILabel labelWithText:@"是否匿名:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [self addSubview:anonymousLabel];
        anonymousLabel.sd_layout.topSpaceToView(self,aY).leftSpaceToView(self,left).heightIs(btnH).widthIs(btnW);
        
        NSArray *yesOrNo = @[@"否",@"是"];
        CGFloat yesX = btnW + kLeftMargin+STRealX(18);
        for (int i= 0; i<yesOrNo.count; i++) {
            UIButton *btn = [self getButton:yesOrNo[i] frame:CGRectMake(yesX + (btnW+kLeftMargin)*i,aY, btnW, btnH)];
            [self addSubview:btn];
            btn.tag = kBtnTag + 10;
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                self.anonymousBtn = btn; // 是否匿名
            }
        }
        
        CGFloat rateY = aY + btnH + STRealY(36);
        UILabel *rateLabel = [UILabel labelWithText:@"贴现率:" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [self addSubview:rateLabel];
        rateLabel.sd_layout.topSpaceToView(self,rateY).leftSpaceToView(self,left).heightIs(STRealY(100)).widthIs(btnW);
        
//        UITextField *tf = [UITextField textFieldWithText:@"" clearButtonMode:UITextFieldViewModeWhileEditing placeholder:@"0.00" font:18 textColor:[UIColor colorWithRGBHex:0xffffff]];
//        [self addSubview:tf];
//        tf.sd_layout.topEqualToView(rateLabel).leftSpaceToView(rateLabel,0).widthIs(self.width-60-9*2).heightIs(30);
//        [tf setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
//        tf.layer.borderWidth = 1;
//        tf.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
//        UILabel *rightLabel = [UILabel labelWithText:@"%" fontSize:18 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
//        rightLabel.frame = CGRectMake(0, 0, 30, STRealY(100));
//        tf.rightView = rightLabel;
//        tf.rightViewMode = UITextFieldViewModeAlways;
//        self.rateTF = tf;
        
        UIView *tfBgView = [[UIView alloc] init];
        [self addSubview:tfBgView];
        tfBgView.sd_layout.leftSpaceToView(rateLabel,0).topEqualToView(rateLabel).widthIs(STRealX(470)).centerYEqualToView(rateLabel).heightIs(STRealY(100));
        
        UITextField *tf = [[UITextField alloc] init];
        [tfBgView addSubview:tf];
        tf.placeholder = @"0.00";
        tf.textColor = [UIColor whiteColor];
        tf.font = [UIFont systemFontOfSize:21];
        
        tf.layer.borderWidth = 1;
        tf.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
        
        [tf setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
        
        //左边和右边的视图
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        
        tf.rightViewMode = UITextFieldViewModeAlways;
        UILabel *rightLabel = [UILabel labelWithText:@"%" fontSize:20.5 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        rightLabel.frame = CGRectMake(0, 0, 30, 30);
        tf.rightView = rightLabel;

        
        tf.sd_layout.leftEqualToView(tfBgView).rightEqualToView(tfBgView).centerYEqualToView(tfBgView).heightIs(STRealY(100));
        self.rateTF = tf;
        
        
        UIView *btnBgView = [[UIView alloc] init];
        [self addSubview:btnBgView];
        btnBgView.sd_layout.topSpaceToView(tfBgView,STRealY(36)).centerXEqualToView(self).widthIs(STRealX(250*2+84)).heightIs(STRealY(76));
        
        UIButton *cancelBtn = [self getButton:@"取消"  bgColor:[UIColor colorWithRGBHex:0x383838] target:@selector(cancelBtnClick) superView:btnBgView];
         cancelBtn.sd_layout.topEqualToView(btnBgView).leftEqualToView(btnBgView).bottomEqualToView(btnBgView).widthIs(STRealX(250));

        UIButton *sureBtn = [self getButton:@"确定"  bgColor:[UIColor colorWithRGBHex:0x1c4473] target:@selector(sureBtnClick) superView:btnBgView];
        
            sureBtn.sd_layout.topEqualToView(btnBgView).rightEqualToView(btnBgView).bottomEqualToView(btnBgView).widthIs(STRealX(250));
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

@end



@interface IsAnonymousView(){
    BOOL _isAnonymous;
}


@end
@implementation IsAnonymousView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRGBHex:0x252429];
        self.frame = CGRectMake((WIDTH-STRealX(640))/2, 200, STRealX(640), STRealY(298));
        self.layer.cornerRadius = 5;
        
        UILabel *titleLabel = [UILabel labelWithText:@"是否匿名：" fontSize:17 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];

        titleLabel.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self,STRealY(30)).heightIs(STRealY(36));
        
        NSArray *selectArray = @[@"否",@"是"];
        for (int i = 0; i < selectArray.count; i++) {
            UIButton *selectBtn = [UIButton buttonWithTitle:selectArray[i] titleFont:12 titleColor:[UIColor whiteColor] target:self action:@selector(isAnonymousSelect:)];
            selectBtn.tag =  30+i;
            selectBtn.layer.cornerRadius = 3;
            selectBtn.layer.borderWidth = 1;
            selectBtn.layer.borderColor = [UIColor colorWithRGBHex:0x93a6be].CGColor;
            CGFloat btnWidth = (self.width-STRealX(80)*2-STRealX(84))/2;
            
            selectBtn.frame = CGRectMake(STRealX(80)+i*(btnWidth+STRealX(84)), STRealY(96), btnWidth, STRealY(60));
            
            if (!_isAnonymous && i == 0) {
                selectBtn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
            }
            [self addSubview:selectBtn];
        }
        
        NSArray *okArray = @[@"取消",@"确定"];
        for (int i = 0; i < okArray.count; i++) {
            UIButton *okBtn = [UIButton buttonWithTitle:okArray[i] titleFont:12 titleColor:[UIColor whiteColor] target:self action:@selector(oKSelect:)];
            okBtn.tag =  40+i;
            okBtn.layer.cornerRadius = 5;
            if (i == 0) {
                okBtn.backgroundColor = [UIColor colorWithRGBHex:0x333333];
            }else{
                okBtn.backgroundColor = [UIColor colorWithRGBHex:0x1c4473];
            }
            
            CGFloat btnWidth = (self.width-STRealX(50)*2-STRealX(36))/2;
            okBtn.frame = CGRectMake(STRealX(50)+i*(btnWidth+STRealX(36)), STRealY(194), btnWidth, STRealY(76));
            
            [self addSubview:okBtn];
        }
    }
    
    return self;
}

- (void)oKSelect:(UIButton *)btn{
    if (self.isAnonymousViewBlock) {
        if (btn.tag == 40) {  //取消
            self.isAnonymousViewBlock(NO,_isAnonymous);
        }else{
            self.isAnonymousViewBlock(YES,_isAnonymous);
        }
    }
}

- (void)isAnonymousSelect:(UIButton *)btn{
    for (UIView *view  in self.subviews) {
        if (view.tag == 30 || view.tag == 31) {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    if (btn.tag == 30) {  //匿名
        _isAnonymous = NO;
    }else{    //非匿名
        _isAnonymous = YES;
    }
    btn.backgroundColor  = [UIColor colorWithRGBHex:0x93a6be];
}

@end


@interface InPutTextView(){

    UITextField *_textField;
    UILabel *_titleLabel;
}

@end
@implementation InPutTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGBHex:0x252429];
        self.frame = CGRectMake((WIDTH-STRealX(670))/2, 200, STRealX(670), STRealY(350));
        self.layer.cornerRadius = 5;
        
        UILabel *titleLabel = [UILabel labelWithText:self.title fontSize:18 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        titleLabel.frame = CGRectMake(STRealX(48), STRealY(36), self.width-STRealX(48)*2, STRealY(36));
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIView *tfBgView = [[UIView alloc] init];
        [self addSubview:tfBgView];
        tfBgView.sd_layout.topSpaceToView(titleLabel, STRealY(26)).widthIs(STRealX(580)).centerXEqualToView(self).heightIs(STRealY(100));
        
        UITextField *tf = [[UITextField alloc] init];
        [tfBgView addSubview:tf];
        tf.placeholder = self.placeholder;
        tf.textColor = [UIColor whiteColor];
        tf.font = [UIFont systemFontOfSize:21];
        
        tf.layer.borderWidth = 1;
        tf.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;

        [tf setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
       
        //左边和右边的视图
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        
        
        tf.sd_layout.leftEqualToView(tfBgView).rightEqualToView(tfBgView).centerYEqualToView(tfBgView).heightIs(STRealY(100));
        _textField = tf;
        
        UIView *btnBgView = [[UIView alloc] init];
        [self addSubview:btnBgView];
        btnBgView.sd_layout.topSpaceToView(tf,STRealY(36+100)).centerXEqualToView(self).widthIs(STRealX(250*2+84)).heightIs(STRealY(76));
        
        NSArray *okArray = @[@"取消",@"确定"];
        for (int i = 0; i < okArray.count; i++) {
            UIButton *okBtn = [UIButton buttonWithTitle:okArray[i] titleFont:12 titleColor:[UIColor whiteColor] target:self action:@selector(oKSelect:)];
            okBtn.tag =  40+i;
            okBtn.layer.cornerRadius = 5;
            if (i == 0) {
                okBtn.backgroundColor = [UIColor colorWithRGBHex:0x333333];
            }else{
                okBtn.backgroundColor = [UIColor colorWithRGBHex:0x1c4473];
            }
           [btnBgView addSubview:okBtn];
            
            if (i == 0) {
                okBtn.sd_layout.topEqualToView(btnBgView).leftEqualToView(btnBgView).bottomEqualToView(btnBgView).widthIs(STRealX(250));
            }else{
               okBtn.sd_layout.topEqualToView(btnBgView).rightEqualToView(btnBgView).bottomEqualToView(btnBgView).widthIs(STRealX(250));
            }
        }
        
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _textField.placeholder = placeholder;
}

- (void)setDiscountRate:(NSString *)discountRate{
    _textField.text = discountRate;
}

- (void)setTitle:(NSString *)title{
    
    if (self.type == InfoMationViewType_InPut_DiscountRate) {
        _textField.rightViewMode = UITextFieldViewModeAlways;
        UILabel *rightLabel = [UILabel labelWithText:@"%" fontSize:20.5 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        rightLabel.frame = CGRectMake(0, 0, 30, 30);
        _textField.rightView = rightLabel;
    }

    _titleLabel.text = title;
}

- (void)oKSelect:(UIButton *)btn{
    if (self.inputTextViewBlock) {
        if (btn.tag == 40) {  //取消
            self.inputTextViewBlock(NO,_textField.text);
        }else{
            if (self.type == InfoMationViewType_InPut_counterPartyId) {
                if ([_textField.text mj_isPureInt]) {
                    self.inputTextViewBlock(YES,_textField.text);
                }else{
                    [self showError:@"交易对手输入格式不正确" ];
                }
            }else if (self.type ==  InfoMationViewType_InPut_DiscountRate){
                if ([_textField.text isPureFloat]) {
                    self.inputTextViewBlock(YES,_textField.text);
                }else{
                    [self showError:@"贴现率输入格式不正确" ];
                }
            }
        }
    }
}

- (void)showError:(NSString *)message{
    [UIAlertController alertControllerWithTitle:@"提示" message:message okTitle:@"确定" cancelTtile:nil target:[UIAlertController getTarget:self] clickBlock:nil];
}

@end
