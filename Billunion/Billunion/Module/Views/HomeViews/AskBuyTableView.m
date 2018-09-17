
//
//  AskBuyTableView.m
//  Billunion
//
//  Created by Waki on 2017/1/4.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AskBuyTableView.h"

#define itemHeight 24
#define itemTopSpace  10.0
#define itemSpace 14
#define leftSpace 10



@interface AskBuyTableView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_categoty;
    
    NSArray *_cell1Items;
    NSArray *_cell2Items;
    NSArray *_cell3Items;
    NSArray *_cell4Items;
    NSArray *_cell5Items;
    UITextField *_askMoneyField;
    UITextField *_percentField;
//    UITextField *_appointorField;
    
    UILabel *_amountLabel;
    UILabel *_addressLabel;
    UILabel *_appointorLabel;
    NSArray *_addressArr;
}
/** 所有cell的数据 */
@property (nonatomic,strong)NSMutableDictionary *askBuyDict;

@end
@implementation AskBuyTableView

-(NSMutableDictionary *)askBuyDict
{
    if (!_askBuyDict) {
        _askBuyDict = [NSMutableDictionary dictionary];
    }
    return _askBuyDict;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor blackColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [self layoutOkButton];
    }
    return self;
}

- (void)setBuyType:(BUYING_TYPE)buyType{
    _buyType = buyType;
    [self setupData];
}

- (void)setupData{
    _categoty = NSLocalizedString(@"PBankNote", nil);;
    _cell1Items = [Tools getAcceptorsWithBillType:1];
    _cell2Items = [Tools getDueTimeRangeWithBillType:1];
    _cell3Items = [Tools getTradeTimeArray];
    _cell4Items = @[@"否",@"是"];
    _cell5Items = @[@"全部",@"本行客户"];
    
    self.askBuyDict[@"AcceptorType"] = [self getAcceptorTypeWithStr:[_cell1Items firstObject]];
    self.askBuyDict[@"DueTime"]  = [self getDueTimeRangeTypeWithStr:[_cell2Items firstObject]];
    if (self.buyType == SpecifiedBuying) {
        self.askBuyDict[@"NeedOrCanReceipt"] = [self getNeedOrCanReceiptWithStr:_cell4Items.firstObject];
    }else{
        self.askBuyDict[@"TradeTime"]  = [self getTradeTimeWithStr:[_cell3Items firstObject]];
        self.askBuyDict[@"NeedOrCanReceipt"] = [self getNeedOrCanReceiptWithStr:_cell4Items.firstObject];
        self.askBuyDict[@"TargetCustomer"] = [self getTargetCustomerWithStr:_cell5Items.firstObject];
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  (self.buyType == AskBuying) ? 10 : 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"cell%ld",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
           [self layoutCell:cell indexPath:indexPath];
    }
    cell.backgroundColor = MainColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.buyType == AskBuying){
        if (indexPath.section == 0) {
            return  30;
        }else if (indexPath.section == 1){
            NSInteger  count = _cell1Items.count%3 > 0 ? (_cell1Items.count/3)+1 : (_cell1Items.count/3);
            return itemTopSpace+(itemHeight+itemTopSpace)*count;
        }else if (indexPath.section == 2){
            NSInteger count = _cell2Items.count%3 > 0 ? (_cell2Items.count/3)+1 : (_cell2Items.count/3);
            return   itemTopSpace+(itemHeight+itemTopSpace)*count;
        }else if (indexPath.section == 3){
            NSInteger count = _cell3Items.count%3 > 0 ? (_cell3Items.count/3)+1 : (_cell3Items.count/3);
            return   itemTopSpace+(itemHeight+itemTopSpace)*count;
        }else{
            return 52;
        }
    }else{
        if (indexPath.section == 0) {
            return  30;
        }else if (indexPath.section == 1){
            NSInteger  count = _cell1Items.count%3 > 0 ? (_cell1Items.count/3)+1 : (_cell1Items.count/3);
            return itemTopSpace+(itemHeight+itemTopSpace)*count;
        }else if (indexPath.section == 2){
            NSInteger count = _cell2Items.count%3 > 0 ? (_cell2Items.count/3)+1 : (_cell2Items.count/3);
            return   itemTopSpace+(itemHeight+itemTopSpace)*count;
        }else{
            return 52;
        }
    }
}

