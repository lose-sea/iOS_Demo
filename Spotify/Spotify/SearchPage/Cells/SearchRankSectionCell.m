//
//  SearchRankSectionCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchRankSectionCell.h"
#import "SearchRankCardCell.h"
#import <Masonry/Masonry.h>

static NSString * const kRankCardCellID = @"SearchRankCardCell";
static const CGFloat kSectionTitleHeight = 44.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kCardWidthRatio = 0.78;   // 卡片宽度占 cell 宽度比例

@interface SearchRankSectionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<SearchRankCard *> *cards;
@property (nonatomic, assign) CGFloat lastLayoutWidth;

@end

@implementation SearchRankSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"排行榜";
    self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.titleLabel];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 12.0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SearchRankCardCell class] forCellWithReuseIdentifier:kRankCardCellID];
    [self.contentView addSubview:self.collectionView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8.0);
        make.left.equalTo(self.contentView).offset(kHorizontalInset);
        make.height.mas_equalTo(kSectionTitleHeight);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Public

- (void)configureWithCards:(NSArray<SearchRankCard *> *)cards {
    self.cards = cards ?: @[];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

+ (CGFloat)height {
    return 8.0 + kSectionTitleHeight + [SearchRankCardCell cardHeight] + 8.0;
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];

    // 卡片宽度要等 cell 宽度确定后再算
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    if (width > 0 && fabs(width - self.lastLayoutWidth) > 0.5) {
        self.lastLayoutWidth = width;
        self.layout.itemSize = CGSizeMake(width * kCardWidthRatio, [SearchRankCardCell cardHeight]);
        self.layout.sectionInset = UIEdgeInsetsMake(0, kHorizontalInset, 0, kHorizontalInset);
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchRankCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRankCardCellID
                                                                        forIndexPath:indexPath];
    cell.onSelectWord = ^(NSString *word) {
        if ([self.delegate respondsToSelector:@selector(rankSectionCell:didSelectWord:)]) {
            [self.delegate rankSectionCell:self didSelectWord:word];
        }
    };
    [cell configureWithCard:self.cards[indexPath.item]];
    return cell;
}

@end
