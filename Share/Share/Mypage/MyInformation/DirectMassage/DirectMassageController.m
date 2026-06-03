//
//  DirectMassageController.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "DirectMassageController.h"

@interface DirectMassageController ()

@end

@implementation DirectMassageController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私信";
    // Do any additional setup after loading the view.
    [self setUpData];
}


- (void) setUpData {
    self.directMassageModel = [[DirectMassageModel alloc] init];
    self.directMassageView  = [[DirectMassageView alloc] init];
    
    Follower* a1 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"44.jpg"] nickName: @"机智张"];
    Follower* a2 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"45.jpg"] nickName: @"机智淤"];
    Follower* a3 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"46.jpg"] nickName: @"机智李"];
    Follower* a4 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"47.jpg"] nickName: @"机智庞"];
    Follower* a5 = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"48.jpg"] nickName: @"机智王"];
    
    [self.directMassageModel.followers addObjectsFromArray: @[a1, a2, a3, a4, a5]];
    
    [self.view addSubview: self.directMassageView];
    [self.directMassageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.directMassageView.tableView.delegate = self;
    self.directMassageView.tableView.dataSource = self;
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.directMassageModel.followers.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectMassageCell* cell = [tableView dequeueReusableCellWithIdentifier: @"DirectMassageCellID" forIndexPath: indexPath];
    Follower* user = self.directMassageModel.followers[indexPath.row];
    cell.user = user;
    [cell configWithFollower: user];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    TalkCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    TalkController* vc = [[TalkController alloc] init];
    vc.other = cell.user;
    vc.title = cell.user.nickName;
    [self.navigationController pushViewController: vc animated: YES];
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
