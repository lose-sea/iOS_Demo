//
//  HomeView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeView.h"

#pragma mark - 常量

NSString *const HomePlaylistCardsCellID = @"HomePlaylistCardsCell";
NSString *const HomeSongCellID = @"HomeSongCell";

/// 横向卡片尺寸
static const CGFloat kCardCoverSide = 150.0; // 方形封面边长 = 卡片宽
static const CGFloat kCardHeight = 188.0;    // 封面 150 + 标题/描述两行
/// Section 0 行高（卡片上下各留 12pt）
static const CGFloat kCardsRowHeight = kCardHeight + 12.0 * 2;
/// miniPlayer 高度 64 + 上下间距各 12
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 12.0 * 2;

#pragma mark - HomePlaylistCardCell（横向卡片）

@interface HomePlaylistCardCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation HomePlaylistCardCell

+ (CGSize)cardSize {
    return CGSizeMake(kCardCoverSide, kCardHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    // 方形封面
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 8;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self.contentView addSubview:self.coverImageView];

    // 歌单名
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.titleLabel];

    // 描述
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:11];
    self.descLabel.textColor = [UIColor secondaryLabelColor];
    self.descLabel.numberOfLines = 1;
    self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.descLabel];

    // Masonry 布局
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.coverImageView.mas_width); // 方形
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(6);
        make.left.right.equalTo(self.contentView);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.left.right.equalTo(self.contentView);
    }];
}

- (void)configureWithData:(NSDictionary *)data {
    self.coverImageView.image = [UIImage imageNamed:data[@"image"]];
    self.titleLabel.text = data[@"title"];
    self.descLabel.text = data[@"desc"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.coverImageView.image = nil;
    self.titleLabel.text = nil;
    self.descLabel.text = nil;
}

@end

#pragma mark - HomePlaylistCardsCell（内嵌横向 collectionView 的容器 cell）

@interface HomePlaylistCardsCell ()
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HomePlaylistCardsCell

+ (CGFloat)rowHeight {
    return kCardsRowHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
    layout.itemSize = [HomePlaylistCardCell cardSize];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(12, 16, 12, 16);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[HomePlaylistCardCell class]
            forCellWithReuseIdentifier:NSStringFromClass([HomePlaylistCardCell class])];
    [self.contentView addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setCards:(NSArray<NSDictionary *> *)cards {
    _cards = [cards copy];
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePlaylistCardCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomePlaylistCardCell class])
                                                  forIndexPath:indexPath];
    [cell configureWithData:self.cards[indexPath.item]];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(playlistCardsCell:didSelectCardAtIndex:)]) {
        [self.delegate playlistCardsCell:self didSelectCardAtIndex:indexPath.item];
    }
}

@end

#pragma mark - HomeView

@implementation HomeView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    // tableView：铺满整个 HomeView，可滚动到 miniPlayer 下方
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    // 底部为 miniPlayer 预留空间（64 高 + 上下各 12 间距）
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self addSubview:self.tableView];

    // Section 0 容器 cell 由 View 层注册，Section 1 使用系统 Subtitle cell，由 Controller 手动创建
    [self.tableView registerClass:[HomePlaylistCardsCell class]
           forCellReuseIdentifier:HomePlaylistCardsCellID];

    // mini player（悬浮在 tableView 之上，布局保持不变）
    self.miniPlayerView = [[UIView alloc] init];
    self.miniPlayerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.miniPlayerView.layer.cornerRadius = 8;
    self.miniPlayerView.clipsToBounds = YES;
    [self addSubview:self.miniPlayerView];

    // cover
    self.playerCoverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    self.playerCoverView.contentMode = UIViewContentModeScaleAspectFill;
    self.playerCoverView.clipsToBounds = YES;
    self.playerCoverView.layer.cornerRadius = 6;
    [self.miniPlayerView addSubview:self.playerCoverView];

    // labels
    self.playerTitleLabel = [[UILabel alloc] init];
    self.playerTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.playerTitleLabel.textColor = [UIColor labelColor];
    self.playerTitleLabel.text = @"Song Title";
    [self.miniPlayerView addSubview:self.playerTitleLabel];

    self.playerArtistLabel = [[UILabel alloc] init];
    self.playerArtistLabel.font = [UIFont systemFontOfSize:12];
    self.playerArtistLabel.textColor = [UIColor secondaryLabelColor];
    self.playerArtistLabel.text = @"Artist";
    [self.miniPlayerView addSubview:self.playerArtistLabel];

    // play button
    self.playerPlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playerPlayButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
    self.playerPlayButton.tintColor = [UIColor labelColor];
    [self.miniPlayerView addSubview:self.playerPlayButton];

    // Masonry 布局
    [self.miniPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-12);
        make.height.mas_equalTo(64);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self); // 铺满，靠 contentInset 给 miniPlayer 让位
    }];

    [self.playerCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.miniPlayerView).offset(8);
        make.centerY.equalTo(self.miniPlayerView);
        make.width.height.mas_equalTo(48);
    }];

    [self.playerPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.miniPlayerView).offset(-8);
        make.centerY.equalTo(self.miniPlayerView);
        make.width.height.mas_equalTo(36);
    }];

    [self.playerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerCoverView.mas_right).offset(8);
        make.top.equalTo(self.playerCoverView);
        make.right.equalTo(self.playerPlayButton.mas_left).offset(-8);
    }];

    [self.playerArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerTitleLabel);
        make.top.equalTo(self.playerTitleLabel.mas_bottom).offset(2);
        make.right.equalTo(self.playerTitleLabel);
    }];
}

@end
