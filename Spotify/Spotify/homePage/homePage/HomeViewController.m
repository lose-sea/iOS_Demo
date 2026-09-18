//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeModel.h"
#import "PlayerViewController.h"
#import "DrawerViewController.h"
#import <Masonry/Masonry.h>
#import "Singer.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, HomePlaylistCardsCellDelegate>

@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) NSArray<NSDictionary *> *playlistCards;
@property (nonatomic, strong) NSArray<Song *> *songs;

@end

@implementation HomeViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self loadData];
    [self setUpInterface];
    [self setUpNavigation];
    [self bindMiniPlayer];

    self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

#pragma mark - 数据

- (void)loadData {
    self.playlistCards = [HomeModel samplePlaylistCards];
    self.songs = [HomeModel sampleSongs];
}

#pragma mark - HomeView

- (void)setUpInterface {
    self.homeView = [[HomeView alloc] init];
    [self.view addSubview:self.homeView];

    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];

    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
    self.homeView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

/// 给 miniPlayer 绑定点击事件（整个 miniPlayerView 点开全屏、播放按钮单独 toggle）
- (void)bindMiniPlayer {
    // 点击 miniPlayer 弹全屏 PlayerViewController
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(miniPlayerTapped)];
    [self.homeView.miniPlayerView addGestureRecognizer:tap];
    self.homeView.miniPlayerView.userInteractionEnabled = YES;

    [self.homeView.playerPlayButton addTarget:self
                                       action:@selector(miniPlayerPlayButtonTapped)
                             forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - miniPlayer 事件

- (void)miniPlayerTapped {
    // 确保没有其他 VC 正在 present，然后 present PlayerVC 单例
    UIViewController *root = self.view.window.rootViewController;
    if (root.presentedViewController) {
        [root.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [root presentViewController:[PlayerViewController sharedInstance]
                               animated:YES
                             completion:nil];
        }];
    } else {
        [root presentViewController:[PlayerViewController sharedInstance]
                           animated:YES
                         completion:nil];
    }
}

- (void)miniPlayerPlayButtonTapped {
    [[PlayerViewController sharedInstance] togglePlayPause];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePlaylistCardsCell *cell =
            [tableView dequeueReusableCellWithIdentifier:HomePlaylistCardsCellID
                                            forIndexPath:indexPath];
        cell.delegate = self;
        cell.cards = self.playlistCards;
        return cell;
    }

    // Section 1：系统 Subtitle 样式 cell + 更多按钮
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeSongCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:HomeSongCellID];
    }

    Song *song = self.songs[indexPath.row];

    cell.imageView.image = song.songCover;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 4;
    cell.imageView.layer.masksToBounds = YES;

    cell.textLabel.text = song.songName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor labelColor];

    cell.detailTextLabel.text = song.singer.singerName;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];

    cell.backgroundColor = [UIColor systemBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // 懒创建更多按钮（复用）
    UIButton *moreButton = (UIButton *)cell.accessoryView;
    if (!moreButton) {
        moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [moreButton setImage:[UIImage systemImageNamed:@"ellipsis"]
                    forState:UIControlStateNormal];
        moreButton.tintColor = [UIColor secondaryLabelColor];
        moreButton.frame = CGRectMake(0, 0, 28, 28);
        [moreButton addTarget:self
                       action:@selector(moreButtonTapped:)
             forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = moreButton;
    }
    moreButton.tag = indexPath.row;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? [HomePlaylistCardsCell rowHeight] : 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Song *song = self.songs[indexPath.row];
    [[PlayerViewController sharedInstance] playSong:song];
}

#pragma mark - HomePlaylistCardsCellDelegate

- (void)playlistCardsCell:(HomePlaylistCardsCell *)cell didSelectCardAtIndex:(NSInteger)index {
    NSLog(@"选中歌单卡片: %@", self.playlistCards[index][@"title"]);
}

#pragma mark - 更多按钮

- (void)moreButtonTapped:(UIButton *)sender {
    Song *song = self.songs[sender.tag];
    NSLog(@"更多: %@ - %@", song.songName, song.singer.singerName);
}

#pragma mark - Navigation（保留原有头像按钮 + 抽屉逻辑）

- (void)setUpNavigation {
    // 头像按钮（44×44 圆形）—— 这次只挂到导航栏，不再 add 到 self.view 压在 tableView 上
    UIImage *image = [UIImage imageNamed:@"51.jpg"];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setImage:image forState:UIControlStateNormal];
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 22;
    imageButton.frame = CGRectMake(0, 0, 44, 44);
    [imageButton addTarget:self
                    action:@selector(pressMenuButton)
          forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    UIBarButtonItemGroup *menuGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[menuButton]
                                                                         representativeItem:nil];

    // All / Music / Podcast 分段按钮
    UIBarButtonItem *allItem = [[UIBarButtonItem alloc] initWithTitle:@"All"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(pressAllPage)];
    UIBarButtonItem *musicItem = [[UIBarButtonItem alloc] initWithTitle:@"Music"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(pressMusicPage)];
    UIBarButtonItem *blogItem = [[UIBarButtonItem alloc] initWithTitle:@"Podcast"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(pressBlogPage)];
    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[allItem, musicItem, blogItem]
            representativeItem:nil];

    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
}

- (void)pressAllPage { NSLog(@"点击全部"); }
- (void)pressMusicPage { NSLog(@"点击音乐"); }
- (void)pressBlogPage { NSLog(@"点击播客"); }

- (void)pressMenuButton {
    NSLog(@"点击了菜单按钮");
    UIViewController *root = self.view.window.rootViewController;
    if ([root isKindOfClass:[DrawerViewController class]]) {
        [(DrawerViewController *)root openMenu];
    }
}

@end
