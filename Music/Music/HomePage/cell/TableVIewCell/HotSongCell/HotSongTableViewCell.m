//
//  HotSongTableViewCell.m
//  Music
//
//  Created by lose_sea on 2026/6/13.
//

#import "HotSongTableViewCell.h"

@implementation HotSongTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.itemSize = CGSizeMake(300, 70);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
//    self.collectionView.pagingEnabled = YES;
    
    
    [self.contentView addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.collectionView registerClass: [HotSongCell class] forCellWithReuseIdentifier: @"HotSongCellID"]; 
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
