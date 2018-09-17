//
//  ButtonsCell.h
//  Billunion
//
//  Created by QT on 17/1/6.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonsCell;
@protocol ButtonsCellDelegate <NSObject>

-(void)buttonsCell:(ButtonsCell*)cell clickBtnAtIndex:(NSInteger)index kLineType:(KLINE_TYPE)kLineType;
@end

@interface ButtonsCell : UITableViewCell


@property (nonatomic,assign) id<ButtonsCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier KLineType:(KLINE_TYPE)kLineType;

-(void)updateButtonTitleWithTitles:(NSArray *)titles;

@end

