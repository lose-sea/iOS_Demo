//
//  FollowerController.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "FollowerController.h"

@interface FollowerController ()

@end

@implementation FollowerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的关注";
    
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
}

- (void)setUpData {
    self.followModel = [[FollowerModel alloc] init];
    self.followView = [[FollowerView alloc] init];
    
    Follower* a1 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"44.jpg"] nickName: @"机智张"];
    Follower* a2 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"45.jpg"] nickName: @"机智淤"];
    Follower* a3 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"46.jpg"] nickName: @"机智李"];
    Follower* a4 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"47.jpg"] nickName: @"机智庞"];
    Follower* a5 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"48.jpg"] nickName: @"机智王"];
    
    [self.followModel.followers addObjectsFromArray: @[a1, a2, a3, a4, a5]];
}

- (void) setUpInterface {
    [self.view addSubview: self.followView];
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
    }];
    self.followView.tableView.delegate = self;
    self.followView.tableView.dataSource = self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.followModel.followers.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FollowerCellCell* cell = [tableView dequeueReusableCellWithIdentifier: @"FollowCellID" forIndexPath: indexPath];
    Follower* follow = self.followModel.followers[indexPath.section];
    cell.avatarImageView.image = follow.avatar;
    cell.nickLabel.text = follow.nickName;
    cell.follower = follow;
    [cell configWithFollow: follow]; 
    
    return cell; 
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
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
