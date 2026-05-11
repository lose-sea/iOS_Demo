//
//  Personal_Information.m
//  zara
//
//  Created by lose_sea on 2026/5/8.
//

#import "Personal_Information.h"

@interface Personal_Information ()


@property (nonatomic, strong) UITableView* tableView;


@end

static NSString* const AvatarNotification = @"AvatarNotification";

@implementation Personal_Information

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    [self setTableView];
    
    // 注册通知监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receiveAvatar:) name: AvatarNotification object: nil];

}

// 接收通知
- (void) receiveAvatar: (NSNotification*) notification {
    self.avatar = notification.userInfo[@"avatar"];
    [self.tableView reloadData];
    
    NSLog(@"接收到通知,更换头像"); 
}

- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(600);
    }];
    [self loadViewIfNeeded];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self; 
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"cellID"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        // cell右侧的自定义视图
        UIImageView* iView = [[UIImageView alloc] initWithImage: self.avatar];
        
        //  强制填充整个iView
        iView.contentMode = UIViewContentModeScaleAspectFill;
        // 裁剪超出的部分
        iView.clipsToBounds = YES;
        cell.accessoryView = iView;
        iView.frame = CGRectMake(0, 0, 40, 40);
        
        // 把头像变成圆形
        iView.layer.cornerRadius = 20;
        // 裁剪超出范围的部分
        iView.layer.masksToBounds = YES;
        
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.Nickname;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"账号";
        cell.detailTextLabel.text = self.account;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"个性签名";
        UILabel* label = [[UILabel alloc] init];
        label.text = @"这个家伙很懒, 什么也没有留下";
        label.frame = CGRectMake(0, 0, 150, cell.bounds.size.height - 10);
        // 自动调整字体大小
        label.adjustsFontSizeToFitWidth = YES;
        // 允许换行
        label.numberOfLines = 0;
        
        cell.accessoryView = label;
    }
    
    // 在cell的后面加一个 >
    // 样式: 点击查看详情指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (indexPath.row == 0) {
        AvatarShow* vc = [[AvatarShow alloc] init];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
        vc.avatar = ((UIImageView*)cell.accessoryView).image; 
        [self.navigationController pushViewController: vc animated: YES];
    }
}


// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
