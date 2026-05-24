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
    [self setHomepageView]; 
    
}

- (void) setHomepageView {
    self.homepageView = [[HomepageView alloc] init];
    [self.view addSubview: self.homepageView];
    self.homepageView.tableView.backgroundColor = [UIColor systemCyanColor]; 
    [self.homepageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.homepageView.tableView.delegate = self;
    self.homepageView.tableView.dataSource = self;
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
    
    
    self.homeModel.scrollImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 19];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.scrollImages addObject: image];
    }
    [self.homeModel.scrollImages addObject: [self.homeModel.scrollImages firstObject]];
    [self.homeModel.scrollImages insertObject: [self.homeModel.scrollImages objectAtIndex: self.homeModel.scrollImages.count - 2]  atIndex: 0];
    
}
                         
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200; 
    }
        return 150;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeModel.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ScrollViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"scrollViewCellID" forIndexPath: indexPath];
        cell.homeModel = self.homeModel; 
        [cell configureData: self.homeModel.scrollImages];
        return cell;
    }
    CustomCell* cell = [tableView dequeueReusableCellWithIdentifier: @"customCellID" forIndexPath: indexPath];
    article* article = self.homeModel.articles[indexPath.row];
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
