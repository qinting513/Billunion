//
//  DeliveryView.h
//  Billunion
//
//  Created by QT on 17/2/20.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

/**  dict[@"delivery"] = [self getDeliveryWithTitle:self.deliveryBtn.currentTitle];
 dict[@"anonymous"] = [self getAnonymousWithTitle:self.anonymousBtn.currentTitle];
 dict[@"discountRate"]
 */

#define Delivery      @"delivery"  //交割时间
#define Anonymous     @"anonymous"  // 是否匿名
#define DiscountRate  @"discountRate" //贴现率

typedef void(^DeliveryViewBlock)(BOOL isSureBtn,NSDictionary *dict);

@interface DeliveryView : UIView

@property (nonatomic,copy)DeliveryViewBlock deliveryViewBlock;

-(void)show;

-(void)hide;

@end
