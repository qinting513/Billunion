//
//  MoreIndexCollectionView.h
//  Billunion
//
//  Created by QT on 17/1/24.
//  Copyright © 2017年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreIndexSelectBlock)(UICollectionView *collectionView,NSNumber *acceptorType);

@interface MoreIndexCollectionView : UICollectionView

@property (nonatomic,strong) id model;
/** 加载的页数 */
@property (nonatomic,assign) NSInteger numPage;

@property (nonatomic,copy) MoreIndexSelectBlock block;



@end
