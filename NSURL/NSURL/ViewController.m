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
    cell.textLabel.text = cityInfo[@"name"];
    
    return cell;
}


#pragma mark - URL网络请求
- (void) creatURL {
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
    
    // 创建Requset 请求类
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    // 设置HPPT请求方法
    request.HTTPMethod = @"GET";
    // 设置超时时间
    request.timeoutInterval = 15;
    
    // 创建Session
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 创建会话
    NSURLSession* session = [NSURLSession sessionWithConfiguration: config];
    
    // 创建Task
    NSURLSessionDataTask* task = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败: %@", error);
        }
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: nil];
        NSLog(@"%@", dict);
        
        NSArray* results = dict[@"results"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cityArray removeAllObjects];
            if (results) {
                [self.cityArray addObjectsFromArray: results];
            }
            [self.tableView reloadData];
        });
    }];

    
    
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
    
    [task resume];
}



@end
