//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import <Masonry/Masonry.h>
#import "DrawerViewController.h"

#pragma mark - 工具函数

/// 把素材图片裁剪缩放成正方形（系统 UITableViewCell 的 imageView 会按图片尺寸布局）
static UIImage *HomeSquareImage(NSString *imageName, CGFloat side) {
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        return nil;
    }
    CGSize targetSize = CGSizeMake(side, side);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:targetSize];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        CGFloat scale = MAX(side / image.size.width, side / image.size.height);
        CGSize drawSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
        CGRect drawRect = CGRectMake((side - drawSize.width) / 2.0,
                                    (side - drawSize.height) / 2.0,
                                    drawSize.width,
                                    drawSize.height);
        [image drawInRect:drawRect];
    }];
}

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, HomePlaylistCardsCellDelegate>

@property (nonatomic, strong) HomeView *homeView;

/// Section 0：横向歌单卡片数据（dict: image / title / desc）
@property (nonatomic, strong) NSArray<NSDictionary *> *playlistCards;
/// Section 1：歌曲列表数据（dict: image / title / artist）
@property (nonatomic, strong) NSArray<NSDictionary *> *songs;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];

    [self loadPlaceholderData];
    [self setUpInterface];
    [self setUpNavigation];

    self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

#pragma mark - 数据（占位，后续由 HomeModel 提供）

- (void)loadPlaceholderData {
    // Section 0 横向卡片
    self.playlistCards = @[
        @{@"image": @"1.jpg",  @"title": @"Daily Mix 1",    @"desc": @"根据你的口味生成"},
        @{@"image": @"2.jpg",  @"title": @"发现周刊",        @"desc": @"每周为你更新的新音乐"},
        @{@"image": @"3.jpg",  @"title": @"热门华语",        @"desc": @"当下最火的华语歌曲"},
        @{@"image": @"4.jpg",  @"title": @"专注轻音乐",      @"desc": @"写代码时的最佳伴侣"},
        @{@"image": @"5.jpg",  @"title": @"复古派对",        @"desc": @"80、90 年代经典金曲"},
        @{@"image": @"6.jpg",  @"title": @"深夜独处",        @"desc": @"安静的夜晚，安静的歌"},
        @{@"image": @"7.jpg",  @"title": @"运动节拍",        @"desc": @"高燃 BPM 助你燃脂"},
        @{@"image": @"8.jpg",  @"title": @"轻松午后",        @"desc": @"慵懒时光，慢慢享受"}
    ];

    // Section 1 歌曲列表
    self.songs = @[
        @{@"image": @"9.jpg",  @"title": @"晴天",             @"artist": @"周杰伦"},
        @{@"image": @"10.jpg", @"title": @"Blinding Lights",  @"artist": @"The Weeknd"},
        @{@"image": @"11.jpg", @"title": @"夜曲",             @"artist": @"周杰伦"},
        @{@"image": @"12.jpg", @"title": @"Shape of You",     @"artist": @"Ed Sheeran"},
        @{@"image": @"13.jpg", @"title": @"稻香",             @"artist": @"周杰伦"},
        @{@"image": @"14.jpg", @"title": @"Levitating",       @"artist": @"Dua Lipa"},
        @{@"image": @"15.jpg", @"title": @"七里香",           @"artist": @"周杰伦"},
        @{@"image": @"16.jpg", @"title": @"Bad Guy",          @"artist": @"Billie Eilish"},
        @{@"image": @"17.jpg", @"title": @"后来",             @"artist": @"刘若英"},
        @{@"image": @"18.jpg", @"title": @"Watermelon Sugar", @"artist": @"Harry Styles"},
        @{@"image": @"19.jpg", @"title": @"平凡之路",         @"artist": @"朴树"},
        @{@"image": @"20.jpg", @"title": @"Stay",             @"artist": @"The Kid LAROI, Justin Bieber"}
    ];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1; // 横向卡片区域只占一行
    }
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Section 0：内嵌横向 UICollectionView 的容器 cell
        HomePlaylistCardsCell *cell =
            [tableView dequeueReusableCellWithIdentifier:HomePlaylistCardsCellID
                                            forIndexPath:indexPath];
        cell.delegate = self;
        cell.cards = self.playlistCards;
        return cell;
    }

    // Section 1：系统 Subtitle 样式 cell（小封面 + 歌名/歌手两行 + 更多按钮）
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeSongCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:HomeSongCellID];
    }

    NSDictionary *song = self.songs[indexPath.row];

    cell.imageView.image = HomeSquareImage(song[@"image"], 44);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 4;

    cell.textLabel.text = song[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor labelColor];

    cell.detailTextLabel.text = song[@"artist"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];

    cell.backgroundColor = [UIColor systemBackgroundColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // 最右侧“更多”按钮（懒创建，避免复用重复加 target）
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
    if (indexPath.section == 0) {
        return [HomePlaylistCardsCell rowHeight];
    }
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *song = self.songs[indexPath.row];
    NSLog(@"选中歌曲: %@ - %@", song[@"title"], song[@"artist"]);
    // TODO: 后续在这里更新 miniPlayer / push 播放页
}

