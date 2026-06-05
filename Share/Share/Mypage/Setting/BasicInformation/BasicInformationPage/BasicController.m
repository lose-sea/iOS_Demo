//
//  BasicController.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "BasicController.h"

@interface BasicController ()

@end

@implementation BasicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本资料";
    self.view.backgroundColor = [UIColor systemCyanColor]; 
    // Do any additional setup after loading the view.
    [self setUpData];
}

- (void) setUpData {
    self.basicView = [[BasicView alloc] init];
    self.basicModel = [[BasicModel alloc] init];
    self.user = [[UserModel alloc] init];
    
    [self.basicModel.tags addObjectsFromArray: @[@"头像", @"昵称", @"签名", @"性别", @"邮箱"]];
    
    [self.view addSubview: self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.basicView.tableView.delegate = self;
    self.basicView.tableView.dataSource = self;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AvatarCell* cell = [tableView dequeueReusableCellWithIdentifier: @"AvatarCellID" forIndexPath: indexPath];
        cell.user = self.user;
        [cell configWithUser: self.user];
        return cell;
    } else if (indexPath.row == 3) {
        GenderCell* cell = [tableView dequeueReusableCellWithIdentifier: @"GenderCellID" forIndexPath: indexPath];
        cell.user = self.user;
        
        [cell.maleButton addTarget: self action: @selector(pressMaleButton:) forControlEvents: UIControlEventTouchUpInside];
        [cell.femaleButton addTarget: self action: @selector(pressFeMaleButton:) forControlEvents: UIControlEventTouchUpInside];
        return cell;
    } else {
        TextCell* cell = [tableView dequeueReusableCellWithIdentifier: @"TextCellID" forIndexPath: indexPath];
        cell.tagLabel.text = self.basicModel.tags[indexPath.row];
        cell.user  = self.user;
        if (indexPath.row == 1) {
            [cell configWithUser: self.user.nickName];
        } else if (indexPath.row == 2) {
            [cell configWithUser: self.user.signature];
        } else {
            [cell configWithUser: self.user.email];
        }
        return cell; 
    }
}

- (void) pressMaleButton: (UIButton*) sender {
    self.user.gender = @"男";
    //找到按钮的父视图 (cell)
    GenderCell *cell = (GenderCell *)[[sender superview] superview];
    [cell configWithUser: self.user];
}

- (void) pressFeMaleButton: (UIButton*) sender {
    self.user.gender = @"女";
    GenderCell *cell = (GenderCell *)[[sender superview] superview];
    [cell configWithUser: self.user];
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
