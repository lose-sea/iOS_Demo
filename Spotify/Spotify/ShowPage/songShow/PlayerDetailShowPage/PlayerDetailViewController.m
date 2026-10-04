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
#import "FavouriteManager.h"
#import "Song.h"
#import "Singer.h"
#import "NeteaseService.h"
#import "UIImageView+Spotify.h"
#import "CommentViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface PlayerDetailViewController ()

@property (nonatomic, strong) PlayerDetailView *detailView;
@property (nonatomic, strong) PlayerModel *playerModel;
/// 正在拖动进度条时暂停自动回写，避免手指被系统回调顶回去
@property (nonatomic, assign) BOOL isDraggingProgress;
/// 解析后的歌词行：@[@{@"t": 秒数, @"w": 文本}, ...]，按时间升序
@property (nonatomic, copy) NSArray<NSDictionary *> *lyricLines;
/// 已加载歌词对应的歌曲 ID，避免每次 refreshUI（切歌/收藏）都重复请求
@property (nonatomic, copy) NSString *lastLyricSongId;
/// 歌词请求进行中标记，防止同一首歌并发重复拉取
@property (nonatomic, assign) BOOL isLyricLoading;

@end

@implementation PlayerDetailViewController

// 状态栏跟随当前外观：深色页面用白字，浅色页面用黑字
// 系统方法,用来决定"状态栏（顶部时间/电量那块）的文字颜色"
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

    // 「…」不需要 target-action：点一下直接展开 UIMenu
    self.detailView.moreButton.showsMenuAsPrimaryAction = YES;

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
    // 收藏在别处被改（mini player / 歌单页）时同步红心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favouriteDidChange:)
                                                 name:FavouriteDidChangeNotification
                                               object:nil];
}

#pragma mark - UI 刷新

- (void)refreshUI {
    Song *song = self.playerModel.currentSong;
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

    // 喜欢状态：问 FavouriteManager 而不是读 song.isFavourite，
    // 同一首歌在别的页面可能是另一个实例，只有按 songId 判断才一致
    BOOL favourite = [[FavouriteManager sharedInstance] isFavouriteSong:song];
    NSString *favIcon = favourite ? @"heart.fill" : @"heart";
    [self.detailView.favouriteButton setImage:[UIImage systemImageNamed:favIcon]
                                     forState:UIControlStateNormal];
    self.detailView.favouriteButton.tintColor = favourite
        ? [UIColor systemPinkColor]
        : [UIColor labelColor];

    // 封面旋转跟随播放状态
    [self.detailView setCoverRotating:self.playerModel.isPlay];

    // 当前歌曲 / 歌单列表都可能变，重建「…」菜单
    self.detailView.moreButton.menu = [self makeMoreMenu];

    [self refreshProgressUI];
    [self fetchAndShowLyric];
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
    [self updateLyricAtTime:[SPAudioPlayer sharedPlayer].currentTime];
}

- (void)audioPlayerSongDidChange:(NSNotification *)notification {
    self.detailView.progressSlider.value = 0;
    self.detailView.currentTimeLabel.text = @"00:00";
    self.detailView.durationLabel.text = @"--:--";
}

- (void)playerModelDidChange {
    [self refreshUI];
}

// 收藏在别处被改（mini player / 歌单页）时同步红心
- (void)favouriteDidChange:(NSNotification *)notification {
    [self refreshUI];
}

#pragma mark - 歌词

/// 拉取当前歌曲歌词并解析。refreshUI 会在切歌/收藏等场景被多次调用，这里用 lastLyricSongId 去重，避免重复请求和刷新进度被重置
- (void)fetchAndShowLyric {
    Song *song = self.playerModel.currentSong;
    if (!song || song.songId.length == 0) {
        self.lyricLines = @[];
        self.detailView.currentLyricsLabel.text = @"暂无歌词";
        self.detailView.nextLyricsLabel.text = @"";
        return;
    }
    // 同一首歌：已加载或正在加载就别再请求，直接按当前进度刷新显示
    if ([self.lastLyricSongId isEqualToString:song.songId]
        && (self.lyricLines.count > 0 || self.isLyricLoading)) {
        [self updateLyricAtTime:[SPAudioPlayer sharedPlayer].currentTime];
        return;
    }

    self.lastLyricSongId = song.songId;
    self.isLyricLoading = YES;
    self.lyricLines = @[];   // 先清空，避免显示上一首残留

    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchLyricWithId:song.songId
                                          completion:^(NSString *lyric, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isLyricLoading = NO;
            if (!lyric || lyric.length == 0) {
                weakSelf.lyricLines = @[];
                weakSelf.detailView.currentLyricsLabel.text = @"暂无歌词";
                weakSelf.detailView.nextLyricsLabel.text = @"";
                return;
            }
            weakSelf.lyricLines = [weakSelf parseLyric:lyric];
            [weakSelf updateLyricAtTime:[SPAudioPlayer sharedPlayer].currentTime];
        });
    }];
}