#pragma mark - HomePlaylistCardsCellDelegate

- (void)playlistCardsCell:(HomePlaylistCardsCell *)cell didSelectCardAtIndex:(NSInteger)index {
    NSDictionary *card = self.playlistCards[index];
    NSLog(@"选中歌单卡片: %@", card[@"title"]);
    // TODO: 后续 push 歌单详情页
}

#pragma mark - 更多按钮

- (void)moreButtonTapped:(UIButton *)sender {
    NSDictionary *song = self.songs[sender.tag];
    NSLog(@"点击更多按钮: %@ - %@", song[@"title"], song[@"artist"]);
}

#pragma mark - Navigation（原有代码，保持不动）

- (void)setUpNavigation {

    // 设置头像按钮, 打开菜单视图
    UIImage *image = [UIImage imageNamed:@"51.jpg"];

    UIButton* imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [imageButton setImage: image forState: UIControlStateNormal];

    [self.view addSubview: imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(44);
    }];
    [imageButton addTarget: self action: @selector(pressMenuButton) forControlEvents: UIControlEventAllEvents];
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 22;

    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView: imageButton];
//    self.navigationItem.leftBarButtonItem = menuButton;

    UIBarButtonItemGroup* menuGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems: @[menuButton] representativeItem: nil];


    // 添加选项按钮
    UIBarButtonItem* allItem = [[UIBarButtonItem alloc] initWithTitle: @"All" style: UIBarButtonItemStylePlain target: self action: @selector(pressAllPage)];

    UIBarButtonItem* musicItem = [[UIBarButtonItem alloc] initWithTitle: @"Music" style: UIBarButtonItemStylePlain target: self action: @selector(pressMusicPage)];

    UIBarButtonItem* blogItem = [[UIBarButtonItem alloc] initWithTitle: @"Podcast" style: UIBarButtonItemStylePlain target: self action: @selector(pressBlogPage)];

    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[allItem, musicItem, blogItem]
        representativeItem:nil];

    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
}


- (void)pressAllPage {
    NSLog(@"点击全部");
}
- (void)pressMusicPage {
    NSLog(@"点击音乐");
}
- (void)pressBlogPage {
    NSLog(@"点击播客");
}


//- (void) setUpNavigation {
//    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"51.jpg"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
//    self.navigationItem.leftBarButtonItem = menus;
//}


- (void) pressMenuButton {
    NSLog(@"点击了菜单按钮");
    UIViewController* root = self.view.window.rootViewController;
    if ([root isKindOfClass: [DrawerViewController class]]) {
        [(DrawerViewController*)root openMenu];
    }
}

@end
