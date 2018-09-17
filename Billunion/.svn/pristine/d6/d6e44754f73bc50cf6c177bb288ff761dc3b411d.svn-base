//
//  AskBuyTableView.h
//  Billunion
//
//  Created by Waki on 2017/1/4.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AskBuyTableViewDelegate;
@interface AskBuyTableView : UITableView

@property (nonatomic ,assign) BUYING_TYPE buyType;
@property (nonatomic,assign) id<AskBuyTableViewDelegate>askBuyDelegate;

@property (nonatomic,copy) NSString *counterPartyName;
@property (nonatomic,strong) NSNumber *counterPartyId;

-(void)setAddressLabelWith:(NSArray *)arr;

@end

@protocol AskBuyTableViewDelegate <NSObject>

- (void)addressSelect:(NSArray *)addressArr AskBuyTableView:(AskBuyTableView *)aksTableView;

- (void)counterPartySelect:(NSString *)counterParty AskBuyTableView:(AskBuyTableView *)aksTableView;

- (void)oKClickWithAskBuyDict:(NSMutableDictionary *)askBuyDict;


@end
