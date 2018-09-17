//
//  HomeNumberCell.h
//  PCStock
//
//  Created by Waki on 2016/12/29.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeNumberCellDelegate;
@interface HomeNumberCell : UITableViewCell

@property (nonatomic,assign) id<HomeNumberCellDelegate>delegate;

- (void)setCellInfo:(NSArray *)dataArray;
@end

@protocol HomeNumberCellDelegate <NSObject>

- (void)moreAction;

@end
