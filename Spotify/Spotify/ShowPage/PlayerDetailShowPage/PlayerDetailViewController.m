//
//  PlayerDetailViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "PlayerDetailViewController.h"
#import "PlayerDetailView.h"
#import "PlayerModel.h"
#import "Song.h"
#import "Singer.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

@interface PlayerDetailViewController ()

@property (nonatomic, strong) PlayerDetailView *detailView;
@property (nonatomic, strong) PlayerModel *playerModel;

@end

@implementation PlayerDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerModel = [PlayerModel sharedInstance];
    [self setUpInterface];
    [self setUpNotification];

    [self refreshUI];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化

- (void)setUpInterface {
    self.view.backgroundColor = [UIColor blackColor];

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

    // 进度条：接入 AVPlayer 后在这里做 seek
    [self.detailView.progressSlider addTarget:self
                                       action:@selector(progressSliderValueChanged:)
                             forControlEvents:UIControlEventValueChanged];

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
        : [UIColor whiteColor];

    // 封面旋转跟随播放状态
    [self.detailView setCoverRotating:self.playerModel.isPlay];
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
    song.isFavourite = !song.isFavourite;
    [self refreshUI];
}

- (void)pressCommentButton {
    NSLog(@"打开评论（待实现）");
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    // TODO: 接入 AVPlayer 后在此 seek：
    // 1. 用 AVPlayer.currentItem.duration 换算目标时间
    // 2. [player seekToTime:];
    // 3. currentTimeLabel / durationLabel 由 addPeriodicTimeObserver 回调刷新
    NSLog(@"拖动进度条：%.2f", slider.value);
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
