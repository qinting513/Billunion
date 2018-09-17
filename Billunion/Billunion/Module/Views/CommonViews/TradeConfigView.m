

//
//  TradeConfigView.m
//  Billunion
//
//  Created by Waki on 2017/3/22.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "TradeConfigView.h"
#define BottomViewHeight 50.0
#define ItemH  48
#define SpaceY 40
#define Font    13

@interface TradeConfigView ()<UITextFieldDelegate>{
    UIButton *_deliveryBtn;  //交割时间按钮
    UIButton *_select1Btn;  //是否匿名按钮
    UIButton *_select2Btn;
    UIButton *_select3Btn;
    
    UITextField *_counterPartyField;
}

@end

@implementation TradeConfigView


- (instancetype)initWithKlineType:(TradeConfigViewType)type{
    self = [super init];
    if (self) {
        self.type =  type;
        
        if (self.type == TradeConfigViewType_sellerMarket) {
            _topViewH = STRealY(367+SpaceY+ItemH);
        }else if (self.type == TradeConfigViewType_buyerMarket){
            _topViewH = STRealY(ItemH*3+SpaceY*4);
        }else if (self.type == TradeConfigViewType_buyerOffer){
            _topViewH = STRealY(160);
        }else if (self.type == TradeConfigViewType_sellerInquiry){
            if ([[Config getCompanyType] integerValue] == 1) {
                _topViewH = STRealY(ItemH*2+SpaceY*3);
            }else{
                _topViewH = STRealY(ItemH+SpaceY*2);
            }
        }else if (self.type == TradeConfigViewType_sellerSpecify){
            _topViewH = STRealY(120+ItemH*2+SpaceY*3);
        }else if (self.type == TradeConfigViewType_beBuyerSpecify){
            _topViewH = STRealY(ItemH+SpaceY*2);
        }else{
            _topViewH = 0;
        }
        
        self.frame = CGRectMake(0, HEIGHT-BottomViewHeight-_topViewH, WIDTH, BottomViewHeight+_topViewH);
        [self layoutBottonView];
    }
    return self;
}


//下面部分的View
- (void)layoutBottonView{
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0,self.height- BottomViewHeight, WIDTH, BottomViewHeight)];
    bottonView.backgroundColor = [UIColor colorWithRGBHex:0x252429];
    [self addSubview:bottonView];
    
    _moneyLabel = [UILabel labelWithText:nil
                                fontSize:Font
                               textColor:[UIColor colorWithRGBHex:0x93a6be]
                               alignment:NSTextAlignmentLeft];
    [bottonView addSubview:_moneyLabel];
    
    _rateLabel = [UILabel labelWithText:nil
                               fontSize:Font
                              textColor:[UIColor colorWithRGBHex:0x93a6be]
                              alignment:NSTextAlignmentLeft];
    [bottonView addSubview:_rateLabel];
    
    _transactionBtn = [UIButton buttonWithTitle:NSLocalizedString(@"Finish", nil) titleFont:Font titleColor:[UIColor colorWithRGBHex:0xfefefe] target:self action:@selector(btnClick)];
    _transactionBtn.backgroundColor = [UIColor colorWithRGBHex:0x2262ac];
    _transactionBtn .layer.masksToBounds = YES;
    _transactionBtn.layer.cornerRadius = 3;
    [bottonView addSubview:_transactionBtn];
    
    
    CGFloat top = (bottonView.height - Font)*0.5;
    CGFloat margin = STRealX(10);
    _moneyLabel.sd_layout.topSpaceToView(bottonView,top).leftSpaceToView(bottonView,margin ).bottomSpaceToView(bottonView,top);
    [self.moneyLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _rateLabel.sd_layout.topSpaceToView(bottonView,top).leftSpaceToView(_moneyLabel,margin).bottomSpaceToView(bottonView,top).widthIs(100);
    
    _transactionBtn .sd_layout.centerYEqualToView(_rateLabel).leftSpaceToView(_rateLabel,margin).rightSpaceToView(bottonView,margin).heightIs(36);
    
    
    if (self.type != TradeConfigViewType_other) {
        [self layoutTopView];
    }
}


