//
//  HomeController.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "HomeController.h"
@interface HomeController ()

@end

@implementation HomeController      
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    

    
    // Do any additional setup after loading the view.
    
    [self setUpData];
    [self setUpNavigation];
}
- (void) setUpNavigation {
    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"text.justify"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
    self.navigationItem.leftBarButtonItem = menus;
}

// HomeController.m
- (void)pressMenuButton {
    NSLog(@"点击了菜单"); 
    UIViewController *root = self.view.window.rootViewController;
    if ([root isKindOfClass:[DrawerController class]]) {
        [(DrawerController *)root switchOpen];
    }
}
- (void)setUpData {
    self.homeModel = [[HomeModel alloc] init];
    for (int i = 20; i < 30; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.DailyRecommendImages addObject: image];
    }
    
    for (int i = 0; i < 13; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 11];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.RecommendSongListImages addObject: image];
    }
    
    for (int i = 0; i < 20; i++) {
        NSString* songCoverName = [NSString stringWithFormat: @"%d.jpg", i + 26];
        UIImage* songCover = [UIImage imageNamed: songCoverName];
        Song* song = [[Song alloc] initWithCover: songCover Name: @"我真的很爱你" Artist: @"林俊杰"];
        [self.homeModel.songs addObject: song];
    }
    
//    UIImageView* backView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"40.jpg"]];
//    [self.view addSubview: backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
    
    self.user = [[UserModel alloc] init];
    
    self.homeView = [[HomeView alloc] init];
    [self.view addSubview: self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.homeView.playView.song = self.user.song;
    [self.homeView.playView configWithSong: self.user.song];
    
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
}




#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
 
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; 
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 60;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 170;
    } else {
        return 300;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView* header = [[UIView alloc] init];
        UILabel* label = [[UILabel alloc] init];
        label.text = @"推荐歌单 >";
        label.font = [UIFont boldSystemFontOfSize: 20];
        [header addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(10);
            make.bottom.mas_equalTo(header);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        return header;
    } if (section == 2) {
        UIView* header = [[UIView alloc] init];
        UILabel* label = [[UILabel alloc] init];
        label.text = @"近期云村热播 >";
        label.font = [UIFont boldSystemFontOfSize: 20];
        [header addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(10);
            make.bottom.mas_equalTo(header);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        return header;
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        RecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecommendTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section;
        if (indexPath.section == 0) {
            [cell.collectionView registerClass: [DailyRecommendCell class] forCellWithReuseIdentifier: @"DailyRecommendCellID"];
            cell.collectionView.delegate = self;
            cell.collectionView.dataSource = self;
            return cell;
        } else {
            [cell.collectionView registerClass: [RecommendPlayListCell class] forCellWithReuseIdentifier: @"RecommendPlayListCellID"];
            cell.collectionView.delegate = self;
            cell.collectionView.dataSource = self;
            return cell;
        }
    } else {
        HotSongTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"HotSongTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section; 
        [cell.collectionView registerClass: [HotSongCell class] forCellWithReuseIdentifier: @"HotSongCellID"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - UICollectionView

// 找到 collectionView 对应的 tableViewCell
- (UITableViewCell*) findSuperViewOfCell: (UICollectionView*) collectionView {
    // 向上遍历，找到collectionView 对应的 RecommendTableViewCell
    UIView *superView = collectionView.superview;
    while (superView && ![superView isKindOfClass:[RecommendTableViewCell class]] && ![superView isKindOfClass: [HotSongTableViewCell class]]) {
        superView = superView.superview;
    }
    if ([superView isKindOfClass: [RecommendTableViewCell class]]) {
        return (RecommendTableViewCell*)superView;
    } else {
        return (HotSongTableViewCell*)superView;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RecommendTableViewCell* cell = [self findSuperViewOfCell: collectionView];
    if (cell.sectionType == 0) {
        return 6;
    } else if (cell.sectionType == 1) {
        return 7;
    }
    return 15; 
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendTableViewCell* view = [self findSuperViewOfCell: collectionView];
    if (view.sectionType == 0) {
        DailyRecommendCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"DailyRecommendCellID" forIndexPath: indexPath];
        cell.backgroundColor = [UIColor systemBlueColor];
        cell.tagLabel.text = @"每日推荐";
        cell.iView.image = self.homeModel.DailyRecommendImages[indexPath.item];
        cell.messageLabel.text = @"今晚星星很少, 思念很长";
        return cell;
    } else if (view.sectionType == 1) {
        RecommendPlayListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"RecommendPlayListCellID" forIndexPath: indexPath];
        cell.iView.image = self.homeModel.RecommendSongListImages[indexPath.item];
        cell.label.text = @" \"你在我心里是个很烂很烂的人\"";
        return cell;
    } else {
        HotSongCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HotSongCellID" forIndexPath: indexPath];
        Song* song = self.homeModel.songs[indexPath.item];
        cell.song = song;
        [cell configWithSong: song];
        
        [cell.playButton addTarget: self action: @selector(pressPlayButton:) forControlEvents: UIControlEventTouchUpInside];
        return cell;
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 只处理 UICollectionView
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    // 找到所在的 TableViewCell，只处理第三部分（近期云村热播）
    UITableViewCell *cell = [self findSuperViewOfCell:collectionView];
    if (![cell isKindOfClass:[HotSongTableViewCell class]]) return;
    HotSongTableViewCell *hotCell = (HotSongTableViewCell *)cell;
    if (hotCell.sectionType != 2) return;
    
    //  获取布局参数
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    if (![layout isKindOfClass:[UICollectionViewFlowLayout class]]) return;
    
    CGFloat itemWidth = layout.itemSize.width;          // 300
    CGFloat spacing = layout.minimumLineSpacing;       // 20
    CGFloat pageWidth = itemWidth + spacing;           // 320
    
    //  计算滚动范围
    CGFloat maxOffsetX = collectionView.contentSize.width - (self.view.bounds.size.width - itemWidth);

    if (maxOffsetX <= 0) return;
    
    CGFloat proposedX = targetContentOffset->x;
    CGFloat currentX = collectionView.contentOffset.x;
    
    //  计算建议的页面索引（四舍五入）
    NSInteger targetIndex = (NSInteger)(proposedX + pageWidth * 0.5 / pageWidth);
    
    
    // 7. 计算目标偏移量，并确保不超过最大滚动范围
    CGFloat targetX = targetIndex * pageWidth;
    
    if (targetX > maxOffsetX) {
        targetX = maxOffsetX;   // 关键：让最后一个 Cell 完整显示在左边
    }
    if (targetX < 0) targetX = 0;
    
    targetContentOffset->x = targetX;
}


- (void)pressPlayButton:(UIButton *)button {
    UIView *view = button.superview;
    while (view && ![view isKindOfClass:[HotSongCell class]]) {
        view = view.superview;
    }
    HotSongCell *cell = (HotSongCell *)view;
    if (cell) {
        cell.song.isPlay = !cell.song.isPlay; 
        NSLog(@"点击了歌曲：%@", cell.song.name);
        self.user.song = cell.song;
        self.homeView.playView.song = self.user.song;
        [self.homeView.playView configWithSong: self.user.song];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
