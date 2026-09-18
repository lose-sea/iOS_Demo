//
//  HomeView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeView.h"
#import "PlayerModel.h"

#pragma mark - 常量

NSString *const HomePlaylistCardsCellID = @"HomePlaylistCardsCell";
NSString *const HomeSongCellID = @"HomeSongCell";

static const CGFloat kCardCoverSide = 150.0;
static const CGFloat kCardHeight = 188.0;
static const CGFloat kCardsRowHeight = kCardHeight + 24.0; // 上下各 12pt
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0; // 64高 + 上下各12

#pragma mark - HomePlaylistCardCell

@interface HomePlaylistCardCell ()
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation HomePlaylistCardCell

+ (CGSize)cardSize { return CGSizeMake(kCardCoverSide, kCardHeight); }

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) [self setUpInterface];
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 8;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self.contentView addSubview:self.coverImageView];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.titleLabel.textColor = [UIColor labelColor];
    [self.contentView addSubview:self.titleLabel];

    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:11];
    self.descLabel.textColor = [UIColor secondaryLabelColor];
    [self.contentView addSubview:self.descLabel];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.coverImageView.mas_width);
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

#pragma mark - HomePlaylistCardsCell（容器 cell，内部横向 collectionView）

@interface HomePlaylistCardsCell ()
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HomePlaylistCardsCell

+ (CGFloat)rowHeight { return kCardsRowHeight; }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) [self setUpInterface];
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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self.contentView); }];
}

- (void)setCards:(NSArray<NSDictionary *> *)cards {
    _cards = [cards copy];
    [self.collectionView reloadData];
}

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(playlistCardsCell:didSelectCardAtIndex:)]) {
        [self.delegate playlistCardsCell:self didSelectCardAtIndex:indexPath.item];
    }
}

@end

#pragma mark - HomeView

@implementation HomeView

- (instancetype)init {
    if ((self = [super init])) {
        [self setUpInterface];
        // 监听 PlayerModel 变化 → 自动刷新 miniPlayer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerModelDidChange)
                                                     name:PlayerModelDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    // tableView：铺满整个 HomeView，可滚动到 miniPlayer 下方
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self addSubview:self.tableView];

    [self.tableView registerClass:[HomePlaylistCardsCell class]
           forCellReuseIdentifier:HomePlaylistCardsCellID];

    // miniPlayer（悬浮在 tableView 之上）
    self.miniPlayerView = [[UIView alloc] init];
    self.miniPlayerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.miniPlayerView.layer.cornerRadius = 8;
    self.miniPlayerView.clipsToBounds = YES;
    [self addSubview:self.miniPlayerView];

    self.playerCoverView = [[UIImageView alloc] init];
    self.playerCoverView.contentMode = UIViewContentModeScaleAspectFill;
    self.playerCoverView.clipsToBounds = YES;
    self.playerCoverView.layer.cornerRadius = 6;
    [self.miniPlayerView addSubview:self.playerCoverView];

    self.playerTitleLabel = [[UILabel alloc] init];
    self.playerTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.playerTitleLabel.textColor = [UIColor labelColor];
    [self.miniPlayerView addSubview:self.playerTitleLabel];

    self.playerArtistLabel = [[UILabel alloc] init];
    self.playerArtistLabel.font = [UIFont systemFontOfSize:12];
    self.playerArtistLabel.textColor = [UIColor secondaryLabelColor];
    [self.miniPlayerView addSubview:self.playerArtistLabel];

    self.playerPlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playerPlayButton.tintColor = [UIColor labelColor];
    [self.miniPlayerView addSubview:self.playerPlayButton];

    // Masonry 布局
    [self.miniPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-12);
        make.height.mas_equalTo(64);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self); }];
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
        make.left.right.equalTo(self.playerTitleLabel);
        make.top.equalTo(self.playerTitleLabel.mas_bottom).offset(2);
    }];

    // 初始状态：没歌时隐藏文字，留个默认占位
    [self configureWithSong:nil isPlaying:NO];
}

#pragma mark - miniPlayer 刷新

- (void)playerModelDidChange {
    PlayerModel *m = [PlayerModel sharedInstance];
    [self configureWithSong:m.song isPlaying:m.isPlay];
}

- (void)configureWithSong:(Song *)song isPlaying:(BOOL)playing {
    if (!song) {
        self.playerCoverView.image = [UIImage imageNamed:@"1.jpg"];
        self.playerTitleLabel.text = @"未播放";
        self.playerArtistLabel.text = @"点击歌曲开始";
        [self.playerPlayButton setImage:[UIImage systemImageNamed:@"play.fill"] forState:UIControlStateNormal];
        return;
    }
    self.playerCoverView.image = song.songCover;
    self.playerTitleLabel.text = song.songName;
    self.playerArtistLabel.text = song.singer.singerName;
    NSString *icon = playing ? @"pause.fill" : @"play.fill";
    [self.playerPlayButton setImage:[UIImage systemImageNamed:icon] forState:UIControlStateNormal];
}

@end
