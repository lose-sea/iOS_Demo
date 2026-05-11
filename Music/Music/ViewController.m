//
//  ViewController.m
//  NetEaseMusicDemo
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    // 初始化数据
    [self initData];
    
    // 设置导航栏
    [self setupNavigationBar];
    
    // 设置主滚动视图
    [self setupScrollView];
    
    // 添加各个模块
    [self setupBannerView];
    [self setupFunctionButtons];
    [self setupRecommendTitle];
    [self setupRecommendPlaylists];
    [self setupHotSongsTitle];
    [self setupHotSongs];
}

#pragma mark - 初始化数据
- (void)initData {
    // 轮播图数据
    self.bannerImages = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [self.bannerImages addObject:image];
        } else {
            // 如果没有图片，用颜色代替
            [self.bannerImages addObject:[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]];
        }
    }
    
    // 推荐歌单数据
    self.recommendPlaylists = [[NSMutableArray alloc] init];
    NSArray *playlistNames = @[@"华语流行", @"欧美精选", @"电音派对", @"民谣故事", @"说唱时代", @"摇滚经典", @"古风雅韵", @"纯音乐"];
    NSArray *playlistCounts = @[@"50首", @"38首", @"65首", @"42首", @"55首", @"48首", @"32首", @"78首"];
    for (int i = 0; i < playlistNames.count; i++) {
        NSDictionary *playlist = @{
            @"name": playlistNames[i],
            @"count": playlistCounts[i],
            @"image": [NSString stringWithFormat:@"playlist%d", i+1]
        };
        [self.recommendPlaylists addObject:playlist];
    }
    
    // 热门歌曲数据
    self.hotSongs = [[NSMutableArray alloc] init];
    NSArray *songNames = @[@"孤勇者", @"稻香", @"夜曲", @"告白气球", @"演员", @"消愁", @"平凡之路", @"年少有为", @"无人之岛", @"起风了"];
    NSArray *artistNames = @[@"陈奕迅", @"周杰伦", @"周杰伦", @"周杰伦", @"薛之谦", @"毛不易", @"朴树", @"李荣浩", @"任然", @"买辣椒也用券"];
    for (int i = 0; i < songNames.count; i++) {
        NSDictionary *song = @{
            @"name": songNames[i],
            @"artist": artistNames[i]
        };
        [self.hotSongs addObject:song];
    }
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    // 使用外观API设置导航栏
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        // 背景不透明
        [appearance configureWithOpaqueBackground];
        
        // 设置导航栏是否透明
        // 使视图从导航栏的下方开始, 不会被导航栏遮蔽
//        self.navigationController.navigationBar.translucent = NO;
        
        // 使用白色背景
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor blackColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
        };
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor blackColor],
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18]
        };
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"网易云音乐";
    
    // 设置左侧菜单按钮
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage systemImageNamed:@"line.horizontal.3"] forState:UIControlStateNormal];
    menuButton.tintColor = [UIColor blackColor];
    menuButton.frame = CGRectMake(0, 0, 30, 30);
    [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    // 设置右侧搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    searchButton.tintColor = [UIColor blackColor];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton addTarget:self action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark - 设置滚动视图
- (void)setupScrollView {
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.mainScrollView.showsVerticalScrollIndicator = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.bounces = YES;
    self.mainScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.mainScrollView];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.mainScrollView addSubview:self.contentView];
}

#pragma mark - 设置轮播图
- (void)setupBannerView {
    if (self.bannerImages.count == 0) return;
    
    CGFloat bannerHeight = 180;
    UIScrollView *bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, bannerHeight)];
    bannerScrollView.pagingEnabled = YES;
    bannerScrollView.showsHorizontalScrollIndicator = NO;
    bannerScrollView.bounces = NO;
    bannerScrollView.delegate = self;
    bannerScrollView.tag = 100;
    [self.contentView addSubview:bannerScrollView];
    
    // 添加轮播图片
    for (int i = 0; i < self.bannerImages.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.bounds.size.width, 0, self.view.bounds.size.width, bannerHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        id obj = self.bannerImages[i];
        if ([obj isKindOfClass:[UIImage class]]) {
            imageView.image = (UIImage *)obj;
        } else {
            imageView.backgroundColor = (UIColor *)obj;
        }
        
        [bannerScrollView addSubview:imageView];
    }
    
    bannerScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.bannerImages.count, bannerHeight);
    
    // 添加页面控制器
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.bannerImages.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.tag = 101;
    [self.contentView addSubview:pageControl];
    
    pageControl.frame = CGRectMake(0, bannerHeight - 30, self.view.bounds.size.width, 30);
}

