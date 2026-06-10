//
//  SearchPageController.m
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import "SearchPageController.h"

@interface SearchPageController ()

@end

@implementation SearchPageController\

- (void) viewWillDisappear:(BOOL)animated {
    [self.view endEditing: YES]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view endEditing: YES]; 
    
//    self.view.backgroundColor = [UIColor systemCyanColor];
    
    self.title = @"搜索";
    [self setData];
    [self setNavigationController];
    [self setSearchController];
    [self setCollectionView];
    
    // Do any additional setup after loading the view.
}
// 设置数据
- (void) setData {
    self.searchModel = [[SearchPageModel alloc] init];
    self.searchPageView = [[SearchPageView alloc] init];
    self.searchModel.categorys = @[@"平面设计", @"网页设计", @"UI/icon", @"插画/手绘", @"虚拟与设计", @"影视", @"摄影", @"其他"];
    self.searchModel.recommends = @[@"人气最高", @"收藏最多", @"评论最多", @"编辑精选"];
    self.searchModel.timers = @[@"30分钟前", @"1小时前", @"1月前", @"1年前"];
    
    [self.searchModel.tags addObjectsFromArray: @[@"分类", @"推荐", @"时间"]]; 
}

// 设置导航栏
- (void) setNavigationController {
    
    // 添加上传按钮
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"square.and.arrow.up"] style: UIBarButtonItemStylePlain target: self action: @selector(pressUpLoad)];
    self.navigationItem.rightBarButtonItem = item;

}

- (void) pressUpLoad {
    NSLog(@"点击了上传按钮");
    UpLoadViewController* vc = [[UpLoadViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - searchController
- (void) setSearchController {
    // 创建搜索控制器，resultsController = nil 表示在当前视图上显示结果
    // 创建单独的controller来显示搜索结果
    
//    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController: [[searchResultShow alloc] init]];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
    
    
    searchController.searchResultsUpdater = self;               // 设置结果更新代理（必须）
    searchController.searchBar.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = YES; // 搜索时是否模糊背景（默认YES）
    searchController.hidesNavigationBarDuringPresentation = YES; // 搜索时是否隐藏导航栏（默认YES）
    searchController.searchBar.placeholder = @"搜索";            // 占位文字
//    searchController.searchBar.delegate = self;                 // 可选：监听搜索栏事件
    searchController.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchController = searchController;
    
    // 将 searchBar 添加到导航栏
    self.navigationItem.searchController = searchController;
     
    // 设置键盘样式
    self.searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    // 可选：滚动时保持 searchBar 在顶部
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
}


// 实现 UISearchController 代理方法
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString* searchText = searchController.searchBar.text;
    [self.view endEditing:YES];
    NSLog(@"点击了搜索框");
    // 在这里根据 searchText 过滤数据并刷新界面
//    [self.tableView reloadData];
}

// 点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    NSLog(@"搜索按钮被点击了！关键词：%@", searchBar.text);
    [searchBar resignFirstResponder];
    // 执行搜索逻辑
    // 跳转界面
    if ([searchBar.text containsString: @"大白"] || [searchBar.text containsString: @"dabai"]) {
        SearchResultShowController* vc = [[SearchResultShowController alloc] init];
        [self.navigationController pushViewController: vc animated: YES];
    } else {
        SearchNotFind* vc = [[SearchNotFind alloc] init];
        [self.navigationController pushViewController: vc animated: YES];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
//    [self.searchController resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"开始编辑");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"结束编辑");
}




#pragma mark - collectionView
- (void) setCollectionView {
    [self.view addSubview: self.searchPageView];
    [self.searchPageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
    }];
    self.searchPageView.collectionView.delegate = self;
    self.searchPageView.collectionView.dataSource = self;
}



#pragma mark - 配置collectionView的header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        NSLog(@"%@", self.searchModel.tags);
        
    
        
        UICollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier: @"SectionHeader" forIndexPath: indexPath];
        // 清空旧内容
        for (UIView *subview in header.subviews) {
            [subview removeFromSuperview];
        }
        UIImage* image = [UIImage systemImageNamed: @"tag.fill"];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        [header addSubview: iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(header).offset(5);
            make.centerY.mas_equalTo(header);
            make.left.mas_equalTo(header).offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        iView.backgroundColor = [UIColor systemCyanColor];
        
        UILabel* label = [[UILabel alloc] init];
        [header addSubview: label];
        label.text = self.searchModel.tags[indexPath.section];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(header).offset(5);
            make.centerY.mas_equalTo(header);
            make.left.mas_equalTo(iView.mas_right);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        label.backgroundColor = [UIColor systemCyanColor];
        label.textColor = [UIColor labelColor];
        
        UIView* line = [[UIView alloc] init];
        line.backgroundColor = [UIColor systemCyanColor];
        [header addSubview: line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom);
            make.left.mas_equalTo(iView);
            make.width.mas_equalTo(400);
            make.height.mas_equalTo(3);
        }];
            
        return header;
    }
    return nil; 
}

#pragma mark - collectionView 协议
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

//- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 6;
//}

//- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (section == 0 || section == 2 || section == 4) {
//        return 1;
//    } else if (section == 1) {
//        return 8;
//    } else {
//        return 4;
//    }
//}



- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    } else {
        return 4;
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    tagCollectionVIewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionViewCellID" forIndexPath: indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.label.text = self.searchModel.categorys[indexPath.item];
    } else if (indexPath.section == 1) {
        cell.label.text = self.searchModel.recommends[indexPath.item];
    } else if (indexPath.section == 2) {
        cell.label.text = self.searchModel.timers[indexPath.item];
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    tagCollectionVIewCell* cell = [collectionView cellForItemAtIndexPath: indexPath];
    if (cell.label.backgroundColor == [UIColor clearColor]) {
        cell.label.backgroundColor = [UIColor systemCyanColor];
        cell.label.textColor = [UIColor whiteColor];
    } else {
        cell.label.backgroundColor = [UIColor whiteColor];
        cell.label.textColor = [UIColor blackColor];
    }
    
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
