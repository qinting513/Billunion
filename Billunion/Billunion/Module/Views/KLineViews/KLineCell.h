//
//  KLineCell.h
//  Billunion
//
//  Created by Waki on 2017/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLineCellDelegate;
@interface KLineCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) id<KLineCellDelegate>delegate;

@end

@protocol KLineCellDelegate <NSObject>

- (void)klineViewTypeSelect:(NSInteger)index;

@end
