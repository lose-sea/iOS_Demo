//
//  ChangePasswordController.m
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()

@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码"; 
    // Do any additional setup after loading the view.
    [self setUpData];
}

- (void) setUpData {
    self.changePasswordView = [[ChangePasswordView alloc] init];
    self.changePasswordModel = [[ChangePasswordModel alloc] init];
    
    [self.changePasswordModel.tags addObjectsFromArray: @[@"旧密码", @"新密码", @"确认密码"]];
    
    [self.view addSubview: self.changePasswordView];
    [self.changePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.changePasswordView.tableView.delegate = self;
    self.changePasswordView.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.changePasswordModel.tags.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangePasswordCell* cell = [tableView dequeueReusableCellWithIdentifier: @"ChangePasswordCellID" forIndexPath: indexPath];
    cell.tagLabel.text = self.changePasswordModel.tags[indexPath.row];
    
    
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
