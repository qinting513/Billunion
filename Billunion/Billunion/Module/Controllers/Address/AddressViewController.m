

//
//  AddressViewController.m
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"
#import "AddressViewModel.h"
#import "AddAddressViewController.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressCellDelegate>{

    UITableView *_tableView;
}

@property (strong,nonatomic) AddressViewModel *addressViewModel;
@end

@implementation AddressViewController

- (AddressViewModel *)addressViewModel{
    if (!_addressViewModel) {
        _addressViewModel = [[AddressViewModel alloc] init];
    }
    return _addressViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SelectedAddress", nil);
    [self setupBakcButton];
        
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-40) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
    [self addBottomButton];
    [self addRightItem];
    
}

- (void)addRightItem{
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"Sure", nil) titleFont:14 titleColor:[UIColor whiteColor] target:self action:@selector(didAddressSelect)];
    button.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = itme;
}

//选择地址 返回上一级页面
- (void)didAddressSelect{
   NSString *normalAddress = [self.addressViewModel getNormalAddress];
    NSArray *strArr = [normalAddress componentsSeparatedByString:@"&"];
    NSMutableString *MString = [[NSMutableString alloc] init];
    for (NSString *aString in strArr) {
        [MString appendString:aString];
    }
    
      NSString *str = nil;
    if (strArr.count >= 1) {
        str = strArr[1];
        if ([str containsString:@"市"]) {
            NSRange r = [str rangeOfString:@"市"];
            str = [str substringToIndex:r.location];
        }
    }
   
    
    if (self.normalBlock) {
        self.normalBlock(MString,str);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressViewModel.addressArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (!cell) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
    }
    cell.backgroundColor = [UIColor colorWithRGBHex:0x141414];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSString *address = [self.addressViewModel getAddressWithSection:indexPath.section];
    BOOL isSelect = [self.addressViewModel getIsSelectWithSection:indexPath.section];

    [cell setCellInfo:address isSelect:isSelect section:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma pmark - AddressCellDelegate
- (void)didSelectWithButtonIndex:(NSInteger)index section:(NSInteger)section{
    
    if (index == 0) {
        //更换默认地址
        [self.addressViewModel resetNormalAddressWithSection:section];
        [_tableView reloadData];
    }else if (index == 1){
        //编辑修改地址
        AddAddressViewController *addCtl = [[AddAddressViewController alloc] init];
        addCtl.pushAddress = [_addressViewModel getAddressWithSection:section];
        addCtl.selections = [_addressViewModel getSelectionWithSection:section];
        __weak AddressViewModel *weakAddressViewModel = _addressViewModel;
        __weak UITableView *weakTableView= _tableView;
        addCtl.myBlock = ^(NSString *address,NSArray *selections){
            [weakAddressViewModel resetAddressWithWithAddress:address
                                                   selections:selections
                                                      section:section];
            [weakTableView reloadData];
        };
        [self.navigationController pushViewController:addCtl animated:YES];
    }else{
        //删除地址
        NSString *address = [_addressViewModel getAddressWithSection:section];
        NSMutableString *MString = [[NSMutableString alloc] init];
        for (NSString *aString in [address componentsSeparatedByString:@"&"]) {
            [MString appendString:aString];
        }

        __weak AddressViewModel *weakAddressViewModel = _addressViewModel;
        __weak UITableView *weakTableView= _tableView;
      [UIAlertController alertControllerWithTitle:NSLocalizedString(@"IS_DELETE_ADDRESS", nil)  message:MString okTitle:NSLocalizedString(@"SURE_DEL", nil)  cancelTtile:NSLocalizedString(@"CANCEL_DEL", nil)  target:self clickBlock:^(BOOL ok, BOOL cancel) {
        if (ok) {
            [weakAddressViewModel deleteAddressWith:section];
             [weakTableView reloadData];
        }
        }];
        
    }
}


- (void)addBottomButton{
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"ADD_NEW_ADDRESS", nil)  titleFont:13 titleColor:[UIColor whiteColor] target:self action:@selector(addAddress)];
    button.backgroundColor = [UIColor colorWithRGBHex:0x3788e9];
    [self.view addSubview:button];
    
    button.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(40);
}

- (void)addAddress{
    AddAddressViewController *addCtl = [[AddAddressViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    addCtl.myBlock = ^(NSString *address,NSArray *selections){
        [weakSelf updataAssressListWithAddress:address selections:selections];
    };
    [self.navigationController pushViewController:addCtl animated:YES];
}

- (void)updataAssressListWithAddress:(NSString *)address selections:(NSArray *)selections{

    [_addressViewModel saveAddressWithAddress:address selections:selections];
    [_tableView reloadData];
}



@end
