//
//  HomeViewModel.h
//  Billunion
//
//  Created by Waki on 2017/1/19.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HomeViewModel : NSObject

/** 普创指数 4个框的内容 */
+(void)requestIndexResponse:( void(^)(NSArray*dataArray,NSString *errorStr))block;

/** 请求系统公告列表或者系统资讯列表 */
+ (void)requestNoticeWithPage:(NSInteger)page itemNum:(NSInteger)num noticeType:(NoticeType)noticeType response:(void(^)(NSArray *dataArray,NSString *errorStr))block;

/** 请求 公告或者资讯 详情 */
+ (void)requestNoticeDetailWithId:(NSNumber *)newsId  noticeType:(NoticeType)noticeType response:(void(^)( id model,NSString *errorStr))block;


+ (NSNumber *)getNewsId:(id)noticeModel;
@end


