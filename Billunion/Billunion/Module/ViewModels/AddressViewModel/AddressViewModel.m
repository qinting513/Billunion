

//
//  AddressViewModel.m
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AddressViewModel.h"
#import "AddressModel.h"

@interface AddressViewModel()

@property (strong, nonatomic) NSMutableArray *addressArray;

@end

@implementation AddressViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (NSMutableArray *)addressArray{
    return [NSMutableArray arrayWithArray:[AddressModel findAll]];
}


- (NSString *)getAddressWithSection:(NSInteger)section{
    AddressModel *model = self.addressArray[section];
    return model.address;
}

- (BOOL)getIsSelectWithSection:(NSInteger)section{
    AddressModel *model = self.addressArray[section];
    return model.isSelect;
}

- (NSArray *)getSelectionWithSection:(NSInteger)section{
    AddressModel *model = self.addressArray[section];
    return @[@(model.firstIndex),@(model.secondIndex),@(model.thirdIndex)];
}

- (void)resetNormalAddressWithSection:(NSInteger)section{
    for (int i = 0; i < self.addressArray.count; i++) {
        AddressModel *model = self.addressArray[i];
        model.isSelect = NO;
        [model saveOrUpdate];
    }
    AddressModel *model = self.addressArray[section];
    model.isSelect = YES;
    [model saveOrUpdate];
}

- (NSString *)getNormalAddress{
    AddressModel *model = [AddressModel findFirstByCriteria:@"WHERE isSelect = 1"];
    return model.address;
}

- (void)resetAddressWithWithAddress:(NSString *)address
                         selections:(NSArray *)selections
                            section:(NSInteger)section{
    AddressModel *model = self.addressArray[section];
    model.address = address;
    if (selections.count == 3) {
        model.firstIndex = [selections[0] intValue];
        model.secondIndex = [selections[1] intValue];
        model.thirdIndex = [selections[2] intValue];
        [model update];
    }
}


- (void)saveAddressWithAddress:(NSString *)address selections:(NSArray *)selections{
    AddressModel *model = [[AddressModel alloc] init];
    model.address = address;
    if (selections.count == 3) {
        model.firstIndex = [selections[0] intValue];
        model.secondIndex = [selections[1] intValue];
        model.thirdIndex = [selections[2] intValue];
        [model saveOrUpdate];
    }
}

- (void)deleteAddressWith:(NSInteger)section{
   AddressModel *model = self.addressArray[section];
    [self.addressArray removeObject:model];
    [model deleteObject];
}

@end
