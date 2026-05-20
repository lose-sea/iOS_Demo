//
//  HomepageController.m
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import "HomepageController.h"

@interface HomepageController ()

@end

@implementation HomepageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页"; 
    // Do any additional setup after loading the view.
    [self initData];
    
    
    [self setTableView];
}

- (void) initData {
    self.homeModel = [[HomepageModel alloc] init];
    self.homeModel.articles = [[NSMutableArray alloc] init];
    article* a = [[article alloc] initWitImage: [UIImage imageNamed: @"1.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a1 = [[article alloc] initWitImage: [UIImage imageNamed: @"1.jpg"] Name: @"假日" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a2 = [[article alloc] initWitImage: [UIImage imageNamed: @"2.jpg"] Name: @"国外画册欣赏" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a3 = [[article alloc] initWitImage: [UIImage imageNamed: @"3.jpg"] Name: @"体面" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a4 = [[article alloc] initWitImage: [UIImage imageNamed: @"4.jpg"] Name: @"还会记得我吗" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    article* a5 = [[article alloc] initWitImage: [UIImage imageNamed: @"5.jpg"] Name: @"庞锦荣是大帅哥" autoor: @"share小白" massage: @"这个家伙很懒, 什么也没有留下"];
    [self.homeModel.articles addObjectsFromArray: @[a, a1, a2, a3, a4, a5]];
}

- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor systemCyanColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 注册cel
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"CustomCellID"];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-60);
    }];
    
}
                         
                        
                         
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 150;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeModel.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"CustomCellID" forIndexPath: indexPath];
    
    article* article = self.homeModel.articles[indexPath.row];
    [cell setData: article];
    return cell;
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
