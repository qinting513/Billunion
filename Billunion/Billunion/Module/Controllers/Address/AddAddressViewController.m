

//
//  AddAddressViewController.m
//  Billunion
//
//  Created by Waki on 2017/2/13.
//  Copyright © 2017年 JM. All rights reserved.
//


#define  topViewHeight 45
#import "AddAddressViewController.h"
#import "AddressViewModel.h"
#import "QTPlaceholderLabelTextView.h"

@interface AddAddressViewController ()<UITextViewDelegate,ActionSheetCustomPickerDelegate>
{
    UILabel *_addressLabel;
    NSString *_detailAddress;
}

@property (strong,nonatomic) QTPlaceholderLabelTextView *textView;


@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) ActionSheetCustomPicker *picker;


@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"ADD_NEW_ADDRESS", nil);
    self.view.backgroundColor = [UIColor blackColor];
    [self setupBakcButton];
    [self addRightItem];
    [self setupUI];
}

- (void)addRightItem{
    UIButton *button = [UIButton buttonWithTitle:@"保存" titleFont:14 titleColor:[UIColor whiteColor] target:self action:@selector(didAddressSave)];
    button.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = itme;
}


- (void)setupUI{
    [self layoutTopView];
    [self.view addSubview: self.textView];
    [self layoutPickerData];
}


- (void)layoutTopView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRGBHex:0x141414];
    button.frame = CGRectMake(0, 68, WIDTH, topViewHeight);
    [button addTarget:self action:@selector(selectAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [UILabel labelWithText:@"所在地区:" fontSize:14 textColor:[UIColor whiteColor] alignment:NSTextAlignmentLeft];
    label.frame = CGRectMake(15, 0, 70, button.height);
    [button addSubview:label];
    
    CGFloat rightViewHeight = button.height-7*2;
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-rightViewHeight, 7, rightViewHeight, rightViewHeight)];
    rightView.image = [UIImage imageNamed:@"right"];
    [button addSubview:rightView];
    
    //中间的label地址
    CGFloat addressLableX = label.x+label.width;
    _addressLabel = [UILabel labelWithText:@"请选择" fontSize:14 textColor:[UIColor colorWithWhite:1 alpha:0.5] alignment:NSTextAlignmentRight];
     _addressLabel.frame = CGRectMake(addressLableX, 0, WIDTH-addressLableX-rightViewHeight, button.height);
    [button addSubview:_addressLabel];
    

    [button addSubview:_addressLabel];
}

-(QTPlaceholderLabelTextView *)textView
{
    if (!_textView) {
        _textView = [[QTPlaceholderLabelTextView alloc]init];
        _textView.delegate = self;
        _textView.backgroundColor = MainColor;
        _textView.textColor = [UIColor colorWithRGBHex:0xffffff];
        _textView.placeholder = @"请填写详细地址...";
        _textView.font = [UIFont systemFontOfSize:14.0f];
        _textView.placeholderColor = [UIColor colorWithRGBHex:0x666666];
//        _textView.contentInset = UIEdgeInsetsMake(10, 20, 10, 10);
        _textView.scrollEnabled = NO;
        
        [self.view addSubview:_textView];
        _textView.frame = CGRectMake(0, 68+54+4, WIDTH, 90);
        
//        _textView.placeholderLabel.frame = CGRectMake(10, 10, WIDTH-20, 20);
    }
    return _textView;
}


- (void)layoutPickerData{
    if (self.pushAddress) {
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.pushAddress componentsSeparatedByString:@"&"]];
        if (array.count > 2) {
            NSMutableString *MString = [[NSMutableString alloc] init];
            NSMutableString *MString2 = [[NSMutableString alloc] init];
            for (int i = 0; i < array.count-1; i++) {
                [MString appendString:array[i]];
                [MString2 appendString:array[i]];
                [MString2 appendString:@"&"];
            }
            _addressLabel.text = MString;
            _detailAddress = MString2;
            _textView.text = [array lastObject];
        }else{
            _addressLabel.text = _pushAddress;
        }
        
    }
    if (self.selections.count) {
        self.index1 = [self.selections[0] integerValue];
        self.index2 = [self.selections[1] integerValue];
        self.index3 = [self.selections[2] integerValue];
    }
    // 一定要先加载出这三个数组，不然就蹦了
    [self calculateFirstData];
}