#pragma mark - 设置功能按钮
- (void)setupFunctionButtons {
    CGFloat buttonWidth = 60;
    CGFloat buttonHeight = 70;
    CGFloat spacing = (self.view.bounds.size.width - 4 * buttonWidth) / 5;
    
    NSArray *titles = @[@"每日推荐", @"私人FM", @"MV", @"朋友"];
    NSArray *icons = @[@"calendar.circle.fill", @"radio", @"video.circle.fill", @"person.2.fill"];
    
    CGFloat startY = 190;  // 轮播图下方
    
    for (int i = 0; i < titles.count; i++) {
        CGFloat x = spacing + i * (buttonWidth + spacing);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, startY, buttonWidth, buttonHeight)];
        button.tag = i;
        [button addTarget:self action:@selector(functionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        // 图标
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((buttonWidth-40)/2, 0, 40, 40)];
        iconView.image = [UIImage systemImageNamed:icons[i]];
        iconView.tintColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:1.0];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:iconView];
        
        // 文字
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, buttonWidth, 20)];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor darkGrayColor];
        [button addSubview:titleLabel];
        
        [self.contentView addSubview:button];
    }
}

#pragma mark - 设置推荐歌单标题
- (void)setupRecommendTitle {
    CGFloat startY = 270;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, startY, self.view.bounds.size.width - 30, 30)];
    [self.contentView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.text = @"推荐歌单";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    [titleView addSubview:titleLabel];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(titleView.bounds.size.width - 60, 0, 60, 30);
    [moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:moreButton];
}

#pragma mark - 设置推荐歌单CollectionView
- (void)setupRecommendPlaylists {
    CGFloat startY = 310;
    CGFloat itemWidth = (self.view.bounds.size.width - 45) / 3;
    CGFloat itemHeight = itemWidth + 30;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, startY, self.view.bounds.size.width, itemHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.tag = 200;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PlaylistCell"];
    [self.contentView addSubview:collectionView];
}

#pragma mark - 设置热门歌曲标题
- (void)setupHotSongsTitle {
    CGFloat startY = 490;  // 310 + 150 + 30（collectionView高度150，间距30）
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(15, startY, self.view.bounds.size.width - 30, 30)];
    [self.contentView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.text = @"热门歌曲";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor blackColor];
    [titleView addSubview:titleLabel];
}

#pragma mark - 设置热门歌曲列表
- (void)setupHotSongs {
    CGFloat startY = 530;  // 标题下方
    CGFloat cellHeight = 60;
    
    for (int i = 0; i < self.hotSongs.count; i++) {
        NSDictionary *song = self.hotSongs[i];
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(15, startY + i * cellHeight, self.view.bounds.size.width - 30, cellHeight)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.cornerRadius = 8;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        cell.layer.shadowOpacity = 0.05;
        cell.layer.shadowRadius = 2;
        cell.tag = i;
        
        // 添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [cell addGestureRecognizer:tap];
        
        [self.contentView addSubview:cell];
        
        // 序号
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 30, cellHeight)];
        indexLabel.text = [NSString stringWithFormat:@"%d", i + 1];
        indexLabel.font = [UIFont boldSystemFontOfSize:16];
        indexLabel.textColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:1.0];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:indexLabel];
        
        // 歌曲名
        UILabel *songLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 180, 25)];
        songLabel.text = song[@"name"];
        songLabel.font = [UIFont boldSystemFontOfSize:15];
        songLabel.textColor = [UIColor blackColor];
        [cell addSubview:songLabel];
        
        // 歌手名
        UILabel *artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 35, 180, 18)];
        artistLabel.text = song[@"artist"];
        artistLabel.font = [UIFont systemFontOfSize:12];
        artistLabel.textColor = [UIColor lightGrayColor];
        [cell addSubview:artistLabel];
        
        // 播放按钮
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(cell.bounds.size.width - 40, (cellHeight - 30)/2, 30, 30);
        [playButton setImage:[UIImage systemImageNamed:@"play.circle"] forState:UIControlStateNormal];
        playButton.tintColor = [UIColor lightGrayColor];
        playButton.tag = i;
        [playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:playButton];
        
        // 添加分割线
        if (i < self.hotSongs.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(55, cellHeight - 0.5, cell.bounds.size.width - 95, 0.5)];
            line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
            [cell addSubview:line];
        }
    }
    
    // 关键：设置contentSize，使用正确的高度计算
    CGFloat totalHeight = 530 + self.hotSongs.count * 60 + 50;  // 530起始Y + 歌曲总高度 + 底部留白50
    self.contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, totalHeight);
    self.mainScrollView.contentSize = self.contentView.frame.size;
    
    NSLog(@"滚动视图内容高度: %.0f", totalHeight);
    NSLog(@"contentView高度: %.0f", self.contentView.frame.size.height);
    NSLog(@"scrollView contentSize: %@", NSStringFromCGSize(self.mainScrollView.contentSize));
}

