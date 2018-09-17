//
//  MapInfoView.h
//  Billunion
//
//  Created by QT on 17/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DidSelectIndexBlock)(NSInteger index);

@interface MapInfoView : UIView

@property (nonatomic,strong)NSArray *dataArr;

@property (nonatomic,copy) DidSelectIndexBlock didSelectIndexBlock;
/** 选择哪一个 就让那一个高亮 */
@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,strong) UITableView *tableView;

-(void)returnSelectedIndex:(NSInteger)index;

-(instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray*)dataArr;



@end
