//
//  SongListViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import "SongListShowViewController.h"
#import "SongListShowView.h"
#import "MarqueeLabel.h"
#import "SongRowCell.h"
#import "PlayerViewController.h"
#import "PlayerModel.h"
#import "FavouriteManager.h"
#import "Song.h"
#import "NeteaseService.h"

@interface SongListShowViewController () <UITableViewDelegate, UITableViewDataSource,
                                          HomeViewTableViewCellDelegate>

@property (nonatomic, strong) SongListShowView *songListView;
/// 上滑后吸顶显示的标题（同样支持跑马灯）
@property (nonatomic, strong) MarqueeLabel *navTitleLabel;

@end

@implementation SongListShowViewController

#pragma mark - 生命周期

// self.view 创建的时候调用
- (void)loadView {
    SongListShowView *songListView = [[SongListShowView alloc] init];
    self.songListView = songListView;
    self.view = songListView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.songListView configureWithSongList:self.songList];
    [self setUpNavigation];
    [self setUpTableView];
    [self setUpActions];
    [self setUpNotification];
}

// 收藏状态可能在别的页面改过，每次出现都重读一次，保证红心和「我的收藏」一致
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFavouriteButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 播放状态变化时刷新列表，让「正在播放」的那一行保持暂停图标、其余行回到播放图标
- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerModelDidChange)
                                                 name:PlayerModelDidChangeNotification
                                               object:nil];
    // 在详情页 / mini player 收藏了列表里的歌，回到这页（或这页就在下面）时红心要同步
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(favouriteDidChange:)
                                                 name:FavouriteDidChangeNotification
                                               object:nil];
}

- (void)playerModelDidChange {
    [self.songListView.tableView reloadData];
}

// 收藏状态变了：重刷整张列表，让每一行的红心都和「我的喜欢」一致
- (void)favouriteDidChange:(NSNotification *)notification {
    [self.songListView.tableView reloadData];
}

#pragma mark - 初始化

- (void)setUpNavigation {
    // 吸顶标题：默认透明，上滑盖住 header 里的歌单名后渐显
    self.navTitleLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 220.0, 30.0)];
    self.navTitleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
    self.navTitleLabel.textColor = [UIColor labelColor];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.text = self.songList.playlistName ?: @"";
    self.navTitleLabel.alpha = 0;
    self.navTitleLabel.alwaysScroll = YES; 
    self.navigationItem.titleView = self.navTitleLabel;
}

- (void)setUpTableView {
    self.songListView.tableView.delegate = self;
    self.songListView.tableView.dataSource = self;
}

