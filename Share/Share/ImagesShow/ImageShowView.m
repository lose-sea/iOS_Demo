//
//  ImageShowView.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "ImageShowView.h"
#import "ImageShowCell.h"
@implementation ImageShowView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setCollectionView];
    }
    return self;
}


- (void) setCollectionView {
    // 布局
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 每个cell的大小
    flowLayout.itemSize = CGSizeMake(100, 130);
    
    // 行与行之间的间隔
    flowLayout.minimumLineSpacing = 0;
    // 同一行中 cell 之间的间隔
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
    }];
    
    // 注册cell
    [self.collectionView registerClass: [ImageShowCell class] forCellWithReuseIdentifier: @"collectionViewCellID"];
    
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
