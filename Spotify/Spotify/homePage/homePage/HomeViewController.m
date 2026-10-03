//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeModel.h"
#import "HomeSection.h"
#import "HomeCard.h"
#import "HomeSectionCell.h"
#import "PlayerViewController.h"
#import "SongListShowViewController.h"
#import "SongListModel.h"
#import "PlayerModel.h"
#import "Song.h"
#import "NeteaseService.h"
#import "UIResponder+AppActions.h"

/// 顶部三个 "全部, 音乐, 播客" 筛选按钮的状态标识
typedef NS_ENUM(NSUInteger, HomeFilterIndex) {
    HomeFilterIndexAll = 0,
    HomeFilterIndexMusic,
    HomeFilterIndexPodcast
};

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, HomeSectionCellDelegate>

@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) NSArray<HomeSection *> *sections;
@property (nonatomic, assign) HomeFilterIndex filterIndex;

/// 头像裁剪压缩，size 为 pt
- (UIImage *)croppedToSquare:(UIImage *)image size:(CGSize)size;

@end

@implementation HomeViewController

#pragma mark - 生命周期

- (void)loadView {
    HomeView *homeView = [[HomeView alloc] init];
    self.homeView = homeView;
    self.view = homeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.filterIndex = HomeFilterIndexAll;
    [self loadData];
    [self setUpNavigation];
    [self setUpTableView];
}

#pragma mark - 数据准备

- (void)loadData {
    // 先用本地占位数据秒出页面，网络数据回来后逐个替换对应分区
    self.sections = [HomeModel sampleSections];

    [self fetchShortcutSection];
    [self fetchTodaySection];
    [self fetchArtistSections];
    [self fetchRadioSection];
    [self fetchAlbumSection];
}

#pragma mark - 网络分区

/// 快捷入口：官方榜单（飙升榜 / 新歌榜 …）
- (void)fetchShortcutSection {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchToplistWithLimit:2
                                               completion:^(NSArray<SongListModel *> *playlists, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!playlists.count) {
                NSLog(@"[Home] 榜单拉取失败：%@", error.localizedDescription);
                return;
            }
            [weakSelf replaceSection:[HomeModel shortcutSectionWithPlaylists:playlists]];
        });
    }];
}

/// 拉网易云官方「热歌榜」（歌单 id 3778678）替换「今日推荐」；失败时保留本地占位数据
- (void)fetchTodaySection {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchPlaylistDetailWithId:@"3778678"
                                                    completion:^(SongListModel *playlist, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!playlist.songs.count) {
                NSLog(@"[Home] 热歌榜拉取失败：%@", error.localizedDescription);
                return;
            }
            // 横向滚动取前 20 首就够了
            NSUInteger count = MIN(20, playlist.songs.count);
            NSArray<Song *> *songs = [playlist.songs subarrayWithRange:NSMakeRange(0, count)];
            [weakSelf replaceSection:[HomeModel todaySectionWithSongs:songs]];
        });
    }];
}

/// 热门歌手：前 5 个给「你喜欢的艺人」，后面 6 个给「你最喜欢的艺人」
- (void)fetchArtistSections {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchTopArtistsWithLimit:12
                                                  completion:^(NSArray<Singer *> *singers, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!singers.count) {
                NSLog(@"[Home] 热门歌手拉取失败：%@", error.localizedDescription);
                return;
            }
            NSUInteger firstCount = MIN(5, singers.count);
            [weakSelf replaceSection:[HomeModel artistSectionWithSingers:
                                      [singers subarrayWithRange:NSMakeRange(0, firstCount)]]];

            if (singers.count > firstCount) {
                NSUInteger restCount = MIN(6, singers.count - firstCount);
                [weakSelf replaceSection:[HomeModel circleSectionWithSingers:
                                          [singers subarrayWithRange:NSMakeRange(firstCount, restCount)]]];
            }
        });
    }];
}

- (void)fetchRadioSection {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchHotRadiosWithLimit:5
                                                 completion:^(NSArray<SongListModel *> *radios, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!radios.count) {
                NSLog(@"[Home] 推荐电台拉取失败：%@", error.localizedDescription);
                return;
            }
            [weakSelf replaceSection:[HomeModel radioSectionWithRadios:radios]];
        });
    }];
}

