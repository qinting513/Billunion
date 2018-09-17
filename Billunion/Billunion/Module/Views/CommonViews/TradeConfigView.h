//
//  TradeConfigView.h
//  Billunion
//
//  Created by Waki on 2017/3/22.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  TradeConfigViewDelegate;

typedef NS_ENUM(NSInteger , TradeConfigViewType) {
    TradeConfigViewType_sellerMarket,   //卖方市场 点击报价
    TradeConfigViewType_buyerMarket,    //买方市场 点击卖出
    TradeConfigViewType_buyerOffer,     //报价买入
    TradeConfigViewType_sellerInquiry,  //询价卖出 发布
    TradeConfigViewType_sellerSpecify,  //指定卖出 发布
    TradeConfigViewType_beBuyerSpecify, //被指定买入
    TradeConfigViewType_other           //其余的页面类型
};
@interface TradeConfigView : UIView

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UIButton * transactionBtn;
@property (nonatomic, assign) CGFloat topViewH;

//@property (nonatomic, strong) UIButton *deliveryBtn;  //交割时间按钮
//@property (nonatomic, strong) UIButton *anonymousBtn;  //是否匿名按钮
//@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, assign) NSInteger delivery;  //交割时间按钮
@property (nonatomic, assign) NSInteger select1Index;  //第一排选择btn的下标
@property (nonatomic, assign) NSInteger select2Index;  //第二排选择btn的下标
@property (nonatomic, assign) NSInteger select3Index;  //第三排选择btn的下标

@property (nonatomic, strong) UITextField *discountRateField;

@property (nonatomic, copy) NSString *counterPartyName;

@property (nonatomic, assign) TradeConfigViewType type;
@property (nonatomic, assign) id<TradeConfigViewDelegate>delegate;

- (instancetype)initWithKlineType:(TradeConfigViewType)type;

- (void)setAmcountWithAmcount:(NSString *)amcount discountRate:(NSString *)discountRate;

@end


@protocol TradeConfigViewDelegate <NSObject>

@optional
- (void)didEnterTextField:(NSString *)text;

- (void)beginSelectCounterParty:(NSString *)currentStr;

- (void)okClick;

@end