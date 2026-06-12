//
//  UploadByMyselfController.m
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import "UploadByMyselfController.h"

@interface UploadByMyselfController ()

@end

@implementation UploadByMyselfController



//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
//    [appearance configureWithOpaqueBackground];
//    appearance.titleTextAttributes = @{
//        NSForegroundColorAttributeName: [UIColor labelColor]
//    };
//    
//    self.navigationController.navigationBar.standardAppearance = appearance;
//    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我上传的";
    self.view.backgroundColor = [UIColor systemCyanColor]; 
    // 强制设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor labelColor]
    }];
//    self.view.backgroundColor = [UIColor systemCyanColor];
    // Do any additional setup after loading the view.
    
    [self setUpData];
    [self setUpInterface];
}


- (void) setUpData {
    self.upLoadModel = [[UploadByMyselfModel alloc] init] ;
    self.upLoadView = [[UploadByMyselfView alloc] init] ;
    
    
    article* a1 = [[article alloc] initWitImage: [UIImage imageNamed: @"11.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a2 = [[article alloc] initWitImage: [UIImage imageNamed: @"12.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a3 = [[article alloc] initWitImage: [UIImage imageNamed: @"13.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a4 = [[article alloc] initWitImage: [UIImage imageNamed: @"14.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a5 = [[article alloc] initWitImage: [UIImage imageNamed: @"15.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    
    [self.upLoadModel.articlesOfTime addObjectsFromArray: @[a1, a2, a3, a4, a5]];
    
    
    article* b1 = [[article alloc] initWitImage: [UIImage imageNamed: @"21.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b2 = [[article alloc] initWitImage: [UIImage imageNamed: @"22.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b3 = [[article alloc] initWitImage: [UIImage imageNamed: @"23.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b4 = [[article alloc] initWitImage: [UIImage imageNamed: @"24.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b5 = [[article alloc] initWitImage: [UIImage imageNamed: @"25.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    
    [self.upLoadModel.articlesOfRecommend addObjectsFromArray: @[b1, b2, b3, b4, b5]];
    
    article* c1 = [[article alloc] initWitImage: [UIImage imageNamed: @"11.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c2 = [[article alloc] initWitImage: [UIImage imageNamed: @"12.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c3 = [[article alloc] initWitImage: [UIImage imageNamed: @"13.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c4 = [[article alloc] initWitImage: [UIImage imageNamed: @"14.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* c5 = [[article alloc] initWitImage: [UIImage imageNamed: @"15.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    
    [self.upLoadModel.articlesOfShare addObjectsFromArray: @[c1, c2, c3, c4, c5]];
    
}

- (void) setUpInterface {
//    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview: self.upLoadView];
    [self.upLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.upLoadView.tableViewOfTime.delegate = self;
    self.upLoadView.tableViewOfTime.dataSource = self;
    self.upLoadView.tableViewOfRecommend.delegate = self;
    self.upLoadView.tableViewOfRecommend.dataSource = self;
    self.upLoadView.tableViewOfShare.delegate = self;
    self.upLoadView.tableViewOfShare.dataSource = self;
    
    self.upLoadView.scrollView.delegate = self;
    
    [self.upLoadView.segmentedControl addTarget: self action: @selector(segmentedControlChange) forControlEvents: UIControlEventValueChanged];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TableViewCellID" forIndexPath: indexPath];
    if (tableView == self.upLoadView.tableViewOfTime) {
        article* article = self.upLoadModel.articlesOfTime[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    } else if (tableView == self.upLoadView.tableViewOfRecommend) {
        article* article = self.upLoadModel.articlesOfRecommend[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    } else {
        article* article = self.upLoadModel.articlesOfShare[indexPath.row];
        cell.article = article;
        [cell configureWithArticle: article];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    self.indexPath = indexPath;
    CustomCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.article.viewCount++;
    ArticlePageController* vc = [[ArticlePageController alloc] init];
    vc.article = cell.article;
    vc.title = cell.article.name;
    vc.delegate = self;
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)refreshArticle:(article *)article {
    if (self.upLoadView.segmentedControl.selectedSegmentIndex == 0) {
        self.upLoadModel.articlesOfTime[self.indexPath.row] = article;
        [self.upLoadView.tableViewOfTime reloadData];
    } else if (self.upLoadView.segmentedControl.selectedSegmentIndex == 1) {
        self.upLoadModel.articlesOfRecommend[self.indexPath.row] = article;
        [self.upLoadView.tableViewOfRecommend reloadData];
    } else {
        self.upLoadModel.articlesOfShare[self.indexPath.row] = article;
        [self.upLoadView.tableViewOfShare reloadData];
    }
}

#pragma mark -scrollView

- (NSInteger) currentpage {
    NSInteger page = (self.upLoadView.scrollView.contentOffset.x + 0.5 * self.upLoadView.scrollView.bounds.size.width) / self.upLoadView.scrollView.bounds.size.width;
    return page;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = [self currentpage];
    self.upLoadView.segmentedControl.selectedSegmentIndex = page;
}

- (void) segmentedControlChange {
    NSInteger page = self.upLoadView.segmentedControl.selectedSegmentIndex;
    self.upLoadView.scrollView.contentOffset = CGPointMake(self.upLoadView.scrollView.bounds.size.width * page,  0); 
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