//上部分view
- (void)layoutTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,self.height-_topViewH -BottomViewHeight, WIDTH, _topViewH)];
    topView.backgroundColor = [UIColor colorWithRGBHex:0x252429];
    [self addSubview:topView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topViewH-0.5, WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRGBHex:0x33333];
    [topView addSubview:lineView];
    
     NSArray *yesOrNo = @[NSLocalizedString(@"NO", nil),NSLocalizedString(@"YES", nil)];
     NSArray *agreementArray = @[@"是",@"否"];
    //UI类型区分
    if (self.type == TradeConfigViewType_sellerMarket) {
        //交割时间
        UILabel *timeLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"TradeTime",nil),@"："] fontSize:Font textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
        [topView addSubview:timeLabel];
        timeLabel.sd_layout.topSpaceToView(topView,STRealX(30)).leftSpaceToView(topView,STRealX(30)).rightSpaceToView(topView,0).heightIs(15);
        
        NSArray *titles = @[@"T+0",@"T+1",@"T+2",@"T+3"];
        CGFloat btnW = (WIDTH - STRealX(30)*2- STRealX(10)*3)/4;
        CGFloat btnY = STRealY(71);
        CGFloat btnH = STRealY(ItemH);
        for(int i = 0;i<titles.count;i++) {
            UIButton *btn = [self getButton:titles[i] frame:CGRectMake(STRealX(30) + (btnW+STRealX(10))*i,btnY, btnW, btnH)];
            btn.tag = 200+i;
            [topView addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                _deliveryBtn = btn;
                self.delivery = i;
            }
        }
       
        //是否需要合同
        [self layoutSelectView:yesOrNo leftTitle:@"需要发票、合同:" baseTag:300 viewY:STRealY(159) superView:topView];
 
        //是否匿名
        [self layoutSelectView:yesOrNo leftTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"IsAnonymous", nil),@":"] baseTag:400 viewY:STRealY(159+SpaceY+ItemH) superView:topView];
        
    }else if (self.type == TradeConfigViewType_sellerInquiry ||
              self.type == TradeConfigViewType_sellerSpecify){
        if (self.type == TradeConfigViewType_sellerInquiry) {
            if ([[Config getCompanyType] integerValue] == 1) {
                //交易类型
                 [self layoutSelectView:@[@"批量成交"] leftTitle:@"交易类型:" baseTag:300 viewY:STRealY(SpaceY) superView:topView];
                
                [self layoutSelectView:agreementArray leftTitle:@"提供发票、合同:" baseTag:400 viewY:STRealY(128) superView:topView];
            }else{
                [self layoutSelectView:agreementArray leftTitle:@"提供发票、合同:" baseTag:300 viewY:STRealY(SpaceY) superView:topView];
            }
        }else if (self.type == TradeConfigViewType_sellerSpecify){
            //交易类型
            [self layoutSelectView:@[@"批量成交",@"挑票成交"] leftTitle:@"交易类型:" baseTag:300 viewY:STRealY(SpaceY) superView:topView];
            
            //是否需要合同
            [self layoutSelectView:agreementArray leftTitle:@"提供发票、合同:" baseTag:400 viewY:STRealY(128) superView:topView];
        
        }
    }else if (self.type == TradeConfigViewType_buyerMarket){
        //交易类型
        [self layoutSelectView:@[@"批量成交",@"挑票成交"] leftTitle:@"交易类型:" baseTag:300 viewY:STRealY(SpaceY) superView:topView];
        
        //是否匿名
        [self layoutSelectView:yesOrNo leftTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"IsAnonymous", nil),@"："] baseTag:400 viewY:STRealY(SpaceY*2+ItemH) superView:topView];
        
        //是否需要合同
        [self layoutSelectView:agreementArray leftTitle:@"提供发票、合同:" baseTag:500 viewY:STRealY(ItemH*2+SpaceY*3) superView:topView];
    }else if (self.type == TradeConfigViewType_beBuyerSpecify){
        //交易类型
        [self layoutSelectView:@[@"批量成交",@"挑票成交"] leftTitle:@"交易类型:" baseTag:300 viewY:STRealY(SpaceY) superView:topView];
    }
    
    if (self.type == TradeConfigViewType_sellerMarket ||
        self.type == TradeConfigViewType_buyerOffer) {
        [self layoutDiscountRateTextField:topView placeholder:@"0.000" labelText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"DiscountRate", nil),@":"]];
    }else if (self.type == TradeConfigViewType_sellerSpecify){
       _counterPartyField = [self layoutDiscountRateTextField:topView placeholder:@"公司名称" labelText:@"指定交易对手:"];
    }
}

- (void)layoutSelectView:(NSArray *)titleArray
                   leftTitle:(NSString *)leftTitle
                     baseTag:(NSInteger)baseTag
                       viewY:(CGFloat)viewY
                   superView:(UIView *)superView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, WIDTH, STRealY(ItemH+SpaceY))];
    [superView addSubview:bgView];
    //左边的title
    UILabel *leftLabel = [UILabel labelWithText:leftTitle fontSize:Font textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [bgView addSubview:leftLabel];
    leftLabel.sd_layout.topEqualToView(bgView).leftSpaceToView(bgView,STRealX(20)).heightIs(STRealY(ItemH)).widthIs(STRealX(230));
    
    CGFloat btnW = (WIDTH - STRealX(20)*2- STRealX(10)*3)/4;
    for (int i= 0; i<titleArray.count; i++) {
        UIButton *btn = [self getButton:titleArray[i] frame:CGRectMake(STRealX(260) + (btnW+STRealX(10))*i,0, btnW, STRealY(ItemH))];
        [bgView addSubview:btn];
        btn.tag = baseTag+i;
        if (i == 0) {
            if (baseTag == 300 && self.type != TradeConfigViewType_sellerMarket) {
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                    _select1Btn = btn;
                    self.select1Index = i;
            }else if (baseTag == 400){
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                _select2Btn = btn;
                self.select2Index = i;
            }else if (baseTag == 500){
                btn.selected = YES;
                btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
                _select3Btn = btn;
                self.select3Index = i;
            }
        }else if (i == 1 && baseTag == 300 && self.type == TradeConfigViewType_sellerMarket){
            btn.selected = YES;
            btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
            _select1Btn = btn;
            self.select1Index = i;
        }
    }

}

