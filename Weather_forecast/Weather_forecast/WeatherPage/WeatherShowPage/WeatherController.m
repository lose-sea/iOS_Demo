//
//  WeatherController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "WeatherController.h"

@interface WeatherController ()

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
    
    [self setUpData];
    [self setUpInterface];
    
}

- (void) setUpData {
    self.weatherModel = [[WeatherModel alloc] init];
    self.weatherView = [[WeatherView alloc] init];
    
    [self createURL];
}

- (void) setUpInterface {
    [self.view addSubview: self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.weatherView.tableView.delegate = self;
    self.weatherView.tableView.dataSource = self; 
    
    [self.weatherView.backButton addTarget: self action: @selector(pressBack) forControlEvents: UIControlEventTouchUpInside];
    
    
}



- (void) pressBack {
    [self dismissViewControllerAnimated: YES completion: nil];
}




- (void) createURL {
    NSString* urlString = [NSString stringWithFormat: @"https://api.open-meteo.com/v1/forecast?latitude=%f&longitude=%f&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto", self.latitude, self.longitude];
    
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
        NSLog(@"天气数据: %@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSDictionary* current = dict[@"current"];
            self.weatherModel.CurrentWeatherModel = dict[@"current"];
            self.weatherModel.DailyWeatherModel = dict[@"daily"];
            [self.weatherView.tableView reloadData];
        });
    }];
    [task resume];
//     https:api.open-meteo.com/v1/forecast?latitude=39.907500&longitude=116.397230&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto
}


- (NSString *)descriptionForWeatherCode:(NSInteger)code {
    // 0: 晴天
    if (code == 0) return @"晴";
    // 1,2,3: 多云
    if (code >= 1 && code <= 3) return @"多云";
    // 45,48: 雾
    if (code == 45 || code == 48) return @"雾";
    // 51,53,55: 毛毛雨
    if (code >= 51 && code <= 55) return @"毛毛雨";
    // 56,57: 冻毛毛雨
    if (code == 56 || code == 57) return @"冻毛毛雨";
    // 61,63,65: 雨
    if (code >= 61 && code <= 65) return @"雨";
    // 66,67: 冻雨
    if (code == 66 || code == 67) return @"冻雨";
    // 71,73,75: 雪
    if (code >= 71 && code <= 75) return @"雪";
    // 77: 雪粒
    if (code == 77) return @"雪粒";
    // 80,81,82: 阵雨
    if (code >= 80 && code <= 82) return @"阵雨";
    // 85,86: 阵雪
    if (code == 85 || code == 86) return @"阵雪";
    // 95,96,99: 雷暴
    if (code >= 95 && code <= 99) return @"雷暴";
    return @"未知天气";
}



#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    } 
    return 300;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    return view;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TemperatureCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TemperatureCellID" forIndexPath: indexPath];
        cell.nameLabel.text = self.cityName;
        [cell configWithCurrentWeather: self.weatherModel.CurrentWeatherModel dailyWeather: self.weatherModel.DailyWeatherModel];
        
        return cell;
    }
    return nil;
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
