//
//  BuyerInfoViewController.h
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BaseViewController.h"
#import "InquiryInfoViewModel.h"

@interface BuyerInfoViewController : BaseViewController

@property (nonatomic,assign) TransactionType transactionType;

@property (nonatomic,strong) InquiryInfoViewModel *inquiryInfoVM;


@end
