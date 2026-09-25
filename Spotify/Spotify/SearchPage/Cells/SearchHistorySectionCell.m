//
//  SearchHistorySectionCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchHistorySectionCell.h"
#import "SearchHistoryChipCell.h"
#import <Masonry/Masonry.h>

static NSString * const kHistoryChipCellID = @"SearchHistoryChipCell";
static const CGFloat kChipHeight = 32.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kChipSpacing = 8.0;
static const CGFloat kSectionHeight = 52.0;

@interface SearchHistorySectionCell () <UICollectionViewDelegate, UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *words;

@end

@implementation SearchHistorySectionCell

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

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = kChipSpacing;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SearchHistoryChipCell class]
            forCellWithReuseIdentifier:kHistoryChipCellID];
    [self.contentView addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kHorizontalInset);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(kChipHeight);
    }];
}

#pragma mark - Public

- (void)configureWithWords:(NSArray<NSString *> *)words {
    self.words = words ?: @[];
    [self.collectionView reloadData];
}

+ (CGFloat)height {
    return kSectionHeight;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.words.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchHistoryChipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHistoryChipCellID
                                                                           forIndexPath:indexPath];
    cell.word = self.words[indexPath.item];

    __weak typeof(self) weakSelf = self;
    cell.onDelete = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(historySectionCell:didDeleteWordAtIndex:)]) {
            [weakSelf.delegate historySectionCell:weakSelf didDeleteWordAtIndex:indexPath.item];
        }
    };
    return cell;
}

/// 每个胶囊按文字宽度自适应
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([SearchHistoryChipCell widthForWord:self.words[indexPath.item]], kChipHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(historySectionCell:didSelectWord:)]) {
        [self.delegate historySectionCell:self didSelectWord:self.words[indexPath.item]];
    }
}

@end
