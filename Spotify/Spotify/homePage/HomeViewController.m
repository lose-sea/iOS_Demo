////
////  HomeViewController.m
////  Spotify
////
////  Created by lose_sea on 2026/9/2.
////
//
//#import "HomeViewController.h"
//#import <Masonry/Masonry.h>
//#import "DrawerViewController.h"
//
//@interface HomeViewController ()
//
//@end
//
//@implementation HomeViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
//    
//    [self setUpNavigation];
//    
//    self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
//}
//
//- (void)setUpNavigation {
//    
//    // 设置头像按钮, 打开菜单视图
//    UIImage *image = [UIImage imageNamed:@"51.jpg"];
//
//    UIButton* imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    [imageButton setImage: image forState: UIControlStateNormal];
//    
//    [self.view addSubview: imageButton];
//    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self.view);
//            make.width.height.mas_equalTo(44);
//    }];
//    [imageButton addTarget: self action: @selector(pressMenuButton) forControlEvents: UIControlEventAllEvents];
//    imageButton.clipsToBounds = YES;
//    imageButton.layer.cornerRadius = 22;
//    
//    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView: imageButton];
////    self.navigationItem.leftBarButtonItem = menuButton;
//    
//    UIBarButtonItemGroup* menuGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems: @[menuButton] representativeItem: nil];
//    
//    
//    // 添加选项按钮
//    UIBarButtonItem* allItem = [[UIBarButtonItem alloc] initWithTitle: @"All" style: UIBarButtonItemStylePlain target: self action: @selector(pressAllPage)];
//    
//    UIBarButtonItem* musicItem = [[UIBarButtonItem alloc] initWithTitle: @"Music" style: UIBarButtonItemStylePlain target: self action: @selector(pressMusicPage)];
//    
//    UIBarButtonItem* blogItem = [[UIBarButtonItem alloc] initWithTitle: @"Podcast" style: UIBarButtonItemStylePlain target: self action: @selector(pressBlogPage)];
//    
//    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc]
//        initWithBarButtonItems:@[allItem, musicItem, blogItem]
//        representativeItem:nil];
//    
//    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
//}
//
//
//- (void)pressAllPage {
//    NSLog(@"点击全部");
//}
//- (void)pressMusicPage {
//    NSLog(@"点击音乐");
//}
//- (void)pressBlogPage {
//    NSLog(@"点击播客");
//}
//
//
////- (void) setUpNavigation {
////    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"51.jpg"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
////    self.navigationItem.leftBarButtonItem = menus;
////}
//    
//
//
//- (void) pressMenuButton {
//    NSLog(@"点击了菜单按钮");
//    UIViewController* root = self.view.window.rootViewController;
//    if ([root isKindOfClass: [DrawerViewController class]]) {
//        [(DrawerViewController*)root openMenu];
//    }
//}
//
//@end
//
//
//
//
//
//
//
//












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

@interface HomeViewController ()
@property (nonatomic, strong) HomeView *homeView;
@property (nonatomic, strong) NSArray<NSString *> *placeholderItems; // 占位数据
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self setUpNavigation];

    // 占位数据，后续由 HomeModel 提供
    self.placeholderItems = @[
        @"Daily Mix",
        @"推荐歌单",
        @"新歌速递",
        @"热门歌曲",
        @"为你推荐",
        @"排行榜",
        @"播放历史",
        @"最近播放",
        @"收藏的歌曲",
        @"更多"
    ];

    [self setUpInterface];

    // 强制使用暗色风格如果需要
    // self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)setUpInterface {
    // 创建 HomeView 并添加约束
    self.homeView = [[HomeView alloc] init];
    [self.view addSubview:self.homeView];

    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // 设置 table 的 delegate/dataSource
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;

    // UI 微调
    self.homeView.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.homeView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // 示例：一个 section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeholderItems.count; // 占位
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSimpleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.placeholderItems[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"cover.jpg"]; // 占位小图
    cell.backgroundColor = [UIColor systemBackgroundColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80; // 示例高度，后续可根据 cell 内容调整
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   NSLog(@"选中行: %@", self.placeholderItems[indexPath.row]);
   // 这里 push 到播放页/歌单页等（后续接 Model）
}

#pragma mark - Navigation

- (void)setUpNavigation {
    // 设置头像按钮, 打开菜单视图
    UIImage *image = [UIImage imageNamed:@"51.jpg"];

    UIButton* imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [imageButton setImage: image forState: UIControlStateNormal];
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 22;
    imageButton.frame = CGRectMake(0, 0, 44, 44);
    [imageButton addTarget: self action: @selector(pressMenuButton) forControlEvents: UIControlEventTouchUpInside];

    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView: imageButton];
    UIBarButtonItemGroup* menuGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems: @[menuButton] representativeItem: nil];

    // 添加选项按钮 (示例)
    UIBarButtonItem* allItem = [[UIBarButtonItem alloc] initWithTitle: @"All" style: UIBarButtonItemStylePlain target: self action: @selector(pressAllPage)];
    UIBarButtonItem* musicItem = [[UIBarButtonItem alloc] initWithTitle: @"Music" style: UIBarButtonItemStylePlain target: self action: @selector(pressMusicPage)];
    UIBarButtonItem* blogItem = [[UIBarButtonItem alloc] initWithTitle: @"Podcast" style: UIBarButtonItemStylePlain target: self action: @selector(pressBlogPage)];
    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[allItem, musicItem, blogItem] representativeItem:nil];

    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
}

- (void)pressAllPage { NSLog(@"点击全部"); }
- (void)pressMusicPage { NSLog(@"点击音乐"); }
- (void)pressBlogPage { NSLog(@"点击播客"); }

- (void)pressMenuButton {
    NSLog(@"点击了菜单按钮");
    UIViewController* root = self.view.window.rootViewController;
    if ([root isKindOfClass: [DrawerViewController class]]) {
        [(DrawerViewController*)root openMenu];
    }
}

@end