- (void)fetchAlbumSection {
    __weak typeof(self) weakSelf = self;
    [[NeteaseService sharedInstance] fetchNewAlbumsWithLimit:6
                                                 completion:^(NSArray<SongListModel *> *albums, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!albums.count) {
                NSLog(@"[Home] 新专辑拉取失败：%@", error.localizedDescription);
                return;
            }
            [weakSelf replaceSection:[HomeModel albumSectionWithAlbums:albums]];
        });
    }];
}

/// 用同名分区替换占位分区（占位数据保证一定存在，找不到就追加到末尾）
- (void)replaceSection:(HomeSection *)section {
    NSMutableArray<HomeSection *> *sections = [self.sections mutableCopy];
    NSUInteger idx = [sections indexOfObjectPassingTest:^BOOL(HomeSection *s, NSUInteger i, BOOL *stop) {
        return [s.title isEqualToString:section.title];
    }];
    if (idx == NSNotFound) {
        [sections addObject:section];
    } else {
        [sections replaceObjectAtIndex:idx withObject:section];
    }
    self.sections = [sections copy];
    [self.homeView.tableView reloadData];
}

- (void)setUpTableView {
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
    [self.homeView.tableView reloadData];
}

#pragma mark - Navigation

- (void)setUpNavigation {
    UIImage *original = [UIImage imageNamed:@"51.jpg"];
    UIImage *avatar = [[self croppedToSquare:original size:CGSizeMake(36, 36)]
                       // 裁剪为正方形
                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setImage:avatar forState:UIControlStateNormal];
    imageButton.frame = CGRectMake(0, 0, 36, 36);
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 18.0;
    [imageButton addTarget:self
                    action:@selector(pressMenuButton)
          forControlEvents:UIControlEventTouchUpInside];
    imageButton.accessibilityLabel = @"打开菜单";
    imageButton.accessibilityTraits = UIAccessibilityTraitButton;

    UIBarButtonItem *avatarItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    UIBarButtonItemGroup *menuGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[avatarItem]
            representativeItem:nil];

    UIBarButtonItem *allItem = [self filterItemWithTitle:@"全部"
                                                  action:@selector(pressAllPage)
                                                selected:(self.filterIndex == HomeFilterIndexAll)];
    UIBarButtonItem *musicItem = [self filterItemWithTitle:@"音乐"
                                                    action:@selector(pressMusicPage)
                                                  selected:(self.filterIndex == HomeFilterIndexMusic)];
    UIBarButtonItem *podcastItem = [self filterItemWithTitle:@"播客"
                                                      action:@selector(pressBlogPage)
                                                    selected:(self.filterIndex == HomeFilterIndexPodcast)];

    UIBarButtonItemGroup *filterGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[allItem, musicItem, podcastItem]
            representativeItem:nil];

    self.navigationItem.leadingItemGroups = @[menuGroup, filterGroup];
}


/// 胶囊样式的筛选按钮
- (UIBarButtonItem *)filterItemWithTitle:(NSString *)title action:(SEL)action selected:(BOOL)selected {
    UIFont *font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    /// sizeWithAttributes: NSString方法,用来测量一段文字在指定字体先占的宽度
    ///  参数传一个字典: @{NSFonAttributeName: font} 告诉用的是那个字体, 返回一个CGSize
    ///  这里 28 是指左右两边留白之和
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: font}].width + 28.0;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, width, 28.0);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    [button setTitleColor:selected ? [UIColor blackColor] : [UIColor labelColor]
                 forState:UIControlStateNormal];
    button.backgroundColor = selected
        ? [UIColor systemGreenColor]
    
        // 未选中背景用 labelColor 的半透明，浅色模式下才看得见
        : [[UIColor labelColor] colorWithAlphaComponent:0.15];
    
    button.layer.cornerRadius = 14.0;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}



- (void)pressAllPage {
    [self switchFilter:HomeFilterIndexAll];
}

- (void)pressMusicPage {
    [self switchFilter:HomeFilterIndexMusic];
}

- (void)pressBlogPage {
    [self switchFilter:HomeFilterIndexPodcast];
}

- (void)switchFilter:(HomeFilterIndex)index {
    if (self.filterIndex == index) return;
    self.filterIndex = index;
    [self setUpNavigation];
    NSLog(@"切换到筛选：%@", @[@"全部", @"音乐", @"播客"][index]);
}

/// 沿响应者链找能处理 openMenu 的容器（这里是 DrawerViewController），
/// 不直接依赖 window.rootViewController，避免页面被换容器后失效
- (void)pressMenuButton {
    [[UIApplication sharedApplication] sendAction:@selector(openMenu) to:nil from:self forEvent:nil];
}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeSectionCellID];
    if (!cell) {
        cell = [[HomeSectionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:HomeSectionCellID];
    }
    cell.delegate = self;
    [cell configureWithSection:self.sections[indexPath.section]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HomeSectionCell heightForSection:self.sections[indexPath.section]];
}

