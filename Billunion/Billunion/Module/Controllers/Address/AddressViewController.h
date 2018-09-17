//
//  AddressViewController.h
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface AddressViewController : BaseViewController

@property (nonatomic,copy) void(^normalBlock)(NSString *address,NSString *selectedCity);

@end
