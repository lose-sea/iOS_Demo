//
//  SearchPageView.m
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import "SearchPageView.h"

@implementation SearchPageView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpCollectionView];
    }
    return self;
}


- (void)setUpCollectionView {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 每个cell的大小
//    flowLayout.itemSize = CGSizeMake(80, 30);
    
    flowLayout.minimumLineSpacing = 5;
    
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.estimatedItemSize = CGSizeMake(100, 30);

    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(10, 20, 0, 20));
    }];
    
    // 注册cell
    [self.collectionView registerClass: [tagCollectionVIewCell class] forCellWithReuseIdentifier: @"collectionViewCellID"];
    
    // 注册辅助视图
    [self.collectionView  registerClass: [UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"SectionHeader"]; 
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
