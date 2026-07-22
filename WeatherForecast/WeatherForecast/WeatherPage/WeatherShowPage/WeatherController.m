//
//  WeatherController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "WeatherController.h"

@interface WeatherController ()
@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIButton* backButton;
@end

@implementation WeatherController


- (void) viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    [self setUpInterface];
}

- (void) configWithDict:(NSDictionary *)dict {
    [self setUpData];
    self.weatherModel.HourlyWeatherModel = dict[@"hourly"];
    self.weatherModel.CurrentWeatherModel = dict[@"current"];
    self.weatherModel.DailyWeatherModel = dict[@"daily"];
}

- (void) setUpData {
    
    NSLog(@"调用 setData");
    
    self.weatherModel = [[WeatherModel alloc] init];
    
    [self createURL];
}

- (void) setUpNavigation {
    
    NSLog(@"调用 setUpNavigation");

    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    
    self.backButton.layer.cornerRadius = 20;
    self.backButton.clipsToBounds = YES;
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"plus"] style: UIBarButtonItemStylePlain target: self action: @selector(pressAdd)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    HomeModel* homeModel = [HomeModel shareInstance];
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        self.navigationItem.rightBarButtonItem = addButton;
    }
}

- (void) setUpInterface {
    self.weatherView = [[WeatherView alloc] init];

    if (self.weatherModel.CurrentWeatherModel.count > 0 && self.weatherModel.HourlyWeatherModel.count > 0 && self.weatherModel.DailyWeatherModel.count > 0) {
        [self.view addSubview: self.weatherView];
        [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        self.weatherView.tableView.delegate = self;
        self.weatherView.tableView.dataSource = self;
    } else {
        LoadView* loadView = [[LoadView alloc] init];
        [self.view addSubview: loadView];
        [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
}


- (void) pressBack {
    NSLog(@"back");
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) pressAdd {
    HomeModel* homeModel = [HomeModel shareInstance];
//    NSDictionary* dict = @{@"name": self.cityName, @"latitude": @(self.latitude), @"longitude": @(self.longitude)};
    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        
        [homeModel.homeCities addObject: self.city];
        [homeModel.dicts addObject: @{}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: ReleadNotification object: self userInfo: nil];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"添加成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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



- (void) createURL {
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
            self.weatherModel.CurrentWeatherModel = json[@"current"];
            self.weatherModel.DailyWeatherModel = json[@"daily"];
            self.weatherModel.HourlyWeatherModel = json[@"hourly"];

            [self setUpInterface];
            [self.weatherView configWithCurrentWeather: self.weatherModel.CurrentWeatherModel];
            [self.weatherView.tableView reloadData];
        } else {
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
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
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
    } else {
        return 90;
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    return view;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
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
    } else {
        DailyCell* cell = [tableView dequeueReusableCellWithIdentifier: @"DailyCellID" forIndexPath: indexPath];
        [cell configWithDailyWeather: self.weatherModel.DailyWeatherModel atIndex: indexPath.row];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
    
