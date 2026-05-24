//
//  SearchPageView.m
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import "SearchPageView.h"

@implementation SearchPageView

- (void) setCollectionView {
    self.collectionView = [[UICollectionView alloc] init];
    
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(400);
        make.width.mas_equalTo(self);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
