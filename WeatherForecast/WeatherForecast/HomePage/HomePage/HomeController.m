//
//  HomeController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "HomeController.h"

@interface HomeController ()
@property (nonatomic, strong) UIBarButtonItem* finishButton;
@property (nonatomic, strong) UIBarButtonItem* editButton;
@property (nonatomic, strong) UIBarButtonItem* moreButton;

@property (nonatomic, assign) NSInteger pendingRequestCount;
@property (nonatomic, assign) NSInteger completedRequestCount;
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
    self.homeModel = [HomeModel shareInstance];
    self.homeView = [[HomeView alloc] init];
    
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
    
    // 注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:ReleadNotification object:nil];
}

- (void) reloadView {
    [self createURLForCities];
    [self.homeView.tableView reloadData];
}

- (void) createURLForCities {
    [[NetworkManager sharedManager] cancelAllRequests];
    self.homeModel = [HomeModel shareInstance];
    
    self.pendingRequestCount = self.homeModel.homeCities.count;
    self.completedRequestCount = 0;
    
    for (NSInteger i = 0; i < self.homeModel.homeCities.count; i++) {
        CityModel* city = self.homeModel.homeCities[i];
        
        [self createURLForCity: city];
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
        [self.homeModel.homeCities removeAllObjects];
        [self.homeModel saveToUserDefaults];
        [self.homeModel.dicts removeAllObjects];
        [self.homeView.tableView reloadData];
    }];
    
    UIAction *editAction = [UIAction actionWithTitle:@"编辑城市" image:[UIImage systemImageNamed:@"square.and.pencil"] identifier:nil handler:^(UIAction *action) {
        [self pressEdit];
    }];
    UIMenu *menu = [UIMenu menuWithTitle:@"操作" children:@[addAction, refreshAction, clearAction, editAction]];
    
    // 创建按钮并设置菜单
    self.moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.moreButton.menu = menu;
    

    self.editButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed:@"square.and.pencil"] style: UIBarButtonItemStylePlain target: self action: @selector(pressEdit)];
    
    self.navigationItem.rightBarButtonItems = @[self.moreButton, self.editButton];
     
    self.finishButton = [[UIBarButtonItem alloc] initWithTitle: @"完成" style: UIBarButtonItemStylePlain target: self action: @selector(pressFinish)];
}

- (void) pressEdit {
    self.navigationItem.rightBarButtonItems = @[self.finishButton];

    [self.homeView.tableView setEditing: YES animated: YES];
}

- (void) pressFinish {
    self.navigationItem.rightBarButtonItems = @[self.moreButton, self.editButton];
    [self.homeView.tableView setEditing: NO animated: YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.homeModel.homeCities removeObjectAtIndex: indexPath.row];
    [self.homeModel.dicts removeObjectAtIndex: indexPath.row];
    [self.homeModel saveToUserDefaults];

    [self.homeView.tableView reloadData];
}


// 搜索界面被关闭时调用
- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"搜索界面关闭");
    [self createURLForCities];
    [self.homeView.tableView reloadData];
}



#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeModel.homeCities.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SaveCell* cell = [tableView dequeueReusableCellWithIdentifier: @"SaveCellID" forIndexPath: indexPath];
    
    CityModel* city = self.homeModel.homeCities[indexPath.row];
    [cell configWithName: city.cityName dict: self.homeModel.dicts[indexPath.row]];
    
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
    pageVC.cityList = self.homeModel.homeCities;
    pageVC.initialIndex = indexPath.row;
    
    // 使弹出的视图填充整个屏幕
    pageVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UINavigationController* Nav = [[UINavigationController alloc] initWithRootViewController: pageVC];
    [self presentViewController: Nav animated: YES completion: nil];
}



- (void) createURLForCity: (CityModel*) city {
    

    [[NetworkManager sharedManager] GET: @"https://api.open-meteo.com/v1/forecast" parameters: @{
        @"latitude": @(city.latitude),
        @"longitude": @(city.longitude),
        @"daily" : @"temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,wind_speed_10m_max,wind_direction_10m_dominant,weather_code,uv_index_max",

            @"hourly" : @"temperature_2m,precipitation,snowfall,weather_code,wind_speed_10m,wind_direction_10m",

            @"current" : @"temperature_2m,is_day,precipitation,weather_code,wind_speed_10m,wind_direction_10m",

            @"timezone" : @"Europe/Moscow"
    }
                             completion:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        
        
        if (json[@"current"] && json[@"daily"] && json[@"hourly"]) {
            // 查找索引
            NSInteger index = [self.homeModel.homeCities indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [((CityModel*)(obj)).cityID isEqualToString: city.cityID];
            }];
            
            if (index != NSNotFound) {
                self.homeModel.dicts[index] = json;
                self.completedRequestCount++;

//                [self.homeView.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation: UITableViewRowAnimationNone];
            }
            if (self.completedRequestCount == self.pendingRequestCount) {
                [self.homeView.tableView reloadData];
            }
            
        } else {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"加载失败, 请检查网络" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction: okAction];
            [self presentViewController: alertController animated: YES completion: nil];
        }
    }];
}

@end
