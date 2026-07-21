//
//  HomeController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "HomeController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor systemCyanColor];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self createURLForCities];

    [self setUpNavigation];
    [self setUpInterface]; 
}

- (void) setUpData {
    self.homeModel = [[HomeModel alloc] init];
    self.homeView = [[HomeView alloc] init];
    
    NSDictionary* c1 = @{@"name": @"西安 -- 陕西", @"latitude": @34.258330, @"longitude": @108.928610};
    NSDictionary* c2 = @{@"name": @"北京 -- 北京市", @"latitude": @39.907500, @"longitude": @116.397230};
    NSDictionary* c3 = @{@"name": @"兰州 -- 甘肃", @"latitude": @36.057010, @"longitude": @103.839870};
    self.homeModel.saveCities = [NSMutableArray arrayWithArray:@[c1, c2, c3]];
    
    for (NSInteger i = 0; i < self.homeModel.saveCities.count; i++) {
        [self.homeModel.dicts addObject: @{}]; 
    }
    
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
}

- (void) createURLForCities {
    for (NSInteger i = 0; i < self.homeModel.saveCities.count; i++) {
        NSDictionary* dict = self.homeModel.saveCities[i];
        CGFloat latitude = [dict[@"latitude"] doubleValue];
        CGFloat longitude = [dict[@"longitude"] doubleValue];
        
        [self createURLWithlatitude: latitude longitude: longitude index: i];
    }
}

- (void) setUpInterface {
    [self.view addSubview: self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


- (void)setUpNavigation {
    
    // 开启大标题
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    // 控制显示规则
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    self.navigationItem.title = @"天气";
    
    // 创建菜单动作
    UIAction *addAction = [UIAction actionWithTitle:@"添加城市" image:[UIImage systemImageNamed:@"plus"] identifier:nil handler:^(UIAction *action) {
        // 激活搜索控制器
        [self.searchController setActive:YES];
    }];
    
    UIAction *refreshAction = [UIAction actionWithTitle:@"刷新所有天气" image:[UIImage systemImageNamed:@"arrow.clockwise"] identifier:nil handler:^(UIAction *action) {
        [self createURLForCities];
        [self.homeView.tableView reloadData];
    }];
    
    UIAction *clearAction = [UIAction actionWithTitle:@"清空收藏" image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(UIAction *action) {
        // 清空收藏夹
        [self.homeModel.saveCities removeAllObjects];
        [self.homeModel.dicts removeAllObjects];
        [self.homeView.tableView reloadData];
    }];
    
    UIMenu *menu = [UIMenu menuWithTitle:@"操作" children:@[addAction, refreshAction, clearAction]];
    
    // 创建按钮并设置菜单
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStylePlain target:nil action:nil];
    editButton.menu = menu;
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    SearchViewController* vc = [[SearchViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: vc];
    self.searchController.searchResultsUpdater = vc;
    // 模糊背景
    self.searchController.obscuresBackgroundDuringPresentation = YES;
    // 隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    // 占位文字
    self.searchController.searchBar.placeholder = @"输入城市名进行搜索";
    self.searchController.searchBar.delegate = self;
    // 将searchBar 添加到导航栏
    self.navigationItem.searchController = self.searchController;
    // 搜索成一个按钮,点击展开搜索栏
//    self.navigationItem.preferredSearchBarPlacement = UINavigationItemSearchBarPlacementIntegratedButton;
    self.searchController.delegate = self;
    
}


// 搜索界面被关闭时调用
- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"搜索界面关闭");
    [self createURLForCities];
    [self.homeView.tableView reloadData];
}



#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeModel.saveCities.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaveCell* cell = [tableView dequeueReusableCellWithIdentifier: @"SaveCellID" forIndexPath: indexPath];
//    [self createURLWithlatitude: [self.homeModel.saveCities[indexPath.row][@"latitude"] doubleValue] longitude: [self.homeModel.saveCities[indexPath.row][@"longitude"] doubleValue] index: indexPath.row];
    [cell configWithName: self.homeModel.saveCities[indexPath.row][@"name"] dict: self.homeModel.dicts[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    CityPageViewController* pageVC = [[CityPageViewController alloc]
                                      /*翻页的动画风格*/
                                      initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll
                                      navigationOrientation:
                                    /*页面的滑动方向*/
                                      UIPageViewControllerNavigationOrientationHorizontal
                                      options: nil];
    pageVC.cityList = self.homeModel.saveCities;
    pageVC.initialIndex = indexPath.row;
    
    // 使弹出的视图填充整个屏幕
    pageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UINavigationController* Nav = [[UINavigationController alloc] initWithRootViewController: pageVC];
    [self presentViewController: Nav animated: YES completion: nil];
}



- (void) createURLWithlatitude: (CGFloat) latitude longitude: (CGFloat) longitude index: (NSInteger) index {

    [[NetworkManager sharedManager] GET: @"https://api.open-meteo.com/v1/forecast" parameters: @{
        @"latitude": @(latitude),
        @"longitude": @(longitude),
        @"daily" : @"temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,wind_speed_10m_max,wind_direction_10m_dominant,weather_code,uv_index_max",

            @"hourly" : @"temperature_2m,precipitation,snowfall,weather_code,wind_speed_10m,wind_direction_10m",

            @"current" : @"temperature_2m,is_day,precipitation,weather_code,wind_speed_10m,wind_direction_10m",

            @"timezone" : @"Europe/Moscow"
    }
                             completion:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        if (!error && json) {
            self.homeModel.dicts[index] = json;
            [self.homeView.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation: UITableViewRowAnimationNone];
        }
    }];
}

@end
