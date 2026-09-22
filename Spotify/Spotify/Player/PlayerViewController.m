//
//  PlayerViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "PlayerViewController.h"
#import "UIImageView+Spotify.h"
#import "UIResponder+AppActions.h"

@interface PlayerViewController () <PlayerViewDelegate>

@property (nonatomic, strong, readwrite) PlayerModel *playerModel;
@property (nonatomic, strong, readwrite) PlayerView *playerView;

@end

@implementation PlayerViewController


+ (instancetype)sharedInstance {
    static PlayerViewController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PlayerViewController alloc] init];
        // 在这里做只需要执行一次的初始化
        instance.playerModel = [PlayerModel sharedInstance];
    });
    return instance;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpInterface];
    

    // 监听播放状态变化，刷新自己的 UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerModelDidChange)
                                                 name:PlayerModelDidChangeNotification
                                               object:nil];

    

    [self.playerView.playButton addTarget:self
                                   action:@selector(pressPlayButton)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.playerView.favouriteButton addTarget:self
                                        action:@selector(toggleFavourite)
                              forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshUI]; 
}

- (void) setUpInterface {
    // 初始化 PlayerView 并加约束（Masonry）
    self.playerView = [[PlayerView alloc] init];
    self.playerView.delegate = self;
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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

- (void)pressPlayButton {
    NSLog(@"点击了播放按钮");
    self.playerModel.isPlay = !self.playerModel.isPlay;
    [self refreshUI];
}

- (Song *)currentSong {
    return self.playerModel.song;
}

- (BOOL)isPlaying {
    return self.playerModel.isPlay;
}

#pragma mark - PlayerViewDelegate

// mini player 的 view 只有 60pt 高，不能自己 present 全屏页，交给上层容器（DrawerViewController）处理
- (void)playerViewDidTapPlayer:(PlayerView *)playerView {
    [[UIApplication sharedApplication] sendAction:@selector(openPlayerDetailPage)
                                               to:nil
                                               from:self
                                           forEvent:nil];
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
    if (!song) {
        NSLog(@"song 为 nil");
        return;
    }
    

    [self.playerView.coverImageView sp_setImageWithSource:song.coverURL placeholder:nil];
    self.playerView.songNameLabel.text = song.songName;
    self.playerView.singerLabel.text = song.singer.singerName;
    

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