#pragma mark - HomeSectionCellDelegate

- (void)homeSectionCell:(HomeSectionCell *)cell didSelectCard:(HomeCard *)card atIndex:(NSInteger)index {
    NSLog(@"点击卡片：%@", card.title);

    NSIndexPath *indexPath = [self.homeView.tableView indexPathForCell:cell];
    HomeSection *section = (indexPath && indexPath.section < self.sections.count)
        ? self.sections[indexPath.section]
        : nil;

    SongListModel *songList = [[SongListModel alloc] init];
    songList.playlistName = card.title;
    songList.coverURL = card.imageURL;
    // 「今日推荐」这类卡片自带歌曲，直接就有内容；其余分区等网络回来再填
    songList.songs = [self songsInSection:section];

    SongListShowViewController *songListVC = [[SongListShowViewController alloc] init];
    songListVC.songList = songList;
    songListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:songListVC animated:YES];

    // 卡片自带歌曲：设好播放列表后直接播
    if (card.song) {
        [PlayerModel sharedInstance].currentPlayList = songList;
        [self playSong:card.song];
        return;
    }

    // 榜单 / 艺人 / 专辑 / 电台：歌曲要按来源现拉，拉到后回填到已经 push 出去的详情页
    [self loadSongsForCard:card intoViewController:songListVC];
}

/// 按卡片来源拉歌曲，回填到详情页（已经 push 出去了，所以这里只更新数据）
- (void)loadSongsForCard:(HomeCard *)card intoViewController:(SongListShowViewController *)viewController {
    if (card.source == HomeCardSourceNone) return;

    NeteaseService *service = [NeteaseService sharedInstance];
    void (^fill)(NSArray<Song *> *, NSError *) = ^(NSArray<Song *> *songs, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!songs.count) {
                NSLog(@"[Home] 「%@」取歌曲失败：%@", card.title, error.localizedDescription);
                return;
            }
            [viewController updateWithSongs:songs];
        });
    };

    if (card.source == HomeCardSourcePlaylist) {
        [service fetchPlaylistDetailWithId:card.sourceId
                                completion:^(SongListModel *playlist, NSError *error) {
            fill(playlist.songs, error);
        }];
    } else if (card.source == HomeCardSourceArtist) {
        [service fetchArtistSongsWithId:card.sourceId completion:fill];
    } else if (card.source == HomeCardSourceAlbum) {
        [service fetchAlbumSongsWithId:card.sourceId completion:fill];
    } else if (card.source == HomeCardSourceKeyword) {
        [service searchSongsWithKeyword:card.title limit:20 completion:fill];
    }
}

/// 播放前确保有 audioURL：网易云的播放地址有时效，接口歌曲统一现取
- (void)playSong:(Song *)song {
    if (song.audioURL.length == 0 && song.songId.length > 0) {
        [[NeteaseService sharedInstance] fetchSongURLWithId:song.songId
                                                 completion:^(NSString *url, NSError *error) {
            if (url.length > 0) {
                song.audioURL = url;
            } else {
                NSLog(@"[Home] 取播放地址失败：%@", error.localizedDescription);
            }
            [[PlayerViewController sharedInstance] playSong:song];
        }];
        return;
    }
    [[PlayerViewController sharedInstance] playSong:song];
}

#pragma mark - Private

/// 收集分区里所有带 song 的卡片（网络数据）
- (NSArray<Song *> *)songsInSection:(HomeSection *)section {
    NSMutableArray<Song *> *songs = [NSMutableArray array];
    for (HomeCard *card in section.cards) {
        if (card.song) [songs addObject:card.song];
    }
    return [songs copy];
}

// 裁剪成正方形并缩放到目标尺寸
- (UIImage *)croppedToSquare:(UIImage *)image size:(CGSize)size {
    CGSize imgSize = image.size;
    CGFloat side = MIN(imgSize.width, imgSize.height);
    CGRect cropRect = CGRectMake((imgSize.width - side) / 2,
                                 (imgSize.height - side) / 2,
                                 side, side);

    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    if (!cgImage) return image;

    UIImage *cropped = [UIImage imageWithCGImage:cgImage
                                           scale:image.scale
                                     orientation:image.imageOrientation];
    CGImageRelease(cgImage);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [cropped drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