#pragma mark - UIScrollViewDelegate (轮播图)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger currentPage = round(offsetX / scrollView.bounds.size.width);
        UIPageControl *pageControl = [self.contentView viewWithTag:101];
        if (pageControl) {
            pageControl.currentPage = currentPage;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 200) {
        return self.recommendPlaylists.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaylistCell" forIndexPath:indexPath];
        
        // 清除旧视图
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        NSDictionary *playlist = self.recommendPlaylists[indexPath.item];
        CGFloat itemWidth = cell.contentView.bounds.size.width;
        
        // 封面图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
        
        // 播放数量背景
        UIView *countBg = [[UIView alloc] initWithFrame:CGRectMake(itemWidth - 55, 5, 50, 20)];
        countBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        countBg.layer.cornerRadius = 10;
        [imageView addSubview:countBg];
        
        // 耳机图标
        UIImageView *headphoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 16, 16)];
        headphoneIcon.image = [UIImage systemImageNamed:@"headphones"];
        headphoneIcon.tintColor = [UIColor whiteColor];
        [countBg addSubview:headphoneIcon];
        
        // 数量标签
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 2, 25, 16)];
        countLabel.text = playlist[@"count"];
        countLabel.font = [UIFont systemFontOfSize:10];
        countLabel.textColor = [UIColor whiteColor];
        [countBg addSubview:countLabel];
        
        // 歌单名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, itemWidth + 5, itemWidth, 20)];
        nameLabel.text = playlist[@"name"];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:nameLabel];
        
        return cell;
    }
    
    return [[UICollectionViewCell alloc] init];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 200) {
        NSDictionary *playlist = self.recommendPlaylists[indexPath.item];
        NSLog(@"点击了歌单：%@", playlist[@"name"]);
        [self showAlertWithMessage:[NSString stringWithFormat:@"打开歌单：%@", playlist[@"name"]]];
    }
}

#pragma mark - 按钮点击事件
- (void)menuButtonTapped {
    NSLog(@"点击了菜单按钮");
    [self showAlertWithMessage:@"菜单"];
}

- (void)searchButtonTapped {
    NSLog(@"点击了搜索按钮");
    [self showAlertWithMessage:@"搜索"];
}

- (void)functionButtonTapped:(UIButton *)sender {
    NSArray *titles = @[@"每日推荐", @"私人FM", @"MV", @"朋友"];
    NSLog(@"点击了：%@", titles[sender.tag]);
    [self showAlertWithMessage:[NSString stringWithFormat:@"打开：%@", titles[sender.tag]]];
}

- (void)moreButtonTapped {
    NSLog(@"点击了更多");
    [self showAlertWithMessage:@"更多歌单"];
}

- (void)playButtonTapped:(UIButton *)sender {
    NSDictionary *song = self.hotSongs[sender.tag];
    NSLog(@"播放歌曲：%@ - %@", song[@"artist"], song[@"name"]);
    [self showAlertWithMessage:[NSString stringWithFormat:@"播放：%@ - %@", song[@"artist"], song[@"name"]]];
}

- (void)cellTapped:(UITapGestureRecognizer *)gesture {
    UIView *cell = gesture.view;
    NSDictionary *song = self.hotSongs[cell.tag];
    NSLog(@"点击了歌曲：%@ - %@", song[@"artist"], song[@"name"]);
    [self showAlertWithMessage:[NSString stringWithFormat:@"查看详情：%@ - %@", song[@"artist"], song[@"name"]]];
}

#pragma mark - 辅助方法
- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
