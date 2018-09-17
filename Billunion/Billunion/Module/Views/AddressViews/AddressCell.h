//
//  AddressCell.h
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressCellDelegate;
@interface AddressCell : UITableViewCell

@property (nonatomic, assign) id<AddressCellDelegate>delegate;
- (void)setCellInfo:(NSString *)address isSelect:(BOOL)isSelect section:(NSInteger)section;
@end


@protocol AddressCellDelegate <NSObject>

- (void)didSelectWithButtonIndex:(NSInteger)index section:(NSInteger)section;

@end