-(void)setAddressLabelWith:(NSArray *)arr
{
     _addressArr = arr;
     NSMutableString *ss = [NSMutableString string];
     if (arr.count != 0) {
        for (NSString *str in arr) {
            [ss appendFormat:@"%@、",str];
        }
        /** 去除最后的 、 */
        NSRange range = {ss.length - 1 ,1};
        [ss replaceCharactersInRange:range withString:@""];
    }
    _addressLabel.text = ss;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (section == 0) {
        height = 0.1;
    }else{
        height = 2;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

#pragma mark - layout cell
- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    if (self.buyType == AskBuying) {
        switch (indexPath.section) {
            case 0: [self layoutCell0:cell]; break;
            case 1: [self layoutCell1:cell cellForSection:indexPath.section data:_cell1Items labelText:@"承兑人类型:"]; break;
            case 2: [self layoutCell1:cell cellForSection:indexPath.section data:_cell2Items labelText:@"票据期限:"]; break;
            case 3: [self layoutCell1:cell cellForSection:indexPath.section data:_cell3Items labelText:@"交割时间:"]; break;
            case 4: [self layoutCell1:cell cellForSection:indexPath.section data:_cell4Items labelText:@"需要发票、合同:"]; break;
            case 5: [self layoutCell1:cell cellForSection:indexPath.section data:_cell5Items labelText:@"目标客户:"]; break;
            case 6: [self layoutCell4:cell cellForSection:indexPath.section]; break;
            case 7:  [self layoutcell8:cell]; break;
            case 8: [self layoutCell5:cell]; break;
            case 9: [self layoutCell6:cell]; break;
            
            default:  break;
        }
    }else{
        switch (indexPath.section) {
            case 0: [self layoutCell0:cell]; break;
            case 1: [self layoutCell1:cell cellForSection:indexPath.section data:_cell1Items labelText:@"承兑人类型:"]; break;
            case 2: [self layoutCell1:cell cellForSection:indexPath.section data:_cell2Items labelText:@"票据期限:"]; break;
            case 3: [self layoutCell1:cell cellForSection:indexPath.section data:_cell4Items labelText:@"需要发票、合同:"]; break;
            case 4: [self layoutCell4:cell cellForSection:indexPath.section]; break;
            case 5: [self layoutcell8:cell]; break;
            case 6: [self layoutCell5:cell]; break;
            case 7: [self layoutCell6:cell]; break;
            case 8:[self layoutCell7:cell]; break;
            default:  break;
        }
    }

}

//cell0
- (void)layoutCell0:(UITableViewCell *)cell{
    UIView *bgView = [self getBgView:30];
    [cell.contentView addSubview:bgView];
    NSString *text =[NSString stringWithFormat:@"产品类型:              %@",_categoty];
    UILabel *label = [self getTitleLabel:text frame:CGRectMake(leftSpace, 8, 200, 13)];
    [bgView addSubview:label];
}

//cell1/cell2
- (void)layoutCell1:(UITableViewCell *)cell cellForSection:(NSInteger)section data:(NSArray *)dataArray labelText:(NSString *)text{
    NSInteger count = dataArray.count%3 > 0 ? (dataArray.count/3)+1 : (dataArray.count/3);
    UIView *bgView = [self getBgView:itemTopSpace+count*(itemTopSpace+itemHeight)];
    [cell.contentView addSubview:bgView];
    UILabel *label = [self getTitleLabel:text frame:CGRectMake(leftSpace, 14, 100, 13)];
    [cell.contentView addSubview:label];
    
    CGFloat itemWidth = (WIDTH-(label.x+label.width)-itemSpace*3)/3;
    for (int i = 0; i < dataArray.count; i++) {
        CGRect rect = CGRectMake(CGRectGetMaxX(label.frame)+(itemWidth+itemSpace)*(i%3), itemTopSpace+(itemTopSpace+itemHeight)*(i/3), itemWidth, itemHeight);
        UIButton *button = [self getButton:dataArray[i] frame:rect hasBorderWidth:YES];
        button.tag = section*1000+i;
        [bgView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            button.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
        }
    }
}

- (void)layoutCell4:(UITableViewCell *)cell cellForSection:(NSInteger)section{
    UIView *bgView = [self getBgView:52];
    [cell.contentView addSubview:bgView];
    UILabel *titleLabel = [self getTitleLabel:@"询价金额：" frame:CGRectZero];
    [bgView addSubview:titleLabel];
    
    _askMoneyField = [self getTextField:@"0.00"];
    _askMoneyField.keyboardType = UIKeyboardTypeDecimalPad;
    [bgView addSubview:_askMoneyField];
    
    NSArray *btnTitles = @[@"万"];
    UIButton *millionBtn;
    for (int i = 0; i < btnTitles.count; i++) {
        UIButton *btn = [self getButton:btnTitles[i] frame:CGRectZero hasBorderWidth:NO];
        btn.tag = section*100+i;
        [bgView addSubview:btn];
        millionBtn = btn;
        millionBtn.enabled = NO;
    }
    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(80).centerYEqualToView(bgView).autoHeightRatio(0);
    _askMoneyField.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightSpaceToView(bgView,100).heightIs(20);
    if (millionBtn) {
            millionBtn.sd_layout.leftSpaceToView(_askMoneyField,5).centerYEqualToView(titleLabel).heightIs(24).widthIs(29);
    }

    [self addBottomLine:_askMoneyField];

}

- (void)layoutCell5:(UITableViewCell *)cell{
    UIView *bgView = [self getBgView:52];
    [cell.contentView addSubview:bgView];
    UILabel *titleLabel = [self getTitleLabel:@"贴现率：" frame:CGRectZero];
    [bgView addSubview:titleLabel];
    
    _percentField = [self getTextField:@"0.000"];
    _percentField.keyboardType = UIKeyboardTypeDecimalPad;
    [bgView addSubview:_percentField];
    
    UILabel *percentLabel = [self getTitleLabel:@"%" frame:CGRectZero];
    [bgView addSubview:percentLabel];
    
    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(80).centerYEqualToView(bgView).autoHeightRatio(0);
    _percentField.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightSpaceToView(bgView,100).heightIs(20);
    percentLabel.sd_layout.leftSpaceToView(_percentField,5).centerYEqualToView(titleLabel).heightIs(24).widthIs(29);
    
    [self addBottomLine:_percentField];
}

- (void)layoutCell6:(UITableViewCell *)cell{
    UIView *bgView = [self getBgView:52];
    [cell.contentView addSubview:bgView];
    UILabel *titleLabel = [self getTitleLabel:@"票源地址：" frame:CGRectZero];
    [bgView addSubview:titleLabel];

    _addressLabel = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor colorWithRGBHex:0xfefefe] alignment:NSTextAlignmentLeft];
    [bgView addSubview:_addressLabel];
    
    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(80).centerYEqualToView(bgView).autoHeightRatio(0);
    _addressLabel.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightSpaceToView(bgView,10).heightIs(20);
    
    [self addBottomLine:_addressLabel];
}

