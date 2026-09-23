//
//  MyViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import "MyViewController.h"
#import "MyView.h"
#import "MyModel.h"
#import "MyPlaylistCell.h"
#import "SongListModel.h"
#import "SongListShowViewController.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MyView *myView;
@property (nonatomic, strong) MyModel *myModel;

@end

@implementation MyViewController

#pragma mark - 生命周期

- (void)loadView {
    MyView *myView = [[MyView alloc] init];
    self.myView = myView;
    self.view = myView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myModel = [[MyModel alloc] init];
    [self.myView configureWithModel:self.myModel];
    [self setUpTableView];
    [self setUpActions];
}

#pragma mark - 初始化

- (void)setUpTableView {
    self.myView.tableView.delegate = self;
    self.myView.tableView.dataSource = self;
    [self.myView.tableView reloadData];
}

- (void)setUpActions {
    __weak typeof(self) weakSelf = self;

    self.myView.onPlaylistTypeChanged = ^(BOOL showingCollected) {
        [weakSelf.myView.tableView reloadData];
    };

    self.myView.onCreatePlaylist = ^{
        [weakSelf showCreatePlaylistAlert];
    };
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;   // 我的喜欢 / 创建的歌单|收藏的歌单（切换条）
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    NSArray<SongListModel *> *playlists = self.myView.showingCollected
        ? self.myModel.collectedPlaylists
        : self.myModel.createdPlaylists;
    return playlists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlaylistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyPlaylistCell"];
    if (!cell) {
        cell = [[MyPlaylistCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"MyPlaylistCell"];
    }
    [cell configureWithPlaylist:[self playlistAtIndexPath:indexPath]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"我的喜欢";
    return nil;   // 分区 1 用自定义切换条作 header
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyPlaylistCell rowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) return 44.0;
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) return [self.myView playlistTabHeader];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SongListModel *playlist = [self playlistAtIndexPath:indexPath];
    SongListShowViewController *songListVC = [[SongListShowViewController alloc] init];
    songListVC.songList = playlist;
    songListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:songListVC animated:YES];
}

#pragma mark - 创建歌单

- (void)showCreatePlaylistAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建歌单"
                                                                   message:@"给歌单起个名字"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"歌单名称";
    }];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"创建"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
        NSString *name = [alert.textFields.firstObject.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self createPlaylistWithName:name.length > 0 ? name : @"新建歌单"];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

// 写入 UserModel 单例的 createSongLists，其他页面（菜单、歌单页等）读同一份数据
- (void)createPlaylistWithName:(NSString *)name {
    SongListModel *playlist = [[SongListModel alloc] init];
    playlist.playlistName = name;
    playlist.coverURL = @"1.jpg";
    playlist.songs = @[];

    UserModel *user = [UserModel sharedInstance];
    NSMutableArray<SongListModel *> *created = [user.createSongLists mutableCopy] ?: [NSMutableArray array];
    [created addObject:playlist];
    user.createSongLists = created;

    // 切回“创建的歌单”让用户新建的立刻可见
    [self.myView setTabShowingCollected:NO];
    [self.myView.tableView reloadData];
}

#pragma mark - Private

- (SongListModel *)playlistAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return self.myModel.favouritePlaylist;

    NSArray<SongListModel *> *playlists = self.myView.showingCollected
        ? self.myModel.collectedPlaylists
        : self.myModel.createdPlaylists;
    return playlists[indexPath.row];
}

@end
