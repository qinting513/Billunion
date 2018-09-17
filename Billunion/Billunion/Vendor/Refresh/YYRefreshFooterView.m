//
//  YYRefreshFooterView.m
//  Billunion
//
//  Created by QT on 17/1/21.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "YYRefreshFooterView.h"
#import "StockView.h"

typedef NS_ENUM(NSInteger,YYRrefreshControlState) {
    Normal = 0,
    Pulling = 1,
    Rrefreshing = 2,
};


@interface YYRefreshFooterView()

// 获取全局scrollView进行监听
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *leftScrollView;
/**
 *  本次demo中以上拉改变label显示文字为例;
 */
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) YYRrefreshControlState refreshState;

// 保存之前的状态作为判断
@property (nonatomic, assign) YYRrefreshControlState oldState;

/** 记录scrollView刚开始的inset */
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;

/** 箭头 */
@property (nonatomic,strong) UIImageView *arrowImageView;
/** 菊花 */
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@property (nonatomic,assign) BOOL isStockView;

@end

@implementation YYRefreshFooterView

/**
 *  刷新状态发生改变,进行对应的修改
 *
 *  @param refreshState 刷新状态
 */
-(void)setRefreshState:(YYRrefreshControlState)refreshState{
    // 这句话千万不能少,
    _refreshState = refreshState;
    UIEdgeInsets inset = self.scrollView.contentInset;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    switch (refreshState) {
        case Normal:
        {
            self.label.text = @"上拉刷新";
            if (self.oldState == Rrefreshing) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    if (happenOffsetY <= 0) {
                         self.scrollView.contentInset = UIEdgeInsetsMake(inset.top , inset.left, inset.bottom-64 + happenOffsetY, inset.right);
                        if (self.leftScrollView) {
                              self.leftScrollView.contentInset = UIEdgeInsetsMake(inset.top , inset.left, inset.bottom-64 + happenOffsetY, inset.right);
                        }
                    }else{
                        self.scrollView.contentInset = UIEdgeInsetsMake(inset.top , inset.left, inset.bottom-64, inset.right);
                        if (self.leftScrollView) {
                            self.leftScrollView.contentInset = UIEdgeInsetsMake(inset.top , inset.left, inset.bottom-64, inset.right);
                        }
                        
                    }
                   
                } completion:nil];
               
                if (_isStockView) {
                     self.frame = CGRectMake(0, HEIGHT, WIDTH, 64);
                } else{
                    self.y = self.scrollView.height  + happenOffsetY;
                }
            }
            self.scrollView.scrollEnabled = YES;
            if (self.leftScrollView) {
                self.leftScrollView.scrollEnabled = YES;
            }
            [UIView animateWithDuration:0.3 animations:^{
                 self.arrowImageView.transform=CGAffineTransformMakeRotation(M_PI);
            }];
            self.arrowImageView.hidden = NO;
            self.activityView.hidden = YES;
        }
            
            break;
        case Pulling:
        {
            self.label.text = @"释放刷新";
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2 - 0.01);
            }];
            break;
        }
        case Rrefreshing:
            
        {
            self.label.text = @"正在刷新";
            self.arrowImageView.hidden = YES;
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
          
            // 告知外界刷新了,相当于发送通知
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            [self.activityView startAnimating];
            [UIView animateWithDuration:0.3 animations:^{
                if (happenOffsetY <= 0) {
                     self.scrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + 64 - happenOffsetY, inset.right);
                    if (self.leftScrollView) {
                         self.leftScrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + 64 - happenOffsetY, inset.right);
                    }
                }else{
                    self.scrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + 64, inset.right);
                    if (self.leftScrollView) {
                         self.leftScrollView.contentInset = UIEdgeInsetsMake(inset.top, inset.left, inset.bottom + 64, inset.right);
                    }
                }
               
                if (_isStockView) {
                    self.frame = CGRectMake(0,  self.scrollView.height - 64 , WIDTH, 64);
                }else{
                    if (happenOffsetY <= 0) {
                        self.y = self.scrollView.height + happenOffsetY - 64;
                    }else{
                       self.y = self.scrollView.height  + happenOffsetY;
                    }
                  
                }
                
            } completion:nil];
            self.scrollView.scrollEnabled = NO;
            if (self.leftScrollView) {
                self.leftScrollView.scrollEnabled = NO;
            }
        }
            break;
            
        default:
            break;
    }
    self.oldState = refreshState;
    
}