- (void)layoutCell7:(UITableViewCell *)cell{
    UIView *bgView = [self getBgView:52];
    [cell.contentView addSubview:bgView];
    UILabel *titleLabel = [self getTitleLabel:@"指定交易对手:" frame:CGRectZero];
    [bgView addSubview:titleLabel];
    
//    _appointorField = [self getTextField:@"请输入银行行号／组织机构代码"];
//    _appointorField.keyboardType = UIKeyboardTypeNumberPad;
//    [bgView addSubview:_appointorField];
//    
//    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(100).centerYEqualToView(bgView).autoHeightRatio(0);
//    _appointorField.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightSpaceToView(bgView,10).heightIs(20);
//    
//    [self addBottomLine:_appointorField];
    
    
    _appointorLabel = [UILabel labelWithText:nil fontSize:12 textColor:[UIColor colorWithRGBHex:0xfefefe] alignment:NSTextAlignmentLeft];
    [bgView addSubview:_appointorLabel];
    
    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(80).centerYEqualToView(bgView).autoHeightRatio(0);
    _appointorLabel.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightSpaceToView(bgView,10).heightIs(20);
    
    [self addBottomLine:_appointorLabel];
}

- (void)layoutcell8:(UITableViewCell *)cell{
  UIView *bgView = [self getBgView:52];
    [cell.contentView addSubview:bgView];
   UILabel *titleLabel = [self getTitleLabel:@"询价金额(大写):" frame:CGRectZero];
    [bgView addSubview:titleLabel];
    
    titleLabel.sd_layout.leftSpaceToView(bgView,leftSpace).widthIs(100).centerYEqualToView(bgView).autoHeightRatio(0);
    
    _amountLabel = [UILabel labelWithText:@"零" fontSize:12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    [bgView addSubview:_amountLabel];
    _amountLabel.sd_layout.leftSpaceToView(titleLabel,0).centerYEqualToView(titleLabel).rightEqualToView(bgView).heightIs(20);
}



- (UIView *)layoutOkButton{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 52)];
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"Submit", nil) titleFont:15 titleColor:[UIColor whiteColor] target:self action:@selector(okClick)];
    button.backgroundColor = [UIColor colorWithRGBHex:0x2262ac];
    button.layer.cornerRadius = 3;
    button.frame = CGRectMake(35, 11, WIDTH-70, 30);
    [view addSubview:button];
    return  view;
}