/// 把 LRC 文本解析成 @[@{@"t":秒数, @"w":文本}]。支持一行多时间戳（[00:01.00][00:05.00]文本）、忽略 [ti:]/[ar:] 等元数据
- (NSArray<NSDictionary *> *)parseLyric:(NSString *)lyric {
    NSMutableArray<NSDictionary *> *lines = [NSMutableArray array];
    NSArray<NSString *> *rawLines = [lyric componentsSeparatedByString:@"\n"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\d{2}):(\\d{2})(?:\\.(\\d{1,3}))?\\]"
                                                                           options:0
                                                                             error:nil];
    for (NSString *line in rawLines) {
        if (line.length == 0) continue;
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:line
                                                                   options:0
                                                                     range:NSMakeRange(0, line.length)];
        if (matches.count == 0) continue;   // 没有时间戳的行（元数据标签）直接跳过

        // 文本 = 最后一个时间戳之后的内容
        NSTextCheckingResult *last = matches.lastObject;
        NSString *text = [line substringFromIndex:last.range.location + last.range.length];
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        for (NSTextCheckingResult *m in matches) {
            NSInteger min = [[line substringWithRange:[m rangeAtIndex:1]] integerValue];
            NSInteger sec = [[line substringWithRange:[m rangeAtIndex:2]] integerValue];
            NSString *fracStr = [m rangeAtIndex:3].length > 0 ? [line substringWithRange:[m rangeAtIndex:3]] : @"0";
            double frac = fracStr.doubleValue / pow(10.0, (double)fracStr.length);
            NSTimeInterval t = min * 60 + sec + frac;
            [lines addObject:@{@"t": @(t), @"w": text ?: @""}];
        }
    }
    // 按时间升序，多时间戳展开后也保持顺序
    [lines sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        return [a[@"t"] compare:b[@"t"]];
    }];
    return [lines copy];
}

/// 根据播放进度定位当前行 / 下一行，更新两个 label
- (void)updateLyricAtTime:(NSTimeInterval)currentTime {
    if (self.lyricLines.count == 0) {
        self.detailView.currentLyricsLabel.text = @"暂无歌词";
        self.detailView.nextLyricsLabel.text = @"";
        return;
    }
    NSDictionary *currentLine = nil;
    NSDictionary *nextLine = nil;
    for (NSInteger i = 0; i < (NSInteger)self.lyricLines.count; i++) {
        NSDictionary *line = self.lyricLines[i];
        NSTimeInterval t = [line[@"t"] doubleValue];
        if (t <= currentTime + 0.15) {   // 容差，避免正好卡在边界时抖动
            currentLine = line;
            if (i + 1 < (NSInteger)self.lyricLines.count) {
                nextLine = self.lyricLines[i + 1];
            }
        } else {
            break;
        }
    }
    if (!currentLine) {
        currentLine = self.lyricLines.firstObject;   // 还没到第一句，先显示第一句
    }
    self.detailView.currentLyricsLabel.text = currentLine[@"w"] ?: @"";
    self.detailView.nextLyricsLabel.text = nextLine[@"w"] ?: @"";
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
    Song *song = self.playerModel.currentSong;
    if (!song) return;
    // 统一入口：同步「我的喜欢」歌单
    [[FavouriteManager sharedInstance] toggleFavouriteForSong:song];
    [self refreshUI];
}

