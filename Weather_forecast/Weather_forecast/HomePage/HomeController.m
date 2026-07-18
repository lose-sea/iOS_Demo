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
    [self setUpNavigation];
    
}

- (void)setUpNavigation {
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
    
    
}

- (void)setUpInterface {
    
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