- (void)addBottomLine:(UIView *)view{
    UIView *lineView = [[UIView alloc] init];
    [view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
    lineView.sd_layout.leftEqualToView(view).rightEqualToView(view).bottomEqualToView(view).heightIs(1);
}

- (UIButton *)getButton:(NSString *)string frame:(CGRect)frame hasBorderWidth:(BOOL)hasBorderWidth{
    UIButton *button = [UIButton buttonWithTitle:string titleFont:12 titleColor:[UIColor colorWithRGBHex:0x93a6be] target:self action:@selector(cellItemClick:)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.frame = frame;
    if (hasBorderWidth) {
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 2;
        button.layer.borderColor  = [UIColor colorWithRGBHex:0x93a6be].CGColor;
    }
    return button;
}

- (UIView *)getBgView:(CGFloat)height{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, height)];
    view.backgroundColor = MainColor;
    return view;
}


- (void)cellItemClick:(UIButton *)btn{
    for (UIView *v in btn.superview.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            ((UIButton*)v).selected = NO;
            v.backgroundColor = [UIColor clearColor];
        }
    }
    btn.selected = YES;
    btn.backgroundColor = [UIColor colorWithRGBHex:0x93a6be];
    
    if (btn.tag/1000 == 1) {
         self.askBuyDict[@"AcceptorType"] = [self getAcceptorTypeWithStr:btn.currentTitle];
    }else if (btn.tag/1000 == 2){
        self.askBuyDict[@"DueTime"] = [self getDueTimeRangeTypeWithStr:btn.currentTitle];
    }else if (btn.tag/1000 == 3){
        if (self.buyType == AskBuying) {
            self.askBuyDict[@"TradeTime"] =  [self getTradeTimeWithStr:btn.currentTitle];
        }else{
            self.askBuyDict[@"NeedOrCanReceipt"] = [self getNeedOrCanReceiptWithStr:btn.currentTitle];
        }
    }else if (btn.tag/1000 == 4){
        self.askBuyDict[@"NeedOrCanReceipt"] = [self getNeedOrCanReceiptWithStr:btn.currentTitle];
    }else if (btn.tag/1000 == 5){
        self.askBuyDict[@"TargetCustomer"] = [self getTargetCustomerWithStr:btn.currentTitle];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //金额输入
    if (_askMoneyField == textField) {
        NSString *errorStr =  [Tools judgeAmontInputWithText:textField.text];
        if (errorStr) {
            [self showErrorWithText:errorStr];
        }else{
           [self setAmountLableText:textField.text];
        }
    }else if (_percentField == textField){
        NSString *errorStr =  [Tools judgeDiscountRateInputWithText:textField.text];
        if (errorStr) {
            [self showErrorWithText:errorStr];
        }
    }

}

