//
//  MyRecommendController.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "MyRecommendController.h"

@interface MyRecommendController ()

@end

@implementation MyRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我推荐的";
    // Do any additional setup after loading the view.
    [self setUpData];
    
}

- (void) setUpData {
    self.myRecommendModel = [[MyRecommendModel alloc] init];
    
    article* b1 = [[article alloc] initWitImage: [UIImage imageNamed: @"11.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b2 = [[article alloc] initWitImage: [UIImage imageNamed: @"12.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b3 = [[article alloc] initWitImage: [UIImage imageNamed: @"13.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b4 = [[article alloc] initWitImage: [UIImage imageNamed: @"14.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* b5 = [[article alloc] initWitImage: [UIImage imageNamed: @"15.jpg"] Name: @"字体的故事" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.myRecommendModel.articles addObjectsFromArray: @[b1, b2, b3, b4, b5]];
    
    
    self.myRecommendView = [[MyRecommendView alloc] init];
    [self.view addSubview: self.myRecommendView];
    [self.myRecommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.myRecommendView.tableView.delegate = self;
    self.myRecommendView.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRecommendModel.articles.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ArticleCellID" forIndexPath: indexPath];
    article* article = [self.myRecommendModel.articles objectAtIndex: indexPath.row];
    cell.article = article;
    [cell configureWithArticle: article];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES]; 
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