#pragma mark -  保存地址
- (void)didAddressSave{
    if (_detailAddress.length <= 0) {
         [self.view showWarning:@"请选择所在地区"];
        return;
    }
    
    // 回调到上一个界面
    NSString *detailAddress = [NSString stringWithFormat:@"%@%@",_detailAddress,_textView.text];
    if (self.myBlock) {
            self.myBlock(detailAddress,@[@(self.index1),@(self.index2),@(self.index3)]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
        return YES;
}

#pragma mark - 地址选择

- (void)loadFirstData
{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    self.addressArr = [jsonStr mj_JSONObject];
    
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        NSString *name = dict.allKeys.firstObject;
        [firstName addObject:name];
    }
    // 第一层是省份 分解出整个省份数组
    self.provinceArr = firstName;
}
- (void)selectAddressClick
{
    //    NSArray *initialSelection = @[@(self.index1), @(self.index2),@(self.index3)];
    // 点击的时候传三个index进去
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
    self.picker.tapDismissAction  = TapActionSuccess;
    // 可以自定义左边和右边的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"完成" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    
    //    [self.picker addCustomButtonWithTitle:@"再来一次" value:@(1)];
    [self.picker showActionSheetPicker];
}

// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    // 拿出省的数组
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    // 根据省的index1，默认是0，拿出对应省下面的市
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
    //                             index1对应省的字典         市的数组 index2市的字典   对应市的数组
    // 这里的allValue是取出来的大数组，取第0个就是需要的内容
    NSMutableArray *Marray = [NSMutableArray arrayWithArray:[[self.addressArr[self.index1] allValues][0][self.index2] allValues][0]];
    [Marray addObject:@"自定义"];
    self.districtArr = Marray;
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        case 2:return self.districtArr.count;
        default:break;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate Implementation

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component)
//    {
//        case 0: return SCREEN_WIDTH /4;
//        case 1: return SCREEN_WIDTH *3/8;
//        case 2: return SCREEN_WIDTH *3/8;
//        default:break;
//    }
//
//    return 0;
//}

/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        case 2:return self.districtArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        case 2: title =   self.districtArr[row];break;
        default:break;
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = MainColor;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:
        {
            self.index2 = row;
            self.index3 = 0;
            //            [self calculateData];
            [self calculateFirstData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:break;
    }
}
//
//- (void)calculateData
//{
//    [self loadFirstData];
//    NSDictionary *provincesDict = self.addressArr[self.index1];
//    NSMutableArray *countryArr1 = [[NSMutableArray alloc] init];
//    for (NSDictionary *contryDict in provincesDict.allValues.firstObject) {
//        NSString *name = contryDict.allKeys.firstObject;
//        [countryArr1 addObject:name];
//    }
//    self.countryArr = countryArr1;
//
//    self.districtArr = [provincesDict.allValues.firstObject[self.index2] allValues].firstObject;
//
//}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}
// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    if (self.index1 < self.provinceArr.count) {
        NSString *firstAddress = self.provinceArr[self.index1];
        [detailAddress appendString:firstAddress];
        [detailAddress appendString:@"&"];
    }
    if (self.index2 < self.countryArr.count) {
        NSString *secondAddress = self.countryArr[self.index2];
        [detailAddress appendString:secondAddress];
        [detailAddress appendString:@"&"];
    }
    if (self.index3 < self.districtArr.count) {
        NSString *thirfAddress = self.districtArr[self.index3];
        if (![thirfAddress isEqualToString:@"自定义"]) {
            [detailAddress appendString:thirfAddress];
            [detailAddress appendString:@"&"];
        }
    }
    // 此界面显示
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _detailAddress = detailAddress;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[detailAddress componentsSeparatedByString:@"&"]];
        NSMutableString *MString = [[NSMutableString alloc] init];
        for (int i = 0; i < array.count; i++) {
            [MString appendString:array[i]];
        }
    _addressLabel.text = MString;
}


- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}
-(NSArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}

- (NSArray *)districtArr
{
    if (_districtArr == nil) {
        _districtArr = [[NSArray alloc] init];
    }
    return _districtArr;
}

-(NSArray *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
