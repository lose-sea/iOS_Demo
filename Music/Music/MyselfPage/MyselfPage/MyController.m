//
//  MyController.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "MyController.h"

@interface MyController ()

@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpNavigation];
    [self setUpSearchController];
    [self setUpInterface];
}

- (void)setUpData {
    self.myModel = [[MyModel alloc] init];
    self.myView = [[MyView alloc] init];
    
    SongList* s1 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"43.jpg"] Name: @"你的声音,身上的香味,瞳孔的深度,看我的眼睛,我都快忘了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s2 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"44.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s3 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"45.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s4 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"46.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s5 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"47.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s6 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"48.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s7 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"49.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s8 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"50.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    SongList* s9 = [[SongList alloc] initWithCover: [UIImage imageNamed: @"51.jpg"] Name: @"同学:,我们没有以后了" message: @"歌单 466首 先爱上的那个人,是输家"];
    
    [self.myModel.songLists addObjectsFromArray: @[s1, s2, s3, s4, s5, s6, s7, s8, s9]];
}

- (void)setUpInterface {
    [self.view addSubview: self.myView];
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.myView.tableView.delegate = self;
    self.myView.tableView.dataSource = self;
}

- (void) setUpNavigation {
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"text.justify"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"plus"] style: UIBarButtonItemStylePlain target: self action: @selector(pressAddButton)];
    
    UIBarButtonItem* moreButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"ellipsis"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMoreButton)];
    self.navigationItem.rightBarButtonItems = @[moreButton, addButton];
}

- (void)pressMenuButton {
    NSLog(@"点击了菜单");
    UIViewController *root = self.view.window.rootViewController;
    if ([root isKindOfClass:[DrawerController class]]) {
        [(DrawerController *)root switchOpen];
    }
}

- (void)pressAddButton {
    NSLog(@"点击了添加按钮");
}

-(void)pressMoreButton {
    NSLog(@"点击了更多按钮");
}

- (void)setUpSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
    
    self.searchController.searchBar.delegate = self;
    // 模糊背景
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    // 隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    // 添加到导航栏
    self.navigationItem.searchController = self.searchController;
    
    self.searchController.searchBar.placeholder = @"安河桥 宋冬野";
    
    // iOS 26 新增/调整的 API，尝试让搜索栏顶替标题位置
//    self.navigationItem.preferredSearchBarPlacement = UINavigationItemSearchBarPlacementIntegrated;
    
    // 搜索成一个按钮,点击展开搜索栏
    self.navigationItem.preferredSearchBarPlacement = UINavigationItemSearchBarPlacementIntegratedButton;
//    self.searchController.searchBar.hidden = YES;
}



#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 101) {
        return 9;
    } else if (tableView.tag == 102) {
        return 9;
    }
    return 1; 
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50; 
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 220;
    }
    return 500;
}



- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] init];
    [view addSubview: segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    [segmentedControl insertSegmentWithTitle: @"音乐" atIndex: 0 animated: YES];
    [segmentedControl insertSegmentWithTitle: @"播客" atIndex: 1 animated: YES];
    [segmentedControl insertSegmentWithTitle: @"笔记" atIndex: 2 animated: YES];
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectedSegmentTintColor = [[UIColor systemGrayColor]colorWithAlphaComponent: 0.4];
    if (section == 1) {
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myView.tableView) {
        if (indexPath.section == 0) {
            UserCell* cell = [tableView dequeueReusableCellWithIdentifier: @"UserCellID" forIndexPath: indexPath];
            cell.user = self.myModel.user;
            [cell configWithUser: self.myModel.user];
            return cell;
        } else {
            ScrollViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ScrollViewCellID" forIndexPath: indexPath];
            cell.musicTableView.delegate = self;
            cell.musicTableView.dataSource = self;
            cell.playTableView.delegate = self;
            cell.playTableView.dataSource = self;
            return cell;
        }
    } else if (tableView.tag == 101) {
        PlayListCell* cell = [tableView dequeueReusableCellWithIdentifier: @"MusicCellID" forIndexPath: indexPath];
        SongList* songList = self.myModel.songLists[indexPath.row];
        cell.songList = songList;
        [cell configWithSongList: songList];
        return cell;
    } else {
        PlayListCell* cell = [tableView dequeueReusableCellWithIdentifier: @"playTableCellID" forIndexPath: indexPath];
        SongList* songList = self.myModel.songLists[indexPath.row];
        cell.songList = songList;
        [cell configWithSongList: songList];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
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
