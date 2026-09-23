//
//  SongListView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import "SongListShowView.h"
#import "SongListModel.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

NSString *const SongListSongCellID = @"SongListSongCell";

static const CGFloat kBackdropHeightRatio = 0.75;   // 封面背景高度 ≈ 屏高的 1/3
static const CGFloat kNameHeight = 40.0;
static const CGFloat kInfoHeight = 20.0;
static const CGFloat kButtonHeight = 44.0;
static const CGFloat kHorizontalInset = 16.0;
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0;
/// 歌单名叠在封面渐隐区上的高度
static const CGFloat kNameOverlap = 32.0;

@interface SongListShowView ()

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIImageView *coverImageView;
@property (nonatomic, strong, readwrite) MarqueeLabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *infoLabel;
@property (nonatomic, strong, readwrite) UIButton *playButton;
@property (nonatomic, strong, readwrite) UIButton *favouriteButton;
@property (nonatomic, strong, readwrite) UIButton *moreButton;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *backdropContainer;      // 封面背景容器（整体带渐隐蒙版）
@property (nonatomic, strong) UIView *blurWrapView;           // 模糊层包装（对包装做蒙版，不动 UIVisualEffectView 本身）
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) CAGradientLayer *fadeMaskLayer; // 背景整体：底部渐隐到透明
@property (nonatomic, strong) CAGradientLayer *blurMaskLayer; // 模糊层：只在底部出现，越往下越模糊
@property (nonatomic, assign) CGFloat lastLayoutWidth;

@end

@implementation SongListShowView

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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 88.0, 0, 0);
    // 底部给 mini player 留白
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    // 头部先建好，真实宽度在 layoutSubviews 时再补
    self.headerView = [self makeHeaderView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - 头部

- (UIView *)makeHeaderView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    header.backgroundColor = [UIColor clearColor];

    // 封面背景：铺满顶部，底部模糊渐隐衔接背景
    self.backdropContainer = [[UIView alloc] init];
    self.backdropContainer.clipsToBounds = YES;
    [header addSubview:self.backdropContainer];

    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self.backdropContainer addSubview:self.coverImageView];

    // 深色模糊盖在图片上，只露出底部一段（歌名叠在模糊区上）
    self.blurWrapView = [[UIView alloc] init];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark]];
    self.blurEffectView.frame = self.blurWrapView.bounds;
    self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.blurWrapView addSubview:self.blurEffectView];
    [self.backdropContainer addSubview:self.blurWrapView];

    // 整体蒙版：底部渐隐到透明，衔接页面背景
    self.fadeMaskLayer = [CAGradientLayer layer];
    self.fadeMaskLayer.colors = @[(id)[UIColor whiteColor].CGColor,
                                  (id)[UIColor whiteColor].CGColor,
                                  (id)[UIColor clearColor].CGColor];
    self.fadeMaskLayer.locations = @[@0.0, @0.55, @1.0];
    self.backdropContainer.layer.mask = self.fadeMaskLayer;

    // 模糊层蒙版：只在底部 35% 出现，且渐入（顶部保持清晰封面）
    self.blurMaskLayer = [CAGradientLayer layer];
    self.blurMaskLayer.colors = @[(id)[UIColor clearColor].CGColor,
                                  (id)[UIColor clearColor].CGColor,
                                  (id)[UIColor whiteColor].CGColor,
                                  (id)[UIColor whiteColor].CGColor];
    self.blurMaskLayer.locations = @[@0.0, @0.55, @0.9, @1.0];
    self.blurWrapView.layer.mask = self.blurMaskLayer;

    self.nameLabel = [[MarqueeLabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:28.0 weight:UIFontWeightBold];
    self.nameLabel.textColor = [UIColor labelColor];
    [header addSubview:self.nameLabel];

    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.font = [UIFont systemFontOfSize:14.0];
    self.infoLabel.textColor = [UIColor secondaryLabelColor];
    [header addSubview:self.infoLabel];

    [self setUpButtonsInHeader:header];

    [self.backdropContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(header);
        make.height.equalTo(header.mas_width).multipliedBy(kBackdropHeightRatio);
    }];

    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backdropContainer);
    }];

    [self.blurWrapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backdropContainer);
    }];

    // 歌名叠在封面的模糊渐隐区上
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backdropContainer.mas_bottom).offset(-kNameOverlap);
        make.left.equalTo(header).offset(kHorizontalInset);
        make.right.equalTo(header).offset(-kHorizontalInset);
        make.height.mas_equalTo(kNameHeight);
    }];

    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0);
        make.left.right.equalTo(self.nameLabel);
        make.height.mas_equalTo(kInfoHeight);
    }];

    return header;
}

