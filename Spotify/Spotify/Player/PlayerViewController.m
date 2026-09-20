//
//  PlayerViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@property (nonatomic, strong, readwrite) PlayerModel *playerModel;
@property (nonatomic, strong, readwrite) PlayerView *playerView;

@end

@implementation PlayerViewController

+ (instancetype)sharedInstance {
    static PlayerViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PlayerViewController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 持有共享模型
        _playerModel = [PlayerModel sharedInstance];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];

    // 监听播放状态变化，刷新自己的 UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerModelDidChange)
                                                 name:PlayerModelDidChangeNotification
                                               object:nil];

    // 初始化 PlayerView 并加约束（Masonry）
    self.playerView = [[PlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.playerView.playButton addTarget:self
                                   action:@selector(togglePlayPause)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.playerView.favouriteButton addTarget:self
                                        action:@selector(toggleFavourite)
                              forControlEvents:UIControlEventTouchUpInside];

    [self refreshUI];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)playSong:(Song *)song {
    self.playerModel.song = song;
    self.playerModel.isPlay = YES;
}

- (void)togglePlayPause {
    self.playerModel.isPlay = !self.playerModel.isPlay;
}

- (Song *)currentSong {
    return self.playerModel.song;
}

- (BOOL)isPlaying {
    return self.playerModel.isPlay;
}

#pragma mark - Private

- (void)toggleFavourite {
    Song *song = self.playerModel.song;
    if (!song) return;
    song.isFavourite = !song.isFavourite;
    [self refreshUI];
}

- (void)playerModelDidChange {
    [self refreshUI];
}

- (void)refreshUI {
    Song *song = self.playerModel.song;
    if (!song) return;

    self.playerView.coverImageView.image = song.songCover;
    self.playerView.songNameLabel.text = song.songName;
    self.playerView.songerLabel.text = song.singer.singerName;

    // 播放/暂停按钮图标
    NSString *iconName = self.playerModel.isPlay ? @"pause.fill" : @"play.fill";
    [self.playerView.playButton setImage:[UIImage systemImageNamed:iconName]
                                forState:UIControlStateNormal];

    // 喜欢按钮状态
    NSString *favIcon = song.isFavourite ? @"heart.fill" : @"heart";
    [self.playerView.favouriteButton setImage:[UIImage systemImageNamed:favIcon]
                                     forState:UIControlStateNormal];
    self.playerView.favouriteButton.tintColor = song.isFavourite
        ? [UIColor systemPinkColor]
        : [UIColor labelColor];
}

@end
