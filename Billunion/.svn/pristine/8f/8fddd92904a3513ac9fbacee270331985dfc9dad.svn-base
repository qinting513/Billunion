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
    InfoMationViewType_IsAnonymous,  //是否匿名的弹窗
    InfoMationViewType_InPut_DiscountRate,//输入贴现率
    InfoMationViewType_InPut_counterPartyId //输入交易对手
};
typedef void(^DeliveryViewBlock) (BOOL isSureBtn,NSDictionary *dict);
typedef void (^IsAnonymousViewBlock) (BOOL isSureBtn,BOOL isAnoymous);
typedef void(^InputTextViewBlock)(BOOL isSureBtn,NSString *message);

@interface InfoMationView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showWithType:(InfoMationViewType)type;
//- (void)hideWithType:(InfoMationViewType)type;

@property (nonatomic,copy)DeliveryViewBlock deliveryViewBlock;
@property (nonatomic,copy)IsAnonymousViewBlock isAnonymousViewBlock;
@property (nonatomic,copy) InputTextViewBlock inputTextViewBlock;

@property (nonatomic,copy) NSString *inputViewStr;

@end

#define Delivery      @"delivery"  //交割时间
#define Anonymous     @"anonymous"  // 是否匿名
#define DiscountRate  @"discountRate" //贴现率

@interface DeliveryView : UIView

@property (nonatomic,copy)DeliveryViewBlock deliveryViewBlock;

@end


@interface IsAnonymousView : UIView

@property (nonatomic,copy)IsAnonymousViewBlock isAnonymousViewBlock;

@end


@interface InPutTextView : UIView


@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *discountRate;
@property (nonatomic,assign) InfoMationViewType type;
@property (nonatomic,copy) InputTextViewBlock inputTextViewBlock;


@end