- (void)pressCommentButton {
    Song *song = self.playerModel.currentSong;
    if (!song) return;

    // 评论页以 page sheet 弹出（抖音评论区那种从底部升起的大半屏）
    CommentViewController *commentVC = [[CommentViewController alloc] initWithSongId:song.songId
                                                                          songName:song.songName];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentVC];
    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheet = nav.sheetPresentationController;
        sheet.detents = @[[UISheetPresentationControllerDetent mediumDetent],
                          [UISheetPresentationControllerDetent largeDetent]];
        sheet.prefersGrabberVisible = YES;
        sheet.preferredCornerRadius = 16;
    }
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 更多菜单

/// 点「…」直接展开菜单：分享 / 添加到我的歌单（子菜单列出我创建的歌单）
/// 歌曲或歌单都可能变，所以每次刷新 UI 时重建
- (UIMenu *)makeMoreMenu {
    __weak typeof(self) weakSelf = self;

    UIAction *shareAction = [UIAction actionWithTitle:@"分享"
                                               image:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                          identifier:nil
                                             handler:^(__kindof UIAction * _Nonnull action) {
        [weakSelf shareCurrentSong];
    }];

    // 子菜单：每一项 = 一个我创建的歌单
    NSMutableArray<UIMenuElement *> *items = [NSMutableArray array];
    for (SongListModel *playlist in [UserModel sharedInstance].createSongLists) {
        UIAction *item = [UIAction actionWithTitle:playlist.playlistName
                                             image:[UIImage systemImageNamed:@"music.note.list"]
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
            [weakSelf addCurrentSongToPlaylist:playlist];
        }];
        [items addObject:item];
    }
    if (items.count == 0) {
        UIAction *empty = [UIAction actionWithTitle:@"还没有创建歌单" image:nil identifier:nil
                                            handler:^(__kindof UIAction * _Nonnull action) {}];
        empty.attributes = UIMenuElementAttributesDisabled;
        [items addObject:empty];
    }

    UIMenu *addMenu = [UIMenu menuWithTitle:@"添加到我的歌单"
                                      image:[UIImage systemImageNamed:@"plus"]
                                 identifier:nil
                                    options:0
                                   children:items];

    return [UIMenu menuWithTitle:@"" children:@[shareAction, addMenu]];
}

- (void)shareCurrentSong {
    Song *song = self.playerModel.currentSong;
    if (!song) return;

    NSString *text = [NSString stringWithFormat:@"我正在听《%@》— %@",
                      song.songName, song.singer.singerName ?: @"未知歌手"];

    NSString *cover = song.coverURL;
    if ([cover hasPrefix:@"http"]) {
        // 网络封面：交给 SDWebImage（有缓存直接用），拿到图后再弹分享面板
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:cover]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage * _Nullable image, NSData * _Nullable data,
                                                             NSError * _Nullable error, SDImageCacheType cacheType,
                                                             BOOL finished, NSURL * _Nullable imageURL) {
            if (!finished) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentShareWithText:text image:image];   // 下载失败时 image 为 nil，只分享文字
            });
        }];
        return;
    }

    // 本地封面（如 "9.jpg"）
    [self presentShareWithText:text image:[UIImage imageNamed:cover]];
}

/// 有图就带上封面一起分享。图片必须放第一个：
/// 分享面板的预览只渲染第一个 item，文字在前会只显示文字，让人误以为没带图
- (void)presentShareWithText:(NSString *)text image:(nullable UIImage *)image {
    NSMutableArray *items = [NSMutableArray array];
    if (image) [items addObject:image];
    [items addObject:text];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)addCurrentSongToPlaylist:(SongListModel *)playlist {
    Song *song = self.playerModel.currentSong;
    if (!song) return;

    [[UserModel sharedInstance] addSong:song toPlaylist:playlist];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已添加"
                                                                   message:[NSString stringWithFormat:@"《%@》已加入「%@」", song.songName, playlist.playlistName]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)progressSliderTouchDown:(UISlider *)slider {
    self.isDraggingProgress = YES;   // 暂停自动更新
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    // 只更新时间标签
    NSTimeInterval duration = [SPAudioPlayer sharedPlayer].duration;
    if (duration > 0) {
        self.detailView.currentTimeLabel.text = [SPAudioPlayer timeStringFromSeconds:duration * slider.value];
    }
}

- (void)progressSliderTouchUp:(UISlider *)slider {
    self.isDraggingProgress = NO;   // 恢复自动更新
    [[SPAudioPlayer sharedPlayer] seekToProgress:slider.value];   // 真正 seek
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end