//选择的button
- (UIButton *)getButton:(NSString *)string frame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithTitle:string titleFont:Font titleColor:[UIColor colorWithRGBHex:0xffffff] target:self action:@selector(allBtnClick:)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.frame = frame;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
    return button;
}

//贴现率输入框
- (UITextField *)layoutDiscountRateTextField:(UIView *)superView
                        placeholder:(NSString *)placeholder
                          labelText:(NSString *)labelText{
//    CGFloat labelW = (WIDTH - STRealX(30)*2- STRealX(10)*3)/4;
    UILabel *rateLabel = [UILabel labelWithText:labelText  fontSize:Font textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [superView addSubview:rateLabel];
    
    
    UITextField *tf = [[UITextField alloc] init];
    [superView addSubview:tf];
    tf.placeholder = placeholder;
    tf.textColor = [UIColor whiteColor];
    tf.font = [UIFont systemFontOfSize:16];
    tf.delegate = self;
    if (self.type == TradeConfigViewType_sellerSpecify) {
        tf.keyboardType = UIKeyboardTypeNumberPad;
    }else{
       tf.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    tf.layer.borderWidth = 1;
    tf.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
//    [tf setValue:[UIFont boldSystemFontOfSize:13]forKeyPath:@"_placeholderLabel.font"];
    [tf setValue:[UIColor colorWithRGBHex:0x666666] forKeyPath:@"_placeholderLabel.textColor"];
    
    //左边和右边的视图
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    _discountRateField = tf;
    
    rateLabel.sd_layout.bottomEqualToView(superView).leftSpaceToView(superView,STRealX(30)).heightIs(STRealY(160)).widthIs(STRealX(230));
    
    tf.sd_layout.leftSpaceToView(superView,STRealX(260)).rightSpaceToView(superView,STRealX(30)).centerYEqualToView(rateLabel).heightIs(STRealY(80));
    
    return tf;
}


/** 交割时间按钮 */
-(void)allBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    UIButton *lastBtn;
    if(btn.tag >= 200 && btn.tag < 300){
        lastBtn = _deliveryBtn;
        _deliveryBtn = btn;
        self.delivery = btn.tag - 200;
    }else if (btn.tag  >= 300 && btn.tag < 400){
        lastBtn = _select1Btn;
        _select1Btn = btn;
        self.select1Index = btn.tag - 300;
    }else if(btn.tag >= 400 && btn.tag < 500){
        lastBtn = _select2Btn;
        _select2Btn = btn;
        self.select2Index = btn.tag - 400;
    }else if (btn.tag >= 500 && btn.tag < 600){
        lastBtn = _select3Btn;
        _select3Btn = btn;
        self.select3Index = btn.tag - 500;
    }
    
    lastBtn.selected = !btn.selected;
    lastBtn.backgroundColor = [UIColor clearColor];
    
    btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];

}

//当点击选择交易对手时
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _counterPartyField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(beginSelectCounterParty:)]) {
            [self.delegate beginSelectCounterParty:textField.text];
        }
        return NO;
    }
    return YES;
}

- (void)setCounterPartyName:(NSString *)counterPartyName{
    if (_counterPartyField) {
        _counterPartyField.text = counterPartyName;
        _counterPartyField.font = [UIFont systemFontOfSize:13];
    }
}

#pragma makr - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.type == TradeConfigViewType_sellerSpecify) {
        if ([_discountRateField.text mj_isPureInt]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didEnterTextField:)]) {
                [self.delegate didEnterTextField:textField.text];
            }
        }else{
            [self.superview showWarning:@"输入不能为空!"];
        }
    }else{
        if ([_discountRateField.text isPureFloat] &&
            _discountRateField.text.floatValue > 0 &&
            _discountRateField.text.floatValue <= 100 ) {
            if([self judegDiscountRate]){
                if (self.delegate && [self.delegate respondsToSelector:@selector(didEnterTextField:)]) {
                    [self.delegate didEnterTextField:textField.text];
                }
            }
        }else{
            [self.superview showWarning:NSLocalizedString(@"DISCOUNTRATE_ERROR", nil) ];
        }
    }
   
    
}

- (void)setAmcountWithAmcount:(NSString *)amcount discountRate:(NSString *)discountRate{
    _moneyLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Amount", nil),amcount];
    _rateLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"DiscountRate", nil),discountRate];
}


- (BOOL)judegDiscountRate{
    if (_discountRateField && self.type != TradeConfigViewType_sellerSpecify) {
        NSString *errorStr =[Tools judgeDiscountRateInputWithText:_discountRateField.text];
        if (errorStr) {
            [[UIApplication sharedApplication].keyWindow showWarning:errorStr];
            return NO;
        }
    }
    return YES;
}

-(void)btnClick{
    if ([self judegDiscountRate]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(okClick)]) {
            [self.delegate okClick];
        }
    }
}


@end