- (void)setUpButtonsInHeader:(UIView *)header {
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.backgroundColor = [UIColor systemGreenColor];
    self.playButton.layer.cornerRadius = kButtonHeight / 2.0;
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.playButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:20.0];
    self.favouriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.favouriteButton setImage:[UIImage systemImageNamed:@"heart" withConfiguration:config]
                          forState:UIControlStateNormal];
    self.favouriteButton.tintColor = [UIColor labelColor];

    self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.moreButton setImage:[UIImage systemImageNamed:@"ellipsis" withConfiguration:config]
                     forState:UIControlStateNormal];
    self.moreButton.tintColor = [UIColor labelColor];

    UIStackView *buttonRow = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.playButton, self.favouriteButton, self.moreButton
    ]];
    buttonRow.axis = UILayoutConstraintAxisHorizontal;
    buttonRow.alignment = UIStackViewAlignmentCenter;
    buttonRow.spacing = 16.0;
    [header addSubview:buttonRow];

    [buttonRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.mas_bottom).offset(16.0);
        make.left.equalTo(header).offset(kHorizontalInset);
        make.height.mas_equalTo(kButtonHeight);
    }];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120.0);
        make.height.mas_equalTo(kButtonHeight);
    }];

    [self.favouriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonHeight, kButtonHeight));
    }];

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonHeight, kButtonHeight));
    }];
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];

    // tableHeaderView 的高度要等宽度确定后才能算
    CGFloat width = CGRectGetWidth(self.bounds);
    if (width > 0 && fabs(width - self.lastLayoutWidth) > 0.5) {
        self.lastLayoutWidth = width;

        CGRect frame = self.headerView.frame;
        frame.size.height = [SongListShowView headerHeightForWidth:width];
        self.headerView.frame = frame;
        self.tableView.tableHeaderView = self.headerView;

        // 渐隐蒙版的 frame 要跟着容器走（layoutSubviews 后容器约束已生效）
        [self.backdropContainer layoutIfNeeded];
        CGRect backdropBounds = self.backdropContainer.bounds;
        self.fadeMaskLayer.frame = backdropBounds;
        self.blurMaskLayer.frame = backdropBounds;
    }
}

+ (CGFloat)headerHeightForWidth:(CGFloat)width {
    CGFloat backdropHeight = width * kBackdropHeightRatio;
    return backdropHeight - kNameOverlap + kNameHeight + 8.0 + kInfoHeight + 16.0 + kButtonHeight + 16.0;
}

#pragma mark - Public

- (void)configureWithSongList:(SongListModel *)songList {
    [self.coverImageView sp_setImageWithSource:songList.coverURL placeholder:nil];
    self.nameLabel.text = songList.playlistName ?: @"";

    NSUInteger count = songList.songs.count;
    self.infoLabel.text = count > 0
        ? [NSString stringWithFormat:@"%lu 首歌曲", (unsigned long)count]
        : @"暂无歌曲";
}

- (CGFloat)nameLabelBottomInHeader {
    return CGRectGetMaxY(self.nameLabel.frame);
}

@end
