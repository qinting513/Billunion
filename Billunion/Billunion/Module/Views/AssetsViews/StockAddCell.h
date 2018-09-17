//
//  StockAddCell.h
//  Billunion
//
//  Created by QT on 17/1/5.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StockAddCell : UITableViewCell
/** 标题 */
@property (nonatomic,strong)UILabel *titleLabel;
/** 输入框 */
@property (nonatomic,strong)UITextField *inputTF;

/** 单位： 万 */
@property (nonatomic,strong)UILabel *unitLabel;

/** 向右箭头 */
@property (nonatomic,strong)UIImageView *rightImgView;

//@property (nonatomic,assign) id <StockAddCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
                   indexPath:(NSIndexPath *)indexPath;
@end

