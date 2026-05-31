//
//  MyPageController.m
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import "MyPageController.h"

@interface MyPageController ()

@end

@implementation MyPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    // Do any additional setup after loading the view.
    [self setData];
}

- (void) setData {
    self.mypageModel = [[MyPageModel alloc] init];
    self.mypageView = [[MyPageView alloc] init];
    [self.view addSubview: self.mypageView];
    [self.mypageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    self.mypageView.tableView.delegate = self;
    self.mypageView.tableView.dataSource = self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 6;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    } else {
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserCell* cell = [tableView dequeueReusableCellWithIdentifier: @"UserCellID" forIndexPath: indexPath];
        [cell configWithUser: self.mypageModel];
//        [tableView reloadData]; 
        
        return cell;
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"UITableViewCellID" forIndexPath: indexPath];
        cell.accessoryView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"play.fill"]];
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage systemImageNamed: @"square.and.arrow.up.fill"];
            cell.textLabel.text = @"我上传的";
        } else if (indexPath.row == 1) {
            cell.imageView.image = [UIImage systemImageNamed: @"envelope.fill"];
            cell.textLabel.text = @"我的信息";
        } else if (indexPath.row == 2) {
            cell.imageView.image = [UIImage systemImageNamed: @"heart.fill"];
            cell.textLabel.text = @"我推荐的";
        } else if (indexPath.row == 3) {
            cell.imageView.image = [UIImage systemImageNamed: @"graduationcap.fill"];
            cell.textLabel.text = @"院系通知";
        } else if (indexPath.row == 4) {
            cell.imageView.image = [UIImage systemImageNamed: @"gearshape"];
            cell.textLabel.text = @"设置";
        } else {
            cell.imageView.image = [UIImage systemImageNamed: @"rectangle.portrait.and.arrow.right.fill"];
            cell.textLabel.text = @"退出";
        }
        return cell;
    }
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
