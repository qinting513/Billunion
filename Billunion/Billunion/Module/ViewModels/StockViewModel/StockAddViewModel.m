//
//  StockAddViewModel.m
//  Billunion
//
//  Created by QT on 17/2/7.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "StockAddViewModel.h"
#import "FGNetworking.h"

/** 票据添加的ViewModel */

@implementation StockAddViewModel

+ (void)stockAddWithParams:(NSDictionary *)params response:(void (^)(BOOL, NSString *))block{

    NSDictionary *addParams = @{@"OperType":@706,
                                       @"Param":params};
    
//    NSDictionary *addParams;
//    addParams =@{
//            @"OperType" : @706,
//            @"Param" : @{
//                @"BillType":@1,
//                @"Acceptor":@"JM",
//                @"Address": @"广州市天河区",
//                @"Amount" : @111,
//                @"BillNum" : @12345678,
//                @"ExpireDate" : @"2017-02-23",
//                @"ReleaseDate" : @"2017-02-22",
//                @"Remarks" : @"JMAdd"
//        }
//    };

    DEBUGLOG(@"%@ \n %@",PROPERTY_BILLRELEASE,addParams);
    
     [FGNetworking requsetWithPath:PROPERTY_BILLRELEASE params:addParams method:Post handleBlcok:^(id response, NSError *error) {
        if (!error) {
            DEBUGLOG(@"%@ \n %@",PROPERTY_BILLRELEASE,response);
            if ([response[@"Status"] intValue] == 0) {
                block(YES,NSLocalizedString(@"ADD_OK", nil) );
            }else{
                block(NO,NSLocalizedString(@"ADD_FAIL", nil) );
            }
        }else{
           block(NO,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }
    }];
   
}

// 正面图片positiveImage  反面图片backImage 其他图片otherImage
+ (void)uploadImage:(UIImage *)image
          imageName:(NSString *)imageName
           progress:(void (^)(CGFloat progressValue))progress
           response:(void (^)(NSString *imageUrl, NSString *errorStr))block{
    
    if (image == nil) {
            return;
        }
    if ([imageName isEqualToString:kPositiveImage]) {
        [FGNetworking uploadImage:image path:POSTIVE_IMAGE_UPLOAD imageName:imageName params:nil progress:^(CGFloat progressValue) {
            progress(progressValue);
        } success:^(id response) {
            if (response[@"Data"] && [response[@"Status"] integerValue] == 0) {
                block(response[@"Data"],nil);
            }else{
                   block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
        } failure:^(NSError *error) {
              block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }];
    }else if ([imageName isEqualToString:kBackImage]){
        [FGNetworking uploadImage:image path:BACK_IMAGE_UPLOAD imageName:imageName params:nil progress:^(CGFloat progressValue) {
            progress(progressValue);
        } success:^(id response) {
            if (response[@"Data"] && [response[@"Status"] integerValue] == 0) {
                  block(response[@"Data"],nil);
            }else{
                   block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
        } failure:^(NSError *error) {
                 block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }];

    }else if ([imageName isEqualToString:kOtherImage]){
        [FGNetworking uploadImage:image path:OTHER_IMAGE_UPLOAD imageName:imageName params:nil progress:^(CGFloat progressValue) {
                progress(progressValue);
        } success:^(id response) {
            if (response[@"Data"] && [response[@"Status"] integerValue] == 0) {
                  block(response[@"Data"],nil);
            }else{
                  block(nil,NSLocalizedString(@"ERROR_DATA", nil) );
            }
        } failure:^(NSError *error) {
                 block(nil,NSLocalizedString(@"ERROR_NETWORK", nil) );
        }];
    }
}

@end
