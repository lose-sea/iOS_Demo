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
            NSDictionary* current = dict[@"current"];
            
            NSLog(@"当前温度: %@", current[@"temperature_2m"]);
            
            NSLog(@"天气代码: %@", current[@"weather_code"]);
        });
    }];
    [task resume];
//     https:api.open-meteo.com/v1/forecast?latitude=39.907500&longitude=116.397230&current=temperature_2m,weather_code&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto
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
        return 200;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
//        cell.nameLabel.text = self.cityName; 
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
