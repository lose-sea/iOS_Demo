//
//  WeatherController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "WeatherController.h"

@interface WeatherController ()
@property (nonatomic, strong) UIBarButtonItem* addButton;
@property (nonatomic, strong) UIBarButtonItem* backButton;
@property (nonatomic, strong) UIBarButtonItem* deleteButton;
@end

@implementation WeatherController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"weather 界面: %ld", self.weatherModel.CurrentWeatherModel.count);
    NSLog(@"%ld", self.weatherModel.DailyWeatherModel.count);
    NSLog(@"%ld", self.weatherModel.HourlyWeatherModel.count);
    if (!self.weatherModel.CurrentWeatherModel.count  || !self.weatherModel.DailyWeatherModel.count || !self.weatherModel.HourlyWeatherModel.count) {
        [self setUpData];
    }
    [self.weatherView.tableView reloadData];
    NSLog(@"降水  %@", self.weatherModel.CurrentWeatherModel[@"precipitation"]);
    [self setUpNavigation];
    [self setUpInterface];
}

- (void)configWithDict:(NSDictionary *)dict {
    NSLog(@"%@", dict);
    
    if (dict[@"current"] && dict[@"daily"] && dict[@"hourly"]) {
        self.weatherModel = [[WeatherModel alloc] init];
        self.weatherModel.CurrentWeatherModel = dict[@"current"];
        self.weatherModel.DailyWeatherModel = dict[@"daily"];
        self.weatherModel.HourlyWeatherModel = dict[@"hourly"];
    }
}

- (void) setUpData {
    
    NSLog(@"调用 setData");
    
    self.weatherModel = [[WeatherModel alloc] init];

    [self createURL];
}

- (void) setUpNavigation {
    
    NSLog(@"调用 setUpNavigation");

    self.backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    
    self.addButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"plus"] style: UIBarButtonItemStylePlain target: self action: @selector(pressAdd)];
    
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle: @"删除" style: UIBarButtonItemStylePlain target: self action: @selector(pressDelete)];
    
    
    self.navigationItem.leftBarButtonItem = self.backButton;
    
//    self.navigationItem.rightBarButtonItem = self.addButton;

    
    HomeModel* homeModel = [HomeModel shareInstance];
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        self.navigationItem.rightBarButtonItem = self.addButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.deleteButton;
    }
}

- (void) pressBack {
    NSLog(@"back");
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) pressAdd {
    HomeModel* homeModel = [HomeModel shareInstance];

    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        
        [self addCityToSave: self.city];
                
        self.navigationItem.rightBarButtonItem = self.deleteButton;

        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"添加成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName: ReleadNotification object: self userInfo: nil];
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"该城市已经添加收藏夹, 重复添加" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
}

- (void) pressDelete {
    HomeModel* homeModel = [HomeModel shareInstance];
    
    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }

    
    if ([homeModel.homeCities indexOfObject: self.city] != NSNotFound) {
        
        [self removeCityFormSave: self.city];
                
        self.navigationItem.rightBarButtonItem = self.addButton;
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"删除成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName: ReleadNotification object: self userInfo: nil];
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"删除失败, 未添加该城市" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
}




