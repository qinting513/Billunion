//
//  InfoMationView.h
//  Billunion
//
//  Created by Waki on 2017/2/28.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InfoMationViewType) {
    InfoMationViewType_Delivery, //报价买入的弹窗
    InfoMationViewType_IsTrade,  //确定成交的弹窗
    InfoMationViewType_InPut_DiscountRate,//输入贴现率
    InfoMationViewType_InPut_counterPartyId //输入交易对手
};
typedef void(^DeliveryViewBlock) (BOOL isSureBtn,NSDictionary *dict);
typedef void (^IsTradeViewBlock) (BOOL isSureBtn);
typedef void(^InputTextViewBlock)(BOOL isSureBtn,NSString *message);



@interface InfoMationView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showWithType:(InfoMationViewType)type;
//- (void)hideWithType:(InfoMationViewType)type;

@property (nonatomic,copy)DeliveryViewBlock deliveryViewBlock;
@property (nonatomic,copy)IsTradeViewBlock isTradeViewBlock;
@property (nonatomic,copy) InputTextViewBlock inputTextViewBlock;

@property (nonatomic,copy) NSString *inputViewStr;
@property (nonatomic,copy) NSString *normalStr;



@end

#define Delivery      @"delivery"  //交割时间
#define Anonymous     @"anonymous"  // 是否匿名
#define DiscountRate  @"discountRate" //贴现率

@interface DeliveryView : UIView

@property (nonatomic,copy)DeliveryViewBlock deliveryViewBlock;
/** 贴现率 */
@property (nonatomic,strong)UITextField *rateTF;

@end


@interface IsTradeView : UIView

@property (nonatomic,copy) NSString *normalStr;
@property (nonatomic,copy) IsTradeViewBlock isTradeViewBlock;


@end


@interface InPutTextView : UIView


@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *discountRate;
@property (nonatomic,assign) InfoMationViewType type;
@property (nonatomic,copy) InputTextViewBlock inputTextViewBlock;

@property (nonatomic,strong) UITextField *textField;;
@end