- (void)setUpActions {
    [self.songListView.playButton addTarget:self
                                     action:@selector(pressPlayButton)
                           forControlEvents:UIControlEventTouchUpInside];
    [self.songListView.favouriteButton addTarget:self
                                          action:@selector(pressFavouriteButton)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.songListView.moreButton addTarget:self
                                     action:@selector(pressMoreButton)
                           forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 异步回填

// 首页卡片点进来时歌曲还没到，到了之后填进当前歌单并刷新（header 的「N 首歌曲」也要更新）
- (void)updateWithSongs:(NSArray<Song *> *)songs {
    self.songList.songs = songs ?: @[];
    [self.songListView configureWithSongList:self.songList];
    [self.songListView.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songList.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongRowCell *cell = [tableView dequeueReusableCellWithIdentifier:SongListSongCellID];
    if (!cell) {
        cell = [[SongRowCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:SongListSongCellID];
    }
    cell.delegate = self;
    Song *song = self.songList.songs[indexPath.row];
    [cell configureWithSong:song isPlaying:[self isSongPlaying:song]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SongRowCell rowHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self playSongAtIndex:indexPath.row];
}

#pragma mark - HomeViewTableViewCellDelegate

// 单独收藏某一首歌
- (void)songCellDidTapFavourite:(SongRowCell *)cell {
    NSIndexPath *indexPath = [self.songListView.tableView indexPathForCell:cell];
    if (!indexPath) return;

    Song *song = self.songList.songs[indexPath.row];
    // 统一入口：同步「我的喜欢」歌单
    [[FavouriteManager sharedInstance] toggleFavouriteForSong:song];
    // FavouriteManager 会发 FavouriteDidChangeNotification，本页和播放器都会自己刷新，不用再手动同步
    [self.songListView.tableView reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];

    NSLog(@"%@收藏：%@", song.isFavourite ? @"" : @"取消", song.songName);
    // TODO: 接 WCDB 后在这里写收藏表（FavoriteDAO）
}

- (void)songCellDidTapPlay:(SongRowCell *)cell {
    NSIndexPath *indexPath = [self.songListView.tableView indexPathForCell:cell];
    if (!indexPath) return;

    Song *song = self.songList.songs[indexPath.row];
    PlayerModel *playerModel = [PlayerModel sharedInstance];

    // 点的就是当前这首歌 → 暂停 / 继续
    if (song == playerModel.currentSong) {
        playerModel.isPlay = !playerModel.isPlay;
        return;
    }

    [self playSongAtIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate

// header 里的歌单名被导航栏盖住后，把它显示到导航栏上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 导航栏底部换算到 tableView 坐标系，避免页面被下推（edgesForExtendedLayout 变化）时算错
    CGRect navBarFrame = [self.navigationController.navigationBar convertRect:self.navigationController.navigationBar.bounds
                                                                      toView:scrollView];
    CGFloat navBottom = CGRectGetMaxY(navBarFrame);

    // 内容坐标 → 屏幕坐标：往上滑 contentOffset.y 变大，歌单名位置变小
    CGFloat nameBottom = [self.songListView nameLabelBottomInHeader] - scrollView.contentOffset.y;

    // nameBottom 小于 navBottom 说明歌单名已经被导航栏盖住，此时把标题显示到导航栏上
    CGFloat distance = navBottom - nameBottom;
    CGFloat alpha = (distance <= 0) ? 0 : MIN(1.0, distance / 24.0);
    self.navTitleLabel.alpha = alpha;
}

#pragma mark - 事件

- (void)pressPlayButton {
    [self playSongAtIndex:0];
}

- (void)pressFavouriteButton {
    if (!self.songList) return;

    BOOL collected = [[FavouriteManager sharedInstance] isFavouritePlaylist:self.songList];
    [[FavouriteManager sharedInstance] setPlaylist:self.songList favourite:!collected];
    NSLog(@"%@收藏歌单：%@", collected ? @"取消" : @"", self.songList.playlistName);

    [self refreshFavouriteButton];
}

/// 歌单收藏状态：已收藏实心红心 + 粉色，未收藏空心 + 默认色
- (void)refreshFavouriteButton {
    BOOL collected = [[FavouriteManager sharedInstance] isFavouritePlaylist:self.songList];
    NSString *iconName = collected ? @"heart.fill" : @"heart";
    [self.songListView.favouriteButton setImage:[UIImage systemImageNamed:iconName]
                                       forState:UIControlStateNormal];
    self.songListView.favouriteButton.tintColor = collected ? [UIColor systemPinkColor] : [UIColor labelColor];
}

- (void)pressMoreButton {
    NSLog(@"更多操作：%@", self.songList.playlistName);
}

#pragma mark - Private

- (BOOL)isSongPlaying:(Song *)song {
    PlayerModel *playerModel = [PlayerModel sharedInstance];
    return (song == playerModel.currentSong) && playerModel.isPlay;
}

- (void)playSongAtIndex:(NSInteger)index {
    NSArray<Song *> *songs = self.songList.songs;
    if (index >= songs.count) return;

    Song *song = songs[index];

    // 先设置歌单，上一首/下一首才知道在哪个列表里切
    [PlayerModel sharedInstance].currentPlayList = self.songList;

    // 搜索等接口拿到的歌可能还没有播放地址，播放前现取一次（已取过则直接播）
    if (song.audioURL.length == 0 && song.songId.length > 0) {
        [[NeteaseService sharedInstance] fetchSongURLWithId:song.songId
                                                 completion:^(NSString *url, NSError *error) {
            if (url.length > 0) {
                song.audioURL = url;
            } else {
                NSLog(@"[SongList] 取播放地址失败：%@", error.localizedDescription);
            }
            [[PlayerViewController sharedInstance] playSong:song];
        }];
    } else {
        [[PlayerViewController sharedInstance] playSong:song];
    }
}

@end
