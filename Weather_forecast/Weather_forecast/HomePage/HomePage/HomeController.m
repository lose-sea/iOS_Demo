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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated]; 
    NSLog(@"appear");
//    [self.homeView.tableView reloadData];
//    [self setUpData];
//    [self createURLForCities];
//
//    [self setUpNavigation];
//    [self setUpInterface];
}

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
    
    
//    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"ellipsis"] style: UIBarButtonItemStylePlain target: self action: @selector(pressEdit)];
//    self.navigationItem.rightBarButtonItem = editButton;
//    editButton.menu = menu;
    
    
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

- (void) pressEdit {
    
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
    
    NSString* urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto", latitude, longitude];
        
    NSURL* url = [NSURL URLWithString: urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 15;
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData: data options:0 error: nil];
//        NSLog(@"天气数据: %@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.homeModel.dicts[index] = dict;
//            [self.homeModel.dicts removeAllObjects];
//            [self.homeModel.dicts addObject: dict];
            
            [self.homeView.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation: UITableViewRowAnimationNone];
        });
    }];
    [task resume];
}

@end
