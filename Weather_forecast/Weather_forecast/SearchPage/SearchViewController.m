//
//  SeachController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "SearchViewController.h"

@interface SearchViewController ()
// 搜索框中的内容
@property (nonatomic, strong) NSString* searchText;

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
    
    [self setUpData];
    [self setUpInterface];
}

- (void) setUpData {
    self.searchModel = [[SearchModel alloc] init];
    self.searchView = [[SearchView alloc] init];
    
    
}


- (void)setUpInterface {
    [self.view addSubview: self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.searchView.tableView.delegate = self;
    self.searchView.tableView.dataSource = self;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchText = searchController.searchBar.text;
//    // 取消之前尚未执行的延迟调用
//       [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performSearch) object:nil];
       // 延迟 0.5 秒后执行实际搜索
       [self performSelector:@selector(performSearch) withObject:nil afterDelay:0.5];
}

- (void) performSearch {
    [self createURL];
}


- (void) createURL {
    NSString* inputText = self.searchText;
    
    [[NetworkManager sharedManager] GET: @"https://geocoding-api.open-meteo.com/v1/search" parameters: @{
            @"name": inputText,
            @"count": @10,
            @"language": @"zh",
            @"format": @"json"
        }
                                 completion:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
            if (!error && json) {
                NSArray* results = json[@"results"];
                [self.searchModel.cityArray removeAllObjects];
                if (results) {
                    [self.searchModel.cityArray addObjectsFromArray: results];
                }
                [self.searchView.tableView reloadData];
            }
        }];
}

#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchModel.cityArray.count;
//    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCellID" forIndexPath: indexPath];
    
    NSDictionary* cityInfo = self.searchModel.cityArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat: @"%@ -- %@", cityInfo[@"name"], cityInfo[@"admin1"]];
//    cell.textLabel.text = self.searchText;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSDictionary* cityInfo = self.searchModel.cityArray[indexPath.row];
    CGFloat latitude = [cityInfo[@"latitude"] doubleValue];
    CGFloat longitude = [cityInfo[@"longitude"] doubleValue];
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    
    NSLog(@"%@", cell.textLabel.text);
    NSLog(@"latitude: %lf", latitude);
    NSLog(@"longitude: %lf", longitude);
    
    WeatherController* vc = [[WeatherController alloc] init];
    vc.cityName = [NSString stringWithFormat: @"%@ -- %@", cityInfo[@"name"], cityInfo[@"admin1"]];
    vc.latitude = latitude;
    vc.longitude = longitude;
    [vc setUpData]; 
    UINavigationController* Nav = [[UINavigationController alloc] initWithRootViewController: vc];
    
    [self presentViewController: Nav animated: YES completion: nil];
}

//取消延迟调用，防止内存泄漏
- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
