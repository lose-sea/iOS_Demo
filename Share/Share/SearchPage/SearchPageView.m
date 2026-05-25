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
        [self setCollectionView];
    }
    return self;
}

- (void) setCollectionView {
    // 布局
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 每个cell的大小
    flowLayout.itemSize = CGSizeMake(80, 20);
    // 同一行中 cell 之间的间隔
    flowLayout.minimumLineSpacing = 10;
    // 行与行之间的间隔
    flowLayout.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(400);
        make.width.mas_equalTo(self);
    }];
    
    // 注册cell
    [self.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: @"collectionViewCellID"];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