/**
 *  提供给外界调用的方法,  .h文件里面有这个方法
 */
- (void)endRefreshing{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 1.把状态改为正常
        self.refreshState = Normal;
        // 2.恢复contentInset
        // 2.1在set方法里面修改
        [self.activityView stopAnimating];
//    });
}


/**
 *  重写initWithFrame,设置上拉刷新尺寸
 *
 *  @param frame 控件大小
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    
    //设置控件frame
    CGFloat refreshX = 0;
    CGFloat refreshY = [UIScreen mainScreen].bounds.size.height;
    CGFloat refreshH = 64;
    CGFloat refreshW = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:CGRectMake(refreshX, refreshY, refreshW, refreshH)];
    if (self) {
       // self.backgroundColor = [UIColor orangeColor];
        //自定义View
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.label.text = @"上拉刷新";
    [self addSubview:self.label];
    [self addSubview:self.arrowImageView];
 
}

/**
 *  该控件将要加载到哪个父类视图
 *
 *  @param newSuperview 父View
 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    [self removeObservers];
    
    //通过kvo,监听滚动
    if ([newSuperview isKindOfClass:[StockView class]]) {
        // 获取View进行强转, 通过kvo监听滚动
        _isStockView = YES;
        StockView *stockView =  (StockView *)newSuperview;
        self.scrollView = stockView.subsTablView;
        self.leftScrollView = stockView.leftTableView;
        [self addObserver];
    }else if([newSuperview isKindOfClass:[UIScrollView class]])
    {
        _isStockView = NO;
        self.scrollView = (UIScrollView *)newSuperview;
        [self addObserver];
    }
}

-(void)removeObservers{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)addObserver{
    // 监听scrollView的contentOffset
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self refreshChangeState:self.scrollView.contentOffset.y];
}

/**
 *  通过监听当前scrollView的状态,来改变refreshControl控件的状态
 */
- (void)refreshChangeState:(CGFloat)currentOffsetY{
    
    if ( self.refreshState == Rrefreshing) {
        return;
    }
    _scrollViewOriginalInset = self.scrollView.contentInset;
   // NSLog(@"-------------------  currentOffsetY: %lf",currentOffsetY);
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
     // NSLog(@"happenOffsetY: %lf",happenOffsetY);
    // 如果是向下滚动到看不见尾部控件，直接返回
    // if (currentOffsetY <= happenOffsetY) return;
    if (_isStockView) {
        
        if (happenOffsetY <= 0) {
            self.y = self.scrollView.height - currentOffsetY;
        }else{
            self.y = self.scrollView.contentSize.height - currentOffsetY;
        }
    }else{
           self.y =  self.scrollView.height + happenOffsetY;
    }
 
    
    if(self.scrollView.isDragging || self.leftScrollView.isDragging){
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.height;
        //    手拖动： Normal -> pulling, pulling-> normal
        if(self.refreshState == Pulling &&   currentOffsetY <= normal2pullingOffsetY  ){
            self.refreshState = Normal;
        }else if(self.refreshState == Normal && currentOffsetY > normal2pullingOffsetY){
            self.refreshState = Pulling;
            
        }
    }else{
        //    手松开：pulling -> refreshing 从拉拽状态 到 刷新状态
        if(self.refreshState == Pulling){
            self.refreshState = Rrefreshing;
            
        }
    }
    
}

/**
 *  移除监听方法
 */
- (void)dealloc{
   NSLog(@"footer dealloc--------");
}

#pragma mark - 懒加载控件 -
- (UILabel *)label{
    if (_label == nil) {
        // 这里就不做约束了, 直接 用frame代替
        CGFloat labelW = 100;
        CGFloat labelX = ([UIScreen mainScreen].bounds.size.width - labelW) / 2 + 10;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 10, labelW, 44)];
        // 文字居中
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textColor = [UIColor colorWithRed:90.0/255 green:90.0/255 blue:90.0/255 alpha:1.0];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
    }
    return _label;
}

-(UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        CGFloat x = self.label.x - 20;
        _arrowImageView.frame = CGRectMake(x, 10, 15, 40);
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _arrowImageView;
}
-(UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGFloat y = (self.height - 30)*0.5;
        CGFloat x = self.label.x - 20;
        _activityView.frame = CGRectMake(x, y, 30, 30);
        [self addSubview:_activityView];
    }
    return _activityView;
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

@end
