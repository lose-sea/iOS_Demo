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
    
    [self.changePasswordView.commitButton addTarget: self action: @selector(pressCommit) forControlEvents: UIControlEventTouchUpInside];
}


- (void) pressCommit {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
    
    ChangePasswordCell* cell = [self.changePasswordView.tableView cellForRowAtIndexPath: indexPath];
    ChangePasswordCell* cell1 = [self.changePasswordView.tableView cellForRowAtIndexPath: indexPath1];
    ChangePasswordCell* cell2 = [self.changePasswordView.tableView cellForRowAtIndexPath: indexPath2];
    
    if (![cell.textField.text isEqualToString: self.changePasswordModel.user.password]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"旧密码输入错误" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else if (cell1.textField.text.length == 0) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"新密码不能为空" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else if (cell1.textField.text.length < 6 || cell1.textField.text.length > 10 || ![self isAlnum: cell1.textField.text]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"密码由6 - 10 位数字或字母组成" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else if (![cell1.textField.text isEqualToString: cell2.textField.text]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"两次输入密码不一致" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        self.changePasswordModel.user.password = cell2.textField.text;
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"密码修改成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
        
        [self.navigationController popViewControllerAnimated: YES]; 
    }
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
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.warnLabel.hidden = YES;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES]; 
}

- (BOOL) isAlnum: (NSString*) str {
    if (str.length == 0) {
        return YES;
    } else {
        for (int i = 0; i < str.length; i++) {
            unichar c = [str characterAtIndex: i];
            if (!isalnum(c)) {
                return NO;
            }
        }
        return YES;
    }
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
