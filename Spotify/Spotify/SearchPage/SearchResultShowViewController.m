//
//  SearchResultShowViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchResultShowViewController.h"
#import "HomeModel.h"
#import "PlayerModel.h"
#import "PlayerViewController.h"
#import "UserModel.h"
#import "SongRowCell.h"
#import "Song.h"
#import <Masonry/Masonry.h>

static NSString * const kResultSongCellID = @"SearchResultSongCell";
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0;
/// 数据源尝试顺序（与 runProviderAtIndex: 的 case 顺序一致）
static NSArray<NSString *> *kProviderNames = nil;   // 接好数据源后填，例如 @"网易云"

@interface SearchResultShowViewController () <UITableViewDelegate, UITableViewDataSource,
                                              HomeViewTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSArray<Song *> *songs;

@end

@implementation SearchResultShowViewController

+ (void)initialize {
    if (self == SearchResultShowViewController.class) {
        kProviderNames = @[];   // 网易云接好后填 @"网易云"
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setUpInterface];
    [self setUpTableView];
}

#pragma mark - 界面

- (void)setUpInterface {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];

    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:15.0];
    self.placeholderLabel.textColor = [UIColor secondaryLabelColor];
    self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
    self.placeholderLabel.text = @"输入关键字开始搜索";
    [self.view addSubview:self.placeholderLabel];

    [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-40.0);
    }];

    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spinner.mas_bottom).offset(12.0);
        make.left.equalTo(self.view).offset(24.0);
        make.right.equalTo(self.view).offset(-24.0);
    }];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 底部给 mini player 留白
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kMiniPlayerReservedHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 搜索

// 第一次搜索可能发生在 viewDidLoad 之前（搜索框一激活就触发），
// 这里主动访问 view 触发加载，保证下面的 tableView / spinner 都存在
- (void)searchWithKeyword:(NSString *)keyword {
    if (!self.isViewLoaded) {
        (void)self.view;
    }

    self.keyword = keyword ?: @"";
    NSLog(@"[Search] 开始搜索：%@", self.keyword);

    if (self.keyword.length == 0) {
        self.songs = @[];
        self.placeholderLabel.text = @"输入关键字开始搜索";
        [self refreshPlaceholder];
        [self.tableView reloadData];
        return;
    }

    self.songs = @[];
    self.placeholderLabel.text = nil;
    [self refreshPlaceholder];
    [self.tableView reloadData];
    [self.spinner startAnimating];

    // TODO: 网易云接口接好后，在 kProviderNames / runProviderAtIndex: 里挂上 NeteaseService
    [self searchNextProviderAtIndex:0 keyword:self.keyword];
}

/// 依次尝试各个数据源，谁先拿到结果就用谁的；全部失败才回退到本地假数据
- (void)searchNextProviderAtIndex:(NSInteger)index keyword:(NSString *)keyword {
    if (index >= kProviderNames.count) {
        [self.spinner stopAnimating];
        NSArray<Song *> *localSongs = [self localSongsMatchingKeyword:keyword];
        NSLog(@"[Search] 暂无网络数据源（kProviderNames 为空），本地兜底 %lu 首",
              (unsigned long)localSongs.count);
        self.songs = localSongs;
        self.placeholderLabel.text = localSongs.count > 0 ? nil : @"没有找到相关内容";
        [self refreshPlaceholder];
        [self.tableView reloadData];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self runProviderAtIndex:index
                     keyword:keyword
                  completion:^(NSArray<Song *> *songs, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![keyword isEqualToString:weakSelf.keyword]) return;

            if (!error && songs.count > 0) {
                [weakSelf.spinner stopAnimating];
                NSLog(@"[Search] %@ 搜到 %lu 首", kProviderNames[index], (unsigned long)songs.count);
                weakSelf.songs = songs;
                weakSelf.placeholderLabel.text = nil;
                [weakSelf refreshPlaceholder];
                [weakSelf.tableView reloadData];
                return;
            }

            NSLog(@"[Search] %@ 无结果（%@），换下一个源",
                  kProviderNames[index], error.localizedDescription ?: @"0 首");
            [weakSelf searchNextProviderAtIndex:index + 1 keyword:keyword];
        });
    }];
}

/// 具体某个数据源的请求（接网易云时在这里加 case 即可）
- (void)runProviderAtIndex:(NSInteger)index
                   keyword:(NSString *)keyword
                completion:(void (^)(NSArray<Song *> *songs, NSError * _Nullable error))completion {
    // 目前没有接入任何数据源
    if (completion) {
        completion(@[], [NSError errorWithDomain:@"com.spotify.search"
                                           code:-1
                                       userInfo:@{NSLocalizedDescriptionKey: @"暂无网络数据源"}]);
    }
}

/// 网络不可用时的兜底：在本地占位歌曲里按歌名 / 歌手模糊匹配
- (NSArray<Song *> *)localSongsMatchingKeyword:(NSString *)keyword {
    NSString *lowerKeyword = keyword.lowercaseString;
    if (lowerKeyword.length == 0) return @[];

    NSMutableArray<Song *> *result = [NSMutableArray array];
    for (Song *song in [HomeModel sampleSongs]) {
        NSString *name = song.songName.lowercaseString ?: @"";
        NSString *singer = song.singer.singerName.lowercaseString ?: @"";
        if ([name containsString:lowerKeyword] || [singer containsString:lowerKeyword]) {
            [result addObject:song];
        }
    }
    return [result copy];
}

- (void)refreshPlaceholder {
    self.placeholderLabel.hidden = (self.placeholderLabel.text.length == 0);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongRowCell *cell = [tableView dequeueReusableCellWithIdentifier:kResultSongCellID];
    if (!cell) {
        cell = [[SongRowCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kResultSongCellID];
    }
    cell.delegate = self;
    Song *song = self.songs[indexPath.row];
    [cell configureWithSong:song isPlaying:(song == [PlayerModel sharedInstance].song && [PlayerModel sharedInstance].isPlay)];
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

- (void)songCellDidTapPlay:(SongRowCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;

    Song *song = self.songs[indexPath.row];
    PlayerModel *playerModel = [PlayerModel sharedInstance];
    if (song == playerModel.song) {
        playerModel.isPlay = !playerModel.isPlay;   // 同一首：暂停 / 继续
        return;
    }
    [self playSongAtIndex:indexPath.row];
}

- (void)songCellDidTapFavourite:(SongRowCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;

    Song *song = self.songs[indexPath.row];
    // 统一入口：同步「我的喜欢」歌单
    [[UserModel sharedInstance] toggleFavouriteForSong:song];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];

    // 收藏的正好是当前播放的歌时，同步播放器页面的红心
    if (song == [PlayerModel sharedInstance].song) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PlayerModelDidChangeNotification
                                                            object:[PlayerModel sharedInstance]];
    }
}

#pragma mark - Private

- (void)playSongAtIndex:(NSInteger)index {
    if (index >= self.songs.count) return;

    // 播放列表就是本次搜索结果，上一首 / 下一首在其中循环
    // 搜索结果先包装成临时歌单，供上一首 / 下一首使用
    // 把结果包装成一个临时歌单，供切歌使用
    SongListModel *songList = [[SongListModel alloc] init];
    songList.playlistName = [NSString stringWithFormat:@"搜索：%@", self.keyword ?: @""];
    songList.songs = self.songs;
    [PlayerModel sharedInstance].currentPlayList = songList;

    [[PlayerViewController sharedInstance] playSong:self.songs[index]];
}

@end
