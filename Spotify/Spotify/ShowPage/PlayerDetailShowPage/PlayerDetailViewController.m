//
//  PlayerDetailViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "PlayerDetailViewController.h"
#import "PlayerDetailView.h"
#import "PlayerModel.h"
#import "SPAudioPlayer.h"
#import "UserModel.h"
#import "Song.h"
#import "Singer.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

@interface PlayerDetailViewController ()

@property (nonatomic, strong) PlayerDetailView *detailView;
@property (nonatomic, strong) PlayerModel *playerModel;
/// 正在拖动进度条时暂停自动回写，避免手指被系统回调顶回去
@property (nonatomic, assign) BOOL isDraggingProgress;

@end

@implementation PlayerDetailViewController

// 状态栏跟随当前外观：深色页面用白字，浅色页面用黑字
- (UIStatusBarStyle)preferredStatusBarStyle {
    BOOL isDark = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
    return isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDarkContent;
}

// 切换深浅模式时刷新状态栏样式（iOS 17+ trait 注册 API）
- (void)registerTraitChanges {
    __weak typeof(self) weakSelf = self;
    [self registerForTraitChanges:@[UITraitUserInterfaceStyle.class]
                      withHandler:^(id<UITraitChangeObservable> traitEnvironment,
                                    UITraitCollection *previousCollection) {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerModel = [PlayerModel sharedInstance];

    [self setUpInterface];
    [self setUpNotification];
    [self registerTraitChanges];

    [self refreshUI];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化

- (void)setUpInterface {
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.detailView = [[PlayerDetailView alloc] init];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // 关闭
    [self.detailView.closeButton addTarget:self
                                    action:@selector(pressCloseButton)
                          forControlEvents:UIControlEventTouchUpInside];

    // 播放控制
    [self.detailView.playButton addTarget:self
                                   action:@selector(pressPlayButton)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.detailView.previousButton addTarget:self
                                       action:@selector(pressPreviousButton)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.detailView.nextButton addTarget:self
                                   action:@selector(pressNextButton)
                         forControlEvents:UIControlEventTouchUpInside];

    // 喜欢 / 评论
    [self.detailView.favouriteButton addTarget:self
                                        action:@selector(pressFavouriteButton)
                              forControlEvents:UIControlEventTouchUpInside];
    [self.detailView.commentButton addTarget:self
                                      action:@selector(pressCommentButton)
                            forControlEvents:UIControlEventTouchUpInside];

    // 进度条：拖动时 seek 到对应位置
    [self.detailView.progressSlider addTarget:self
                                       action:@selector(progressSliderTouchDown:)
                             forControlEvents:UIControlEventTouchDown];
    [self.detailView.progressSlider addTarget:self
                                       action:@selector(progressSliderValueChanged:)
                             forControlEvents:UIControlEventValueChanged];
    [self.detailView.progressSlider addTarget:self
                                       action:@selector(progressSliderTouchUp:)
                             forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];

    // 下滑关闭
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSwipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)setUpNotification {
    // 与 mini player 共用同一份 PlayerModel，状态变了两边一起刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerModelDidChange)
                                                 name:PlayerModelDidChangeNotification
                                               object:nil];
    // 播放进度（约 0.5s 一次）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerProgressDidChange:)
                                                 name:SPAudioPlayerProgressNotification
                                               object:nil];
    // 切歌后进度条回到 0
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioPlayerSongDidChange:)
                                                 name:SPAudioPlayerDidChangeSongNotification
                                               object:nil];
}

#pragma mark - UI 刷新

- (void)refreshUI {
    Song *song = self.playerModel.song;
    if (!song) {
        NSLog(@"song 为 nil");
        return;
    }

    [self.detailView.coverImageView sp_setImageWithSource:song.coverURL placeholder:nil];
    self.detailView.songNameLabel.text = song.songName;
    self.detailView.singerLabel.text = song.singer.singerName;

    // 播放/暂停按钮
    NSString *playIcon = self.playerModel.isPlay ? @"pause.fill" : @"play.fill";
    [self.detailView.playButton setImage:[UIImage systemImageNamed:playIcon]
                                forState:UIControlStateNormal];

    // 喜欢状态
    NSString *favIcon = song.isFavourite ? @"heart.fill" : @"heart";
    [self.detailView.favouriteButton setImage:[UIImage systemImageNamed:favIcon]
                                     forState:UIControlStateNormal];
    self.detailView.favouriteButton.tintColor = song.isFavourite
        ? [UIColor systemPinkColor]
        : [UIColor labelColor];

    // 封面旋转跟随播放状态
    [self.detailView setCoverRotating:self.playerModel.isPlay];

    [self refreshProgressUI];
}

#pragma mark - 进度

/// 进度条 + 时间标签跟随真实播放进度
- (void)refreshProgressUI {
    SPAudioPlayer *player = [SPAudioPlayer sharedPlayer];
    NSTimeInterval duration = player.duration;
    NSTimeInterval current = player.currentTime;

    self.detailView.durationLabel.text = duration > 0 ? [SPAudioPlayer timeStringFromSeconds:duration] : @"--:--";
    self.detailView.currentTimeLabel.text = [SPAudioPlayer timeStringFromSeconds:current];
    if (!self.isDraggingProgress) {
        self.detailView.progressSlider.value = duration > 0 ? (float)(current / duration) : 0;
    }
}

- (void)audioPlayerProgressDidChange:(NSNotification *)notification {
    if (self.isDraggingProgress) return;
    [self refreshProgressUI];
}

- (void)audioPlayerSongDidChange:(NSNotification *)notification {
    self.detailView.progressSlider.value = 0;
    self.detailView.currentTimeLabel.text = @"00:00";
    self.detailView.durationLabel.text = @"--:--";
}

- (void)playerModelDidChange {
    [self refreshUI];
}

#pragma mark - 事件

- (void)pressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressPlayButton {
    self.playerModel.isPlay = !self.playerModel.isPlay;
}

- (void)pressPreviousButton {
    [self.playerModel playPreviousSong];
}

- (void)pressNextButton {
    [self.playerModel playNextSong];
}

- (void)pressFavouriteButton {
    Song *song = self.playerModel.song;
    if (!song) return;
    // 统一入口：同步「我的喜欢」歌单
    [[UserModel sharedInstance] toggleFavouriteForSong:song];
    [self refreshUI];
}

- (void)pressCommentButton {
    NSLog(@"打开评论（待实现）");
}

- (void)progressSliderTouchDown:(UISlider *)slider {
    self.isDraggingProgress = YES;
}

- (void)progressSliderTouchUp:(UISlider *)slider {
    self.isDraggingProgress = NO;
    [[SPAudioPlayer sharedPlayer] seekToProgress:slider.value];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    // 拖动过程中只更新时间显示，松手才真正 seek
    NSTimeInterval duration = [SPAudioPlayer sharedPlayer].duration;
    if (duration > 0) {
        self.detailView.currentTimeLabel.text = [SPAudioPlayer timeStringFromSeconds:duration * slider.value];
    }
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
