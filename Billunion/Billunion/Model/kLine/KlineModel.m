

//
//  KlineModel.m
//  Billunion
//
//  Created by Waki on 2017/1/9.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "KlineModel.h"

@implementation KlineModel


+ (NSArray *)getDatas{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *lastDate = @"2017-3-10";
    for (int i = 0; i < 100; i++) {
        KlineModel *model = [[KlineModel alloc] init];
       // CGFloat pointY = arc4random()%10/100.0;
        
        int pointY1 = arc4random()%10;
        int pointY2;
        do {
          pointY2 = arc4random()%1000;
        } while (pointY2 < 100 || pointY2 == 1000);
        
        model.percent = [NSString stringWithFormat:@"%d.%d",pointY1,pointY2];
        NSArray *arr = [lastDate componentsSeparatedByString:@"-"];
        NSString *str1 = [arr firstObject];
        NSString *str2 = [arr objectAtIndex:1];
        NSString *str3 = [arr lastObject];
        
        if ([str3 intValue] < 30) {
            str3 = [NSString stringWithFormat:@"%d",([str3 intValue]+1)];
        }else{
            if ([str2 intValue] < 12) {
                  str2 = [NSString stringWithFormat:@"%d",([str2 intValue]+1)];
                  str3 = @"1";
            }else{
                str1 = [NSString stringWithFormat:@"%d",([str1 intValue]+1)];
                str2 = @"1";
                str3 =@"1";
            }
        }
        model.timeDate = [NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3];
        lastDate = model.timeDate;
        [array addObject:model];
    }
    return array;
}
@end
