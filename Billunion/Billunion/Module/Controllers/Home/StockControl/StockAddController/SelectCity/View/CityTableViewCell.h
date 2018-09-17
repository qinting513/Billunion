//
//  CityTableViewCell.h
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell


@property (nonatomic,copy)void(^didSelectedBtnBlcok)( NSArray *cityArray);

-(void)setCellInfo:(NSArray *)array isAddStock:(BOOL)isAddStock;

@end
