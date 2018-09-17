//
//  ScrollLabelCell.h
//  Billunion
//
//  Created by Waki on 2017/1/3.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollLabelCell;
@protocol ScrollLabelCellDelegate <NSObject>

-(void)scrollLabelCell:(ScrollLabelCell*)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ScrollLabelCell : UITableViewCell

//- (void)setCellInfo:(NSString *)string;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign) id<ScrollLabelCellDelegate> delegate;

@property (nonatomic,strong)UIImageView *noticeImageView;

@end


