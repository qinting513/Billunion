//
//  MoreIndexCollectionView.m
//  Billunion
//
//  Created by QT on 17/1/24.
//  Copyright © 2017年 JM. All rights reserved.
//

#import "MoreIndexCollectionView.h"

#import "MoreIndexCell.h"
#import "MoreIndexHeadView.h"
#import "MoreIndexModel.h"

@interface MoreIndexCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)NSArray *dataList;

@end

@implementation MoreIndexCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerClass:[MoreIndexCell class]
           forCellWithReuseIdentifier:cellID];
        [self registerClass:[MoreIndexHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID];
        self.dataSource = self;
        self.delegate   = self;
        self.numPage = 1;

    }
    return self;
}

-(void)setModel:(id)model
{
    if ([model isKindOfClass:[MoreIndexModel class]]) {
          _model = model;
        self.dataList = [self getCorrectOrder:((MoreIndexModel*)model).AcceptorTypeRateResultList ];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
        });
        ;
    }
   
}

-(NSArray *)getCorrectOrder:(NSArray *)arr{
    NSArray *correctOrderArr1 = @[@1,@2,@3,@4,@5,@6,@11,@7,@8,@9,@10,@12];
    NSArray *correctOrderArr2 = @[@1,@2,@3,@4,@5];
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSArray *order ;
    if (correctOrderArr1.count == arr.count ) {
        order = correctOrderArr1;
    }else   if (correctOrderArr2.count == arr.count ) {
        order = correctOrderArr2;
    }else{
        return nil;
    }
    
    for (NSNumber *num in order) {
        for (MoreIndexModel*model in arr) {
            if (num.integerValue == model.AcceptorType.integerValue && model != nil) {
                [mutableArr addObject:model];
            }
        }
    }
    return mutableArr;
}


#pragma mark - collectionView DataSource

static NSString *cellID = @"MoreIndexCell";
static NSString *headID = @"MoreIndexHeadView";

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreIndexCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        MoreIndexHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID forIndexPath:indexPath];
        reusableview = headerView;
        headerView.model = self.model;
    }
    return reusableview;
}


#pragma mark - collectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select item:%ld == %ld",indexPath.section, indexPath.row);
    MoreIndexModel* model  = self.dataList[indexPath.row];
    if (self.block) {
        self.block(self,model.AcceptorType);
    }
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}


@end
