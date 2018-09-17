//
//  BuyerInfoTool.m
//  Billunion
//
//  Created by QT on 17/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "BuyerInfoTool.h"

@implementation BuyerInfoTool


static  BuyerInfoTool  *shareSingleton = nil;

+( instancetype ) sharedTool  {
    
    static  dispatch_once_t  onceToken;
    
    dispatch_once ( &onceToken, ^ {
        
        shareSingleton  =  [[self alloc] init] ;
        
    } );
    
    return shareSingleton;
    
}

@end
