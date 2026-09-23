//
//  MyView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import "MyView.h"
#import "MyModel.h"
#import "UserModel.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

static const CGFloat kAvatarSide = 80.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kStatsHeight = 44.0;
static const CGFloat kTabBarHeight = 44.0;
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0;

@interface MyView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIStackView *statsStackView;
@property (nonatomic, assign) CGFloat lastLayoutWidth;

@property (nonatomic, strong) MyModel *model;
@property (nonatomic, assign, readwrite) BOOL showingCollected;
@property (nonatomic, strong) UIView *playlistTabHeaderView;
@property (nonatomic, strong) UIButton *createdButton;
@property (nonatomic, strong) UIButton *collectedButton;
@property (nonatomic, strong) UIButton *addPlaylistButton;

@end

@implementation MyView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    [self addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    self.headerView = [self makeHeaderView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 头部

- (UIView *)makeHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    header.backgroundColor = [UIColor clearColor];

    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = kAvatarSide / 2.0;
    self.avatarImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [header addSubview:self.avatarImageView];

    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
    self.nicknameLabel.textColor = [UIColor labelColor];
    [header addSubview:self.nicknameLabel];

    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.font = [UIFont systemFontOfSize:14.0];
    self.emailLabel.textColor = [UIColor secondaryLabelColor];
    [header addSubview:self.emailLabel];

    // 统计行：最近 / 喜欢的歌曲 / 喜欢的歌单 / 等级
    self.statsStackView = [[UIStackView alloc] init];
    self.statsStackView.axis = UILayoutConstraintAxisHorizontal;
    self.statsStackView.distribution = UIStackViewDistributionFillEqually;
    [header addSubview:self.statsStackView];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(16.0);
        make.left.equalTo(header).offset(kHorizontalInset);
        make.size.mas_equalTo(CGSizeMake(kAvatarSide, kAvatarSide));
    }];

    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(16.0);
        make.right.equalTo(header).offset(-kHorizontalInset);
        make.bottom.equalTo(self.emailLabel.mas_top).offset(-4.0);
        make.height.mas_equalTo(28.0);
    }];

    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nicknameLabel);
        make.centerY.equalTo(self.avatarImageView).offset(14.0);
        make.height.mas_equalTo(20.0);
    }];

    [self.statsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(16.0);
        make.left.right.equalTo(header).offset(kHorizontalInset);
        make.height.mas_equalTo(kStatsHeight);
    }];

    return header;
}

#pragma mark - 统计项

- (UIView *)statItemWithValue:(NSString *)value label:(NSString *)label {
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = value;
    valueLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold];
    valueLabel.textColor = [UIColor labelColor];
    valueLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = label;
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    nameLabel.textColor = [UIColor secondaryLabelColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[valueLabel, nameLabel]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 2.0;
    return stack;
}

#pragma mark - 歌单切换条

- (UIView *)playlistTabHeader {
    if (_playlistTabHeaderView) return _playlistTabHeaderView;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kTabBarHeight)];
    header.backgroundColor = [UIColor systemBackgroundColor];

    self.createdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.createdButton addTarget:self
                           action:@selector(pressCreatedTab)
                 forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:self.createdButton];

    self.collectedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.collectedButton addTarget:self
                             action:@selector(pressCollectedTab)
                   forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:self.collectedButton];

    self.addPlaylistButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addPlaylistButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
    self.addPlaylistButton.tintColor = [UIColor labelColor];
    [self.addPlaylistButton addTarget:self
                               action:@selector(pressAddPlaylist)
                     forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:self.addPlaylistButton];

    [self.createdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(kHorizontalInset);
        make.centerY.equalTo(header);
        make.height.mas_equalTo(kTabBarHeight);
    }];

    [self.collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createdButton.mas_right).offset(24.0);
        make.centerY.equalTo(header);
        make.height.mas_equalTo(kTabBarHeight);
    }];

    [self.addPlaylistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(-kHorizontalInset);
        make.centerY.equalTo(header);
        make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
    }];

    _playlistTabHeaderView = header;
    [self refreshTabs];
    return _playlistTabHeaderView;
}

