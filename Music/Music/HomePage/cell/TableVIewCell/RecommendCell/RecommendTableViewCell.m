//
//  RecommendCell.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}

- (void)setUpInterface {  
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 30;
    flowLayout.itemSize = CGSizeMake(120, 160);
    // 设置为横向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    [self.contentView addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.collectionView.showsHorizontalScrollIndicator = YES; // 显示水平滚动条
    
//    [self.collectionView registerClass: [DailyRecommendCell class] forCellWithReuseIdentifier: @"DailyRecommendCellID"];
//    
//    [self.collectionView registerClass: [RecommendPlayListCell class] forCellWithReuseIdentifier: @"RecommendPlayListCellID"];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
