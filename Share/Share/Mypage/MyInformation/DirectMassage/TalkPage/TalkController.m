//
//  TalkController.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkController.h"

@interface TalkController ()

@end

@implementation TalkController
//  在载入了聊天界面的时候隐藏tabBar
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"机智张";
    
    // Do any additional setup after loading the view.
}

- (void) setUpData {
    self.talkModel = [[TalkModel alloc] init];
    self.talkView = [[TalkView alloc] init];
    self.isMyself = NO;
    [self.view addSubview: self.talkView];
    [self.talkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.user = [[Follower alloc] initWithAvatar: [UIImage imageNamed: @"53.jpg"] nickName: @"share小张"]; 
    
    self.talkView.tableView.delegate = self;
    self.talkView.tableView.dataSource = self;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.talkModel.messagesOfMe.count + self.talkModel.messageOfOther.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    TalkCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TalkCellID" forIndexPath: indexPath];
    if (indexPath.row % 2 == 0) {
        cell.isMyself = NO;
        NSString* message = self.talkModel.messageOfOther[indexPath.row / 2];
        cell.user = self.other;
        [cell configWithFollower: cell.user Message: message isMyself: self.isMyself];
    } else {
        cell.isMyself = YES;
        NSString* message = self.talkModel.messagesOfMe[indexPath.row / 2];
        cell.user = self.user;
        [cell configWithFollower: cell.user Message: message isMyself: self.isMyself];
        
    }
    
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
