//
//  MyInformationController.m
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import "MyInformationController.h"

@interface MyInformationController ()

@end

@implementation MyInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData]; 
}

- (void) setUpData {
    self.myImformationModel = [[MyImformationModel alloc] init];
    
    Information* a1 = [[Information alloc] initWithName: @"评论" count: 5];
    Information* a2 = [[Information alloc] initWithName: @"推荐我的" count: 4];
    Information* a3 = [[Information alloc] initWithName: @"新的关注" count: 6];
    Information* a4 = [[Information alloc] initWithName: @"私信" count: 4];
    Information* a5 = [[Information alloc] initWithName: @"活动通知" count: 9];
    [self.myImformationModel.massages addObjectsFromArray: @[a1, a2, a3, a4, a5]];
    
    self.myInformationView = [[MyInformationView alloc] init];
    [self.view addSubview: self.myInformationView];
    [self.myInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.myInformationView.tableView.delegate = self;
    self.myInformationView.tableView.dataSource = self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myImformationModel.massages.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImformationCell* cell = [tableView dequeueReusableCellWithIdentifier: @"InformationCell" forIndexPath: indexPath];
    
    // 在cell的后面加一个 >
    // 样式: 点击查看详情指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Information* information = self.myImformationModel.massages[indexPath.row];
    cell.information = information;
    [cell configWithInformation: information];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    ImformationCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.information.count = 0;
    [cell configWithInformation: cell.information];
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"目前没有新消息" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确定");
        }];
        [alertController addAction: okAction];
        
        [self presentViewController: alertController animated: YES completion: nil];
    } else if (indexPath.row == 2) {
        FollowerController* vc = [[FollowerController alloc] init];
        [self.navigationController pushViewController: vc animated: YES]; 
    } else if (indexPath.row == 3) {
        DirectMassageController* vc = [[DirectMassageController alloc] init];
        [self.navigationController pushViewController: vc animated: YES];
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
