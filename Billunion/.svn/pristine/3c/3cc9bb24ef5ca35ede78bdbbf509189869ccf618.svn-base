//
//  AddAddressViewController.h
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^MyBlock)(NSString *address,NSArray *selections);
@interface AddAddressViewController : BaseViewController

@property (nonatomic,strong) NSArray *selections; //!< 选择的三个下标
@property (nonatomic,copy) NSString *pushAddress; //!< 展示的地址

@property (nonatomic,copy) MyBlock myBlock; //!< 回调地址的block


@end
