//
//  StockAddViewModel.h
//  Billunion
//
//  Created by QT on 17/2/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPositiveImage @"positiveImage"
#define kBackImage     @"backImage"
#define kOtherImage    @"otherImage"

@interface StockAddViewModel : NSObject

+ (void)stockAddWithParams:(NSDictionary *)params response:(void(^)(BOOL isSucceed,NSString *message))block;


+ (void)uploadImage:(UIImage *)image
          imageName:(NSString *)imageName
           progress:(void (^)(CGFloat progressValue))progress
           response:(void (^)(NSString *imageUrl, NSString *errorStr))block;

@end
