//
//  HomeCell.h
//  Billunion
//
//  Created by QT on 2017/3/30.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeCell;
@protocol HomeCellDelegate <NSObject>

-(void)homeCell:(HomeCell*)homeCell didSelectedIndex:(NSInteger)index;

@end

@interface HomeCell : UITableViewCell

@property (nonatomic,assign)  id<HomeCellDelegate> delegate;

@end
