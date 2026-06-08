//
//  MessageSettingController.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "MessageSettingController.h"

@interface MessageSettingController ()

@end

@implementation MessageSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息设置"; 
    // Do any additional setup after loading the view.
    [self setUpData];
    
}

- (void)setUpData {
    self.messageSettingModel = [[MessageSettingModel alloc] init];
    self.messageSettingView = [[MessageSettingView alloc] init];
    
    
    Message* a1 = [[Message alloc] initWithName: @"接受所有新消息通知"];
    Message* a2 = [[Message alloc] initWithName: @"通知显示栏"];
    Message* a3 = [[Message alloc] initWithName: @"声音"];
    Message* a4 = [[Message alloc] initWithName: @"震动"];
    Message* a5 = [[Message alloc] initWithName: @"关注更新"];
    [self.messageSettingModel.tags addObjectsFromArray: @[a1, a2, a3, a4, a5]];
    
    
    [self.view addSubview: self.messageSettingView];
    [self.messageSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.messageSettingView.tableView.delegate = self;
    self.messageSettingView.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageSettingModel.tags.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageSettingCell* cell = [tableView dequeueReusableCellWithIdentifier: @"MessageSettingCellID" forIndexPath: indexPath];
    Message* message = self.messageSettingModel.tags[indexPath.row];
    cell.message = message;
    [cell configWithMessage: message];
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
