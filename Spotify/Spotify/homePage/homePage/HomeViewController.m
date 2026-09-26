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
    // TODO: 网易云接口接好后，在这里拉推荐歌曲并替换「今日推荐」
    self.sections = [HomeModel sampleSections];
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

    // 分区里带 song 的说明是网络数据，用它们当播放列表；否则退回本地占位歌曲
    NSArray<Song *> *songs = [self songsInSection:section];
    SongListModel *songList = [[SongListModel alloc] init];
    songList.playlistName = card.title;
    songList.coverURL = card.imageURL;
    songList.songs = songs.count > 0 ? songs : [HomeModel sampleSongs];

    SongListShowViewController *songListVC = [[SongListShowViewController alloc] init];
    songListVC.songList = songList;
    songListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:songListVC animated:YES];

    // 点哪首播哪首（走 Song.audioURL）
    if (card.song) {
        [PlayerModel sharedInstance].currentPlayList = songList;
        [[PlayerViewController sharedInstance] playSong:card.song];
    }
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
