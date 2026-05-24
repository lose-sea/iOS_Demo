//
//  SearchPageController.m
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import "SearchPageController.h"

@interface SearchPageController ()

@end

@implementation SearchPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self setData];
    
    [self setNavigationController];
    // Do any additional setup after loading the view.
}

- (void) setData {
    self.searchModel.categorys = @[@"平面设计", @"网页设计", @"UI", @"插画/手绘", @"虚拟与设计", @"影视", @"摄影", @"其他"];
    self.searchModel.recommends = @[@"人气最高", @"收藏最多", @"评论最多", @"编辑精选"];
    self.searchModel.timers = @[@"30分钟前", @"1小时前", @"1月前", @"1年前"];
}

// 设置导航栏
- (void) setNavigationController {
    
    // 添加上传按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"square.and.arrow.up"] style: UIBarButtonItemStylePlain target: self action: @selector(pressUpLoad)];
    self.navigationItem.rightBarButtonItem = item;
    
    // 添加 UISearchController
    self.searchController = [[UISearchController alloc] init];
    self.searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = self.searchController;
    
//    // 设置搜索结果代理
//    // 1. 创建 UISearchController，指定用于显示搜索结果的控制器，如果为 nil 则在当前控制器显示
//    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    searchController.searchResultsUpdater = self; // 设置搜索结果更新代理
//    searchController.obscuresBackgroundDuringPresentation = NO; // 搜索时是否模糊背景
    // 提示语
//    searchController.searchBar.placeholder = @"搜索";
    
//    self.navigationItem.searchController = searchController; // 添加到导航栏
}

- (void) pressUpLoad {
    NSLog(@"点击了上传按钮");
}

// 实现 UISearchController 代理方法
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString* searchText = searchController.searchBar.text;
    
    NSLog(@"点击了搜索框");
    // 在这里根据 searchText 过滤数据并刷新界面
//    [self.tableView reloadData];
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
