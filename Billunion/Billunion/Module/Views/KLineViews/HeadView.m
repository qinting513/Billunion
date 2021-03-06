//
//  HeadView.m
//  Billunion
//
//  Created by QT on 17/2/17.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "HeadView.h"


@interface HeadView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;


@end

@implementation HeadView

-(instancetype)initWithFrame:(CGRect)frame imgs:(NSArray *)imgs
{
    if (self = [super initWithFrame:frame]) {
        self.imgs = imgs;
        if (self.imgs.count == 0) {
            self.imgs = @[@"none_logo",@"none_logo"];
        }
        [self collectionView];
    }
    return self;
}

static NSString *cellID = @"ImageCell";
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        fl.itemSize = CGSizeMake( (WIDTH- 2)/2, self.height);
        fl.minimumLineSpacing = 2;
        fl.minimumInteritemSpacing = 0;
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGRect frame = CGRectMake(0, 0, WIDTH,self.height);
        _collectionView = [[UICollectionView alloc]initWithFrame:frame
                                            collectionViewLayout:fl];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.pagingEnabled = YES;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - collectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:100];
    if (!imageView) {
       imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
       imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [imageView addGestureRecognizer:tap];
        
    }
    id model = self.imgs[indexPath.row];
    if ([model isKindOfClass:[UIImage class]]) {
          imageView.image = self.imgs[indexPath.row];
    }else if ([model isKindOfClass:[NSString class]]){
        NSString *name = (NSString *)model;
        if ([name containsString:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"none_logo"]];
        }else{
          imageView.image = [UIImage imageNamed:name];
        }
    }

    cell.backgroundColor = MainColor;
    return cell;
}

-(void)handleTap:(UITapGestureRecognizer*)tap
{
    UIView *view = tap.view;
    UICollectionViewCell *cell = ( UICollectionViewCell * )view.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    !self.headViewBrowsePhotoBlock ?: self.headViewBrowsePhotoBlock(self.imgs,indexPath.row);
}

-(void)setImgs:(NSArray *)imgs
{
    _imgs = imgs;
    if (_imgs.count == 0) {
        _imgs = @[@"none_logo",@"none_logo"];
    }
    [self.collectionView reloadData];
}

@end
