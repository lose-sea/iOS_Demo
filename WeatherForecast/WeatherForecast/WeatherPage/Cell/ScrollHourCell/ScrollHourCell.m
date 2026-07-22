//
//  ScrollHourCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import "ScrollHourCell.h"

@implementation ScrollHourCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}


- (void) setUpInterface {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIView* backView = [[UIView alloc] init];
    [self.contentView addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];

    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 25; 
    
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(60, 150);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: flowLayout];
    
    [backView addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backView);
    }];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass: [HourlyCell class] forCellWithReuseIdentifier: @"HourlyCellID"];
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
