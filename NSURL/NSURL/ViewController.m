//
//  ViewController.m
//  NSURL
//
//  Created by lose_sea on 2026/7/14.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemCyanColor];
    // Do any additional setup after loading the view.
    self.cityArray = [[NSMutableArray alloc] init];
    
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.frame = CGRectMake(50, 100, self.view.bounds.size.width - 100,  50);
    [self.view addSubview: self.textField];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.placeholder = @"输入城市名进行搜索";
    
    [self.textField addTarget: self action: @selector(textFieldDidChange:) forControlEvents: UIControlEventEditingChanged];
    
    [self creatTableView];
    
    
}

#pragma mark - UITextField
- (void) textFieldDidChange: (UITextField*) textField {
    if (textField.text.length == 0) {
        [self.cityArray removeAllObjects];
        [self.tableView reloadData];
        return; 
    }
    [self creatURL];
}




#pragma mark -UITableView
- (void) creatTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(200);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"UITableViewCellID"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCellID" forIndexPath: indexPath];
    NSDictionary* cityInfo = self.cityArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat: @"%@ -- %@", cityInfo[@"name"], cityInfo[@"admin1"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取选中的城市数据
    NSDictionary *cityInfo = self.cityArray[indexPath.row];
    NSString *cityName = cityInfo[@"name"];
    double latitude = [cityInfo[@"latitude"] doubleValue];
    double longitude = [cityInfo[@"longitude"] doubleValue];
    
    // 创建天气详情控制器
    WeatherController *weatherVC = [[WeatherController alloc] init];
    weatherVC.cityName = cityName;
    weatherVC.latitude = latitude;
    weatherVC.longitude = longitude;
    
    NSLog(@"%lf", latitude);
    NSLog(@"%lf", longitude); 
    
    // 跳转（使用导航控制器 push）
//    [self.navigationController pushViewController:weatherVC animated:YES];
}


#pragma mark - URL网络请求
- (void) creatURL {
    // 获取输入框的内容
    NSString* city = self.textField.text;
    if (city.length == 0) {
        return;
    }
    
    // 对字符串进行 URL 编码
    NSString* endcode = [city stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    // 拼接URL
    NSString* urlString = [NSString stringWithFormat: @"https://geocoding-api.open-meteo.com/v1/search?name=%@&count=10&language=zh&format=json", endcode];
    
    // 创建请求地址
    NSURL* url = [NSURL URLWithString: urlString];
    
    
    //    // 通过GET获取网络请求
    //    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL: url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        if (error) {
    //            NSLog(@"%@", error);
    //            return;
    //        }
    //        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
    //        NSArray* results = dict[@"results"];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.cityArray removeAllObjects];
    //            if (results) {
    //                [self.cityArray addObjectsFromArray: results];
    //            }
    //            [self.tableView reloadData];
    //        });
    //    }];
    
    // 创建Requset 请求类
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    
    // 设置HPPT请求方法
    request.HTTPMethod = @"GET";
    // 设置超时时间
    request.timeoutInterval = 15;
    
  
//    // 创建Session
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 创建会话
//    NSURLSession* session = [NSURLSession sessionWithConfiguration: config];
    
    NSURLSession* session = [NSURLSession sharedSession];
    
    
    // 创建Task
    NSURLSessionDataTask* task = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败: %@", error);
            return;
        }
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
        
        NSLog(@"%@", dict);
        
        NSArray* results = dict[@"results"];
        
        // 更新主线程 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityArray removeAllObjects];
            if (results) {
                [self.cityArray addObjectsFromArray: results];
            }
            [self.tableView reloadData];
        });
    }];
   

    [task resume];
}

//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath: indexPath animated: YES];
//    
//    // 点击cell后获取经纬度
//    NSDictionary* cityInfo = self.cityArray[indexPath.row];
//    
//    // 纬度
//    CGFloat latitude = [cityInfo[@"latitude"] doubleValue];
//    
//    // 经度
//    CGFloat longitude = [cityInfo[@"longitude"] doubleValue];
//    
//    NSLog(@"纬度:%f", latitude);
//    NSLog(@"经度:%f", longitude);
//    
//    [self requestWeatherWithLatitude:latitude
//                              longitude:longitude];
//}






- (void) requestWeatherWithLatitude: (double) latitude longitude: (double) longitude {
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
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
        NSLog(@"天气数据: %@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* current = dict[@"current"];
            
            NSLog(@"当前温度 :%@", current[@"temperature_2m"]);
            NSLog(@"天气代码: %@", current[@"weather_code"]);
        });
    }];
    [task resume];
}


@end