- (void) setUpInterface {

    NSLog(@"调用setUpInterface");
    self.weatherView = [[WeatherView alloc] init];

    // 删除所有的子视图
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.weatherModel.CurrentWeatherModel.count > 0 && self.weatherModel.HourlyWeatherModel.count > 0 && self.weatherModel.DailyWeatherModel.count > 0) {
        [self.view addSubview: self.weatherView];
        [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        self.weatherView.tableView.allowsSelection = NO; 
        
        self.weatherView.tableView.delegate = self;
        self.weatherView.tableView.dataSource = self;
        [self.weatherView configWithCurrentWeather: self.weatherModel.CurrentWeatherModel];

    } else {
        LoadView* loadView = [[LoadView alloc] init];
        [self.view addSubview: loadView];
        [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
}




- (void) addCityToSave: (CityModel*) city {
    HomeModel* homeModel = [HomeModel shareInstance];
    
    [homeModel.homeCities addObject: city];
    [homeModel.dicts addObject: @{}];
    [homeModel saveToUserDefaults];

}


- (void) removeCityFormSave: (CityModel*) city {
    HomeModel* homeModel = [HomeModel shareInstance];
    
    [homeModel.homeCities removeObject: city];
    [homeModel saveToUserDefaults];

}



- (void) createURL {
    NSLog(@"weather 发出了网络请求");
    [[NetworkManager sharedManager] GET: @"https://api.open-meteo.com/v1/forecast" parameters: @{
            @"latitude": @(self.city.latitude),
            @"longitude": @(self.city.longitude),
            @"daily" : @"temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,wind_speed_10m_max,wind_direction_10m_dominant,weather_code,uv_index_max",

                @"hourly" : @"temperature_2m,precipitation,snowfall,weather_code,wind_speed_10m,wind_direction_10m",

                @"current" : @"temperature_2m,is_day,precipitation,weather_code,wind_speed_10m,wind_direction_10m",

                @"timezone" : @"Europe/Moscow"
        }
                                 completion:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
            
       
        if (json[@"current"] && json[@"daily"] && json[@"hourly"]) {
            NSLog(@"请求到了数据");

            self.weatherModel.CurrentWeatherModel = json[@"current"];
            self.weatherModel.DailyWeatherModel = json[@"daily"];
            self.weatherModel.HourlyWeatherModel = json[@"hourly"];

            [self setUpInterface];
            [self.weatherView configWithCurrentWeather: self.weatherModel.CurrentWeatherModel];
            [self.weatherView.tableView reloadData];
            
        } else {
            NSLog(@"加载失败"); 
            NSLog(@"%@", error);
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"加载失败, 请检查网络" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pressBack];
            }];
            [alertController addAction: okAction];
            [self presentViewController: alertController animated: YES completion: nil];
        }
    }];
}




#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 3 || section == 4) {
        return 1;
    } else {
        return 7;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 70;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 300;
    } else if (indexPath.section == 1) {
        return 180;
    } else if (indexPath.section == 3) {
        return 200;
    } else if (indexPath.section == 2) {
        return 90;
    } else {
        return 100;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    return view;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return @"";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TemperatureCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TemperatureCellID" forIndexPath: indexPath];
        cell.nameLabel.text = self.city.cityName;
        [cell configWithCurrentWeather: self.weatherModel.CurrentWeatherModel dailyWeather: self.weatherModel.DailyWeatherModel];
        
        return cell;
    } else if (indexPath.section == 1) {
        ScrollHourCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ScrollHourCellID" forIndexPath: indexPath];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        [cell.collectionView reloadData];

        return cell;
    } else if (indexPath.section == 2) {
        DailyCell* cell = [tableView dequeueReusableCellWithIdentifier: @"DailyCellID" forIndexPath: indexPath];
        [cell configWithDailyWeather: self.weatherModel.DailyWeatherModel atIndex: indexPath.row];
        return cell;
    } else if (indexPath.section == 3) {
        PrecipitationWindCell* cell = [tableView dequeueReusableCellWithIdentifier: @"PrecipitationCellID" forIndexPath: indexPath];
        [cell configWithCurrentWeather: self.weatherModel.CurrentWeatherModel];
        return cell;
    } else {
        NoticeCell* cell = [tableView dequeueReusableCellWithIdentifier: @"NoticeCellID" forIndexPath: indexPath];
        return cell;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - UICollectionView
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HourlyCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HourlyCellID" forIndexPath: indexPath];
//    NSDictionary* hourDictionary = self.weatherModel.HourlyWeatherModel[@"hourly"];
    
//    NSLog(@"时间数组: %@", self.weatherModel.HourlyWeatherModel[@"time"]);
//    NSArray* times = self.weatherModel.HourlyWeatherModel[@"time"];
    
    NSString* originTime = self.weatherModel.CurrentWeatherModel[@"time"];
    NSMutableString* currentTime = [NSMutableString stringWithString: originTime];
    NSRange range = NSMakeRange(currentTime.length - 2,  2);
    [currentTime replaceCharactersInRange: range withString: @"00"];
//    NSLog(@"%@", currentTime);

    NSInteger currentIndex = [self.weatherModel.HourlyWeatherModel[@"time"] indexOfObject: currentTime];
    
    [cell configWithHourlyWeather: self.weatherModel.HourlyWeatherModel startIndex: currentIndex withIndex: indexPath.item];
    
    return cell;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
