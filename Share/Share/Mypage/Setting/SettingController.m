//
//  SettingController.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view.
    [self setUpData]; 
    
}

- (void) setUpData {
    self.settingModel = [[SettingModel alloc] init];
    [self.settingModel.settings addObjectsFromArray: @[@"基本资料", @"修改密码", @"消息设置", @"关于share", @"清理缓存"]];
    
    self.settingView = [[SettingView alloc] init];
    [self.view addSubview: self.settingView];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.settingView.tableView.delegate = self;
    self.settingView.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingModel.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"SettingCellID" forIndexPath: indexPath];
    cell.textLabel.text = self.settingModel.settings[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (indexPath.row == 0) {
        
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
