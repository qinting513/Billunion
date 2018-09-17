//
//  AddressViewModel.h
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressViewModel : NSObject


@property (nonatomic, readonly) NSMutableArray *addressArray;

/**
 根据集合下标获取对应model的地址

 @param section 指定集合的下标
 @return adddress
 */
- (NSString *)getAddressWithSection:(NSInteger)section;


/**
 根据集合下标获取对应model的选中状态

 @param section 指定集合的下标
 @return 选中的状态
 */
- (BOOL)getIsSelectWithSection:(NSInteger)section;


/**
 获取pickerView的三个下表的集合

 @param section 指定集合的下标
 @return 选择的pickerView的三个下表的集合
 */
- (NSArray *)getSelectionWithSection:(NSInteger)section;


/**
 重新设置默认地址

 @param section 集合下标
 */
- (void)resetNormalAddressWithSection:(NSInteger)section;



/**
 从新设置地址

 @param address 新地址
 @param selections 新地址对应pickerView的三个下标集合
 @param section 地址列表集合下标
 */
- (void)resetAddressWithWithAddress:(NSString *)address
                         selections:(NSArray *)selections
                            section:(NSInteger)section;


/**
 获取默认的地址

 @return 默认的地址
 */
- (NSString *)getNormalAddress;



//保存
- (void)saveAddressWithAddress:(NSString *)address selections:(NSArray *)selections;

//删除
- (void)deleteAddressWith:(NSInteger)section;

@end
