//
//  ArticlesCategory.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ArticlesCategoryController.h"

@interface ArticlesCategoryController ()

@end

@implementation ArticlesCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemCyanColor];
    self.title = @"文章";
    // Do any additional setup after loading the view.
    
    [self setData];
//    [self setnavigation]; 
    [self setInterface];
}


- (void) setData {
    self.articleCategoryModel = [[ArticlesCategoryModel alloc] init];
    self.articleCategoryView = [[ArticlesCategoryView alloc] init];
    article* a1 = [[article alloc] initWitImage: [UIImage imageNamed: @"1.jpg"] Name: @"少年闰土" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a2 = [[article alloc] initWitImage: [UIImage imageNamed: @"2.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a3 = [[article alloc] initWitImage: [UIImage imageNamed: @"3.jpg"] Name: @"今天你好好学习了吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a4 = [[article alloc] initWitImage: [UIImage imageNamed: @"4.jpg"] Name: @"月亮与六便士" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a5 = [[article alloc] initWitImage: [UIImage imageNamed: @"5.jpg"] Name: @"我的同桌是学霸" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.articleCategoryModel.hotArticles addObjectsFromArray: @[a1, a2, a3, a4, a5]];
    
    
    article* b1 = [[article alloc] initWitImage: [UIImage imageNamed: @"11.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b2 = [[article alloc] initWitImage: [UIImage imageNamed: @"12.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b3 = [[article alloc] initWitImage: [UIImage imageNamed: @"13.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b4 = [[article alloc] initWitImage: [UIImage imageNamed: @"14.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b5 = [[article alloc] initWitImage: [UIImage imageNamed: @"15.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.articleCategoryModel.featuredArticles addObjectsFromArray: @[b1, b2, b3, b4, b5]];
    
    
    article* c1 = [[article alloc] initWitImage: [UIImage imageNamed: @"21.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c2 = [[article alloc] initWitImage: [UIImage imageNamed: @"22.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c3 = [[article alloc] initWitImage: [UIImage imageNamed: @"23.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c4 = [[article alloc] initWitImage: [UIImage imageNamed: @"24.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c5 = [[article alloc] initWitImage: [UIImage imageNamed: @"25.jpg"] Name: @"动物世界" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.articleCategoryModel.allArticles addObjectsFromArray: @[c1, c2, c3, c4, c5]];
}

- (void) setnavigation {
    self.navigationController.navigationBar.translucent = NO;
}

- (void) setInterface {
    [self.view addSubview: self.articleCategoryView];
    [self.articleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.articleCategoryView.featuredTableView.delegate = self;
    self.articleCategoryView.featuredTableView.dataSource = self;
    
    self.articleCategoryView.hotTableView.delegate = self;
    self.articleCategoryView.hotTableView.dataSource = self;
    
    self.articleCategoryView.allTableView.delegate = self;
    self.articleCategoryView.allTableView.dataSource = self;
    
    self.articleCategoryView.scrollView.delegate = self; 
    
    [self.articleCategoryView.segmentedControl addTarget: self action: @selector(segmentedControlChange) forControlEvents: UIControlEventValueChanged];
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleCategoryModel.allArticles.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TableViewCellID" forIndexPath: indexPath];
    if (tableView == self.articleCategoryView.featuredTableView) {
        article* article = self.articleCategoryModel.featuredArticles[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    } else if (tableView == self.articleCategoryView.hotTableView) {
        article* article = self.articleCategoryModel.hotArticles[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    } else {
        article* article = self.articleCategoryModel.allArticles[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    }
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    self.indexPath = indexPath;
//    self.selection = self.articleCategoryView.segmentedControl.selectedSegmentIndex;
    ArticlePageController* vc = [[ArticlePageController alloc] init];
    CustomCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.article.viewCount++;
    vc.title = cell.article.name;
    if (self.articleCategoryView.segmentedControl.selectedSegmentIndex == 0) {
        vc.article = self.articleCategoryModel.featuredArticles[indexPath.row];
    } else if (self.articleCategoryView.segmentedControl.selectedSegmentIndex == 1) {
        vc.article = self.articleCategoryModel.hotArticles[indexPath.row];
    } else {
        vc.article = self.articleCategoryModel.allArticles[indexPath.row];
    }
    
    vc.delegate = self;
    [self.navigationController pushViewController: vc animated: YES];
}


- (void) refreshArticle:(article *)article {
    if (self.articleCategoryView.segmentedControl.selectedSegmentIndex == 0) {
        self.articleCategoryModel.featuredArticles[self.indexPath.row] = article;
        [self.articleCategoryView.featuredTableView reloadData];
    } else if (self.articleCategoryView.segmentedControl.selectedSegmentIndex == 1) {
        self.articleCategoryModel.hotArticles[self.indexPath.row] = article;
        [self.articleCategoryView.hotTableView reloadData];
    } else {
        self.articleCategoryModel.allArticles[self.indexPath.row] = article; 
        [self.articleCategoryView.allTableView reloadData];;
    }
    
}

#pragma mark -scrollView
- (NSInteger) currentpage {
    NSInteger page = (self.articleCategoryView.scrollView.contentOffset.x + 0.5 * self.articleCategoryView.scrollView.bounds.size.width) / self.articleCategoryView.scrollView.bounds.size.width;
    return page;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = [self currentpage];
    self.articleCategoryView.segmentedControl.selectedSegmentIndex = page;
}

- (void) segmentedControlChange {
    NSInteger page = self.articleCategoryView.segmentedControl.selectedSegmentIndex;
    self.articleCategoryView.scrollView.contentOffset = CGPointMake(self.articleCategoryView.scrollView.bounds.size.width * page,  0);
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
