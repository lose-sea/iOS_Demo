//
//  SearchResultShowController.m
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import "SearchResultShowController.h"

@interface SearchResultShowController ()

@end

@implementation SearchResultShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setData];
    [self.view addSubview: self.searchResultShowView];
    [self.searchResultShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
}

- (void) setData {
    self.searchPageModel = [[SearchPageModel alloc] init];
    self.searchResultShowView = [[SearchResultShowView alloc] init];
    self.searchResultShowView.tableView.delegate = self;
    self.searchResultShowView.tableView.dataSource = self;
    
    article* a1 = [[article alloc] initWitImage: [UIImage imageNamed: @"28.jpg"] Name: @"大白的山椒花" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a2 = [[article alloc] initWitImage: [UIImage imageNamed: @"29.jpg"] Name: @"大白与6便士 " autoor: @"share小吴" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.searchPageModel.articles addObjectsFromArray: @[a1, a2]];
}
 
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"customCellID" forIndexPath: indexPath];
    article* article = self.searchPageModel.articles[indexPath.row];
    cell.article = article; 
    [cell configureWithArticle: article];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
