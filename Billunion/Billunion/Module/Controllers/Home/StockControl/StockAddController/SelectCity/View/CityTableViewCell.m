//
//  CityTableViewCell.m
//  MySelectCityDemo
//
//  Created by ZJ on 15/10/28.
//  Copyright © 2015年 WXDL. All rights reserved.
//

#import "CityTableViewCell.h"

#define  ScreenWidth [UIScreen mainScreen].bounds.size.width
#define  kLeftMargin 20
#define  kBtnTag 600
#define  cellHeight 35-1

@interface CityTableViewCell()<UIScrollViewDelegate>


@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat scrollViewWidth;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,assign) BOOL isAddStock;
@end

@implementation CityTableViewCell


-(NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}

-(void)setCellInfo:(NSArray *)array isAddStock:(BOOL)isAddStock
{
    
    self.cityArray = [array mutableCopy];
    _isAddStock = isAddStock;
   
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollViewWidth = kLeftMargin;
    for(int i=0;i<array.count;i++)
    {
        NSString *cityName = array[i];
        CGFloat ww = [cityName getWidthWithLimitHeight:self.height fontSize:13.0f];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + kBtnTag;
        btn.frame = CGRectMake(self.scrollViewWidth, 0, ww, cellHeight);
        [btn setTitleColor:[UIColor colorWithRGBHex:0x939b9b] forState:UIControlStateNormal];
        [btn setTitle:cityName forState:0];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.scrollView addSubview:btn];
        
        self.scrollViewWidth = self.scrollViewWidth + ww + kLeftMargin;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollViewWidth, cellHeight);
    if (self.scrollViewWidth > WIDTH) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollViewWidth - WIDTH,self.scrollView.contentOffset.y) animated:YES];
    }
    
}


-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, cellHeight)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(WIDTH, cellHeight );
        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}

-(void)click:(UIButton *)btn
{
    if (!_isAddStock) {
        [btn removeFromSuperview];
        [self.cityArray removeObject:btn.currentTitle];
        self.scrollViewWidth = kLeftMargin;
        for(int i=0;i<self.scrollView.subviews.count;i++)
        {
            UIView *vv = self.scrollView.subviews[i];
            vv.x = self.scrollViewWidth;
            self.scrollViewWidth = self.scrollViewWidth + vv.width + kLeftMargin;
        }
        !self.didSelectedBtnBlcok ?:  self.didSelectedBtnBlcok(self.cityArray);
    }else{
        // 只能单选一个城市 
        !self.didSelectedBtnBlcok ?:  self.didSelectedBtnBlcok(@[btn.currentTitle]);
    }
    
}
@end