- (void)showErrorWithText:(NSString *)errorStr{
    [[UIApplication sharedApplication].keyWindow showWarning:errorStr afterDelay:1.3 ];
}


- (void)setAmountLableText:(NSString *)text{
    if (text.length == 0 ||  text.floatValue == 0) {
        _amountLabel.text = @"零";
    }else{
        _amountLabel.text =  [Tools getAmountText:text];
    }
}

#pragma mark - 检查所有 是否都满足条件
-(BOOL)checkAllIsOk{
    
       /** 询价金额 */
        NSString *errorStr =  [Tools judgeAmontInputWithText:_askMoneyField.text];
        if (errorStr) {
            [self showErrorWithText:errorStr];
            return NO;
        }
        float money = _askMoneyField.text.floatValue;
        if (![_askMoneyField.text isPureFloat] || money <= 0 ) {
            [self showErrorWithText:@"询价金额输入不正确"];
             return NO;
        }
    
      /** 贴现率 */
        errorStr =  [Tools judgeDiscountRateInputWithText:_percentField.text];
        if (errorStr) {
            [self showErrorWithText:errorStr];
             return NO;
        }
        NSString *discountRateStr = _percentField.text;
        if(![discountRateStr isPureFloat] || discountRateStr.floatValue <= 0) {
            [self showErrorWithText:@"贴现率输入不正确"];
            return NO;
        }else if (discountRateStr.floatValue >= 100) {
            [self showErrorWithText:@"贴现率不能大于等于100"];
            return NO;
        }
    
        /** 票源地址 */
        if (_addressArr.count == 0) {
            [self showErrorWithText:@"票源地址不能为空"];
            return NO;
        }
    if (self.buyType == SpecifiedBuying) {
        NSString *counterParty = _appointorLabel.text;
        if (!counterParty || counterParty.length == 0) {
            [self showErrorWithText:@"公司名称输入不能为空"];
            return NO;
        }
    }
    
    if (self.buyType == SpecifiedBuying) {
        if (!self.counterPartyId) {
            [self showErrorWithText:@"公司名称输入错误"];
            return NO;
        }
    }

    return YES;
}

#pragma mark - 提交按钮
- (void)okClick{
    
    if (![self checkAllIsOk]) {
        return;
    }
       /** 询价金额 */
    self.askBuyDict[@"TotalAmount"] = @(_askMoneyField.text.floatValue*10000);

       /** 贴现率 */
    self.askBuyDict[@"DiscountRate"] = @(_percentField.text.floatValue);

    NSMutableString *ss = [NSMutableString string];
    for (NSString *str in _addressArr) {
        [ss appendFormat:@"%@,",str];
    }
    NSRange range = {ss.length - 1 ,1};
    [ss replaceCharactersInRange:range withString:@""];
    self.askBuyDict[@"Address"]  = ss;
    
    if (self.buyType == SpecifiedBuying) {
        self.askBuyDict[@"CounterPartyId"] = self.counterPartyId;
    }
   
    if (self.buyType == AskBuying) {
        self.askBuyDict[@"TradeType"] = @(2);
    }else{
        self.askBuyDict[@"TradeType"] = @(1);
    }
    
    self.askBuyDict[@"BillType"] = @(1);
    self.askBuyDict[@"AcceptorIdentityType"] = @(1);
    self.askBuyDict[@"HolderType"] = @(0);
    self.askBuyDict[@"HolderIdentityType"] =@(0);

    if (self.askBuyDelegate && [self.askBuyDelegate respondsToSelector:@selector(oKClickWithAskBuyDict:)]) {
        [self.askBuyDelegate oKClickWithAskBuyDict:self.askBuyDict];
    }
    
}

