//
//  SearchGuessSectionCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchGuessSectionCell.h"
#import "SearchHotWordCell.h"
#import <Masonry/Masonry.h>

static NSString * const kHotWordCellID = @"SearchHotWordCell";

static const CGFloat kSectionTitleHeight = 44.0;
static const CGFloat kWordRowHeight = 44.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kColumnSpacing = 8.0;
/// 每行放几列（想改列数直接改这里）
static const NSInteger kColumnCount = 3;

@interface SearchGuessSectionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) NSArray<NSString *> *words;
@property (nonatomic, assign) CGFloat lastLayoutWidth;

@end

@implementation SearchGuessSectionCell

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
    self.titleLabel.text = @"猜你喜欢";
    self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.titleLabel];

    self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.refreshButton setImage:[UIImage systemImageNamed:@"arrow.clockwise"] forState:UIControlStateNormal];
    self.refreshButton.tintColor = [UIColor secondaryLabelColor];
    [self.contentView addSubview:self.refreshButton];

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.layout.minimumLineSpacing = 0.0;
    self.layout.minimumInteritemSpacing = kColumnSpacing;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SearchHotWordCell class] forCellWithReuseIdentifier:kHotWordCellID];
    [self.contentView addSubview:self.collectionView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(kHorizontalInset);
        make.height.mas_equalTo(kSectionTitleHeight);
    }];

    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kHorizontalInset);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(36.0, 36.0));
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(kHorizontalInset);
        make.right.equalTo(self.contentView).offset(-kHorizontalInset);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Public

- (void)configureWithWords:(NSArray<NSString *> *)words {
    self.words = words ?: @[];
    [self.collectionView reloadData];
}

+ (CGFloat)heightForWordCount:(NSUInteger)wordCount {
    NSUInteger rows = (wordCount + kColumnCount - 1) / kColumnCount;
    return kSectionTitleHeight + rows * kWordRowHeight + 8.0;
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];

    // 每列宽度 = (可用宽度 - 列间距) / 列数
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    if (width > 0 && fabs(width - self.lastLayoutWidth) > 0.5) {
        self.lastLayoutWidth = width;
        CGFloat itemWidth = (width - kColumnSpacing * (kColumnCount - 1)) / kColumnCount;
        self.layout.itemSize = CGSizeMake(itemWidth, kWordRowHeight);
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.words.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchHotWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotWordCellID
                                                                        forIndexPath:indexPath];
    cell.rank = indexPath.item + 1;
    cell.word = self.words[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(guessSectionCell:didSelectWord:)]) {
        [self.delegate guessSectionCell:self didSelectWord:self.words[indexPath.item]];
    }
}

@end