- (void)refreshTabs {
    NSUInteger createdCount = self.model.createdPlaylists.count;
    NSUInteger collectedCount = self.model.collectedPlaylists.count;

    [self.createdButton setTitle:[NSString stringWithFormat:@"我创建的歌单 %lu", (unsigned long)createdCount]
                        forState:UIControlStateNormal];
    [self.collectedButton setTitle:[NSString stringWithFormat:@"我收藏的歌单 %lu", (unsigned long)collectedCount]
                          forState:UIControlStateNormal];

    UIFont *selectedFont = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    UIFont *normalFont = [UIFont systemFontOfSize:16.0];
    UIColor *selectedColor = [UIColor labelColor];
    UIColor *normalColor = [UIColor secondaryLabelColor];

    // 选中的一侧：加粗 + 亮色；未选中的一侧：常规 + 灰色
    self.createdButton.titleLabel.font = self.showingCollected ? normalFont : selectedFont;
    [self.createdButton setTitleColor:self.showingCollected ? normalColor : selectedColor
                             forState:UIControlStateNormal];

    self.collectedButton.titleLabel.font = self.showingCollected ? selectedFont : normalFont;
    [self.collectedButton setTitleColor:self.showingCollected ? selectedColor : normalColor
                               forState:UIControlStateNormal];
}

#pragma mark - Public

- (void)configureWithModel:(MyModel *)model {
    self.model = model;

    [self.avatarImageView sp_setImageWithSource:model.user.avatarURL placeholder:nil];
    self.nicknameLabel.text = model.user.user_name;
    self.emailLabel.text = model.user.email;

    // 统计行每次重建，数据变了直接刷
    NSMutableArray<UIView *> *items = [NSMutableArray array];
    [items addObject:[self statItemWithValue:[NSString stringWithFormat:@"%ld", (long)model.recentCount]
                                       label:@"最近"]];
    [items addObject:[self statItemWithValue:[NSString stringWithFormat:@"%ld", (long)model.favouriteSongCount]
                                       label:@"喜欢的歌曲"]];
    [items addObject:[self statItemWithValue:[NSString stringWithFormat:@"%ld", (long)model.favouritePlaylistCount]
                                       label:@"喜欢的歌单"]];
    [items addObject:[self statItemWithValue:model.level ?: @""
                                       label:@"等级"]];
    [self.statsStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *item in items) {
        [self.statsStackView addArrangedSubview:item];
    }

    if (_playlistTabHeaderView) {
        [self refreshTabs];
    }
}

- (void)setTabShowingCollected:(BOOL)showingCollected {
    if (_showingCollected == showingCollected) return;
    _showingCollected = showingCollected;
    [self refreshTabs];
}

#pragma mark - 事件

- (void)pressCreatedTab {
    [self setTabShowingCollected:NO];
    if (self.onPlaylistTypeChanged) {
        self.onPlaylistTypeChanged(NO);
    }
}

- (void)pressCollectedTab {
    [self setTabShowingCollected:YES];
    if (self.onPlaylistTypeChanged) {
        self.onPlaylistTypeChanged(YES);
    }
}

- (void)pressAddPlaylist {
    if (self.onCreatePlaylist) {
        self.onCreatePlaylist();
    }
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];

    // tableHeaderView 高度要等宽度确定后再算
    CGFloat width = CGRectGetWidth(self.bounds);
    if (width > 0 && fabs(width - self.lastLayoutWidth) > 0.5) {
        self.lastLayoutWidth = width;

        CGRect frame = self.headerView.frame;
        frame.size.height = 16.0 + kAvatarSide + 16.0 + kStatsHeight + 16.0;
        self.headerView.frame = frame;
        self.tableView.tableHeaderView = self.headerView;
    }
}

@end