//每个cell左边的title
- (UILabel *)getTitleLabel:(NSString *)title frame:(CGRect)rect{
    UILabel *label = [UILabel labelWithText:title fontSize:12 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    label.frame = rect;
    return label;
}

- (UITextField *)getTextField:(NSString *)placeholder{
    UITextField *field = [UITextField textFieldWithText:nil clearButtonMode:UITextFieldViewModeNever placeholder:placeholder font:12 textColor:[UIColor colorWithRGBHex:0xfefefe]]; // 0x1a2d44
    field.delegate = self;
  
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:placeholder];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGBHex:0x707070]} range:NSMakeRange(0, placeholder.length)];
    field.attributedPlaceholder = att;
    
    return  field;
}

#pragma mark - 选择地址 / 选择交易对手
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 9 && self.buyType == AskBuying) {
        if (self.askBuyDelegate && [self.askBuyDelegate respondsToSelector:@selector(addressSelect: AskBuyTableView:)]) {
            [self.askBuyDelegate addressSelect:_addressArr AskBuyTableView:self];
        }
    }
    if (indexPath.section == 7 && self.buyType == SpecifiedBuying) {
        if (self.askBuyDelegate && [self.askBuyDelegate respondsToSelector:@selector(addressSelect: AskBuyTableView:)]) {
            [self.askBuyDelegate addressSelect:_addressArr AskBuyTableView:self];
        }
    }
    
    if (indexPath.section == 8 && self.buyType == SpecifiedBuying) {
        if (self.askBuyDelegate && [self.askBuyDelegate respondsToSelector:@selector(counterPartySelect:AskBuyTableView:)]) {
            [self.askBuyDelegate counterPartySelect:_appointorLabel.text AskBuyTableView:self];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (void)setCounterParty:(NSString *)counterParty{
    if (self.buyType == SpecifiedBuying) {
        _appointorLabel.text = counterParty;
    }
}

- (void)setCounterPartyName:(NSString *)counterPartyName{
    _counterPartyName = counterPartyName;
    if (self.buyType == SpecifiedBuying) {
        _appointorLabel.text = counterPartyName;
    }
}

- (void)setCounterPartyId:(NSNumber *)counterPartyId{

}

//承兑人类型
-(NSNumber *)getAcceptorTypeWithStr:(NSString *)str
{
    NSInteger type = [_cell1Items indexOfObject:str];
    return @(type+1);
}

//票据期限类型
-(NSNumber *)getDueTimeRangeTypeWithStr:(NSString *)str
{
    NSInteger type = [_cell2Items indexOfObject:str];
    return @(type+3);
}

//交割时间
- (NSNumber *)getTradeTimeWithStr:(NSString *)str{
    NSInteger  type = [_cell3Items indexOfObject:str];
    return  @(type);
}

- (NSNumber *)getNeedOrCanReceiptWithStr:(NSString *)str{
    NSInteger type = [_cell4Items indexOfObject:str];
    return @(type);
}

//目标客户
- (NSNumber *)getTargetCustomerWithStr:(NSString *)str{
    NSInteger type = [_cell5Items indexOfObject:str];
    return @(type);
}




@end
