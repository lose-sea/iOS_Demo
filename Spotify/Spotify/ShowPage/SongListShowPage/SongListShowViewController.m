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
#import "UserModel.h"
#import "Song.h"

@interface SongListShowViewController () <UITableViewDelegate, UITableViewDataSource,
                                          HomeViewTableViewCellDelegate>

@property (nonatomic, strong) SongListShowView *songListView;
/// 上滑后吸顶显示的标题（同样支持跑马灯）
@property (nonatomic, strong) MarqueeLabel *navTitleLabel;

@end

@implementation SongListShowViewController

#pragma mark - 生命周期

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 播放状态变化时刷新列表，让「正在播放」的那一行保持暂停图标、其余行回到播放图标
- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerModelDidChange)
                                                 name:PlayerModelDidChangeNotification
                                               object:nil];
}

- (void)playerModelDidChange {
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
    [[UserModel sharedInstance] toggleFavouriteForSong:song];
    [self.songListView.tableView reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];

    // 收藏的正好是当前播放的歌时，通知播放器页面同步红心
    if (song == [PlayerModel sharedInstance].song) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                            object:[PlayerModel sharedInstance]];
    }

    NSLog(@"%@收藏：%@", song.isFavourite ? @"" : @"取消", song.songName);
    // TODO: 接 WCDB 后在这里写收藏表（FavoriteDAO）
}

- (void)songCellDidTapPlay:(SongRowCell *)cell {
    NSIndexPath *indexPath = [self.songListView.tableView indexPathForCell:cell];
    if (!indexPath) return;

    Song *song = self.songList.songs[indexPath.row];
    PlayerModel *playerModel = [PlayerModel sharedInstance];

    // 点的就是当前这首歌 → 暂停 / 继续
    if (song == playerModel.song) {
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

    // 内容坐标 → 屏幕坐标：往上滑 contentOffset.y 变大，歌单名位置变小（之前这里写成了 +，导致永远算不出渐变）
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
    NSLog(@"收藏歌单：%@", self.songList.playlistName);
}

- (void)pressMoreButton {
    NSLog(@"更多操作：%@", self.songList.playlistName);
}

#pragma mark - Private

- (BOOL)isSongPlaying:(Song *)song {
    PlayerModel *playerModel = [PlayerModel sharedInstance];
    return (song == playerModel.song) && playerModel.isPlay;
}

- (void)playSongAtIndex:(NSInteger)index {
    NSArray<Song *> *songs = self.songList.songs;
    if (index >= songs.count) return;

    // 先设置歌单，上一首/下一首才知道在哪个列表里切
    [PlayerModel sharedInstance].currentPlayList = self.songList;
    [[PlayerViewController sharedInstance] playSong:songs[index]];
}

@end
