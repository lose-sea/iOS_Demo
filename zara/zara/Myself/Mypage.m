//
//  Mypage.m
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import "Mypage.h"

@interface Mypage ()
@property (nonatomic, strong) UITableView* tableView;

// cell 的内容
@property (nonatomic, strong) NSMutableArray* textArray;
@property (nonatomic, strong) NSMutableArray* imageViews;

@end



static NSString* const AvatarNotification = @"AvatarNotification";

@implementation Mypage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的";
    // Do any additional setup after loading the view.
        
    // 设置数据源
    [self setDataSource];
    
    // 设置TabelView
    [self setTableView];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receiveAvatar:) name: @"AvatarNotification" object: nil];
    
}

// 接收消息
- (void) receiveAvatar: (NSNotification*) notification {
    UIImage* image = notification.userInfo[@"avatar"];
    self.avatar = image;
    [self.tableView reloadData];
    NSLog(@"我的界面收到通知");
}

- (void) setDataSource {
    self.textArray = [[NSMutableArray alloc] initWithObjects: @"服务", @"收藏", @"朋友圈", @"小店与卡包", @"表情", @"设置", nil];
    self.imageViews = [[NSMutableArray alloc] init];
    
    // 添加图片
    // 服务
    UIImage* image = [UIImage systemImageNamed: @"checkmark.message"];
//    image = [image imageWithTintColor: [UIColor greenColor]];
    UIImageView* iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor greenColor];
    [self.imageViews addObject: iView];
    
    iView.tintColor = [UIColor greenColor];
    
    
    // 收藏 (彩色方块)
    image = [UIImage systemImageNamed: @"cube"];
//    image = [image imageWithTintColor: [UIColor greenColor]];
    iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor redColor];
    [self.imageViews addObject: iView];
    
    
    
    
    // 朋友圈
    // 蓝色图片
    image = [UIImage systemImageNamed: @"photo"];
    iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor blueColor];
    [self.imageViews addObject: iView];
    
    
    // 小店与卡包 (红色购物袋)
    image = [UIImage systemImageNamed: @"bag"];
    iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor redColor];
    [self.imageViews addObject: iView];
    
    
    // 表情 (黄色笑脸)
    image = [UIImage systemImageNamed: @"face.smiling"];
    iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor yellowColor];
    [self.imageViews addObject: iView];
    
    
    // 设置 (蓝色齿轮)
    image = [UIImage systemImageNamed: @"gearshape"];
    iView = [[UIImageView alloc] initWithImage: image];
    iView.tintColor = [UIColor blueColor];
    [self.imageViews addObject: iView];
    
    
    self.avatar = [UIImage imageNamed: @"1.jpg"];
    
//    
//    iView.frame = CGRectMake(200, 200, 200, 200);
//    [self.view addSubview: iView];
    
}

- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(100);
        make.bottom.mas_equalTo(self.view).offset(-100);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    
    // 注册cell
//    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"cellID"];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else {
        return 1;
    }
}


// 配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"cellID" forIndexPath: indexPath];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"cellID"];
    }
    
    
//    cell.textLabel.text = @"主标题";
//    cell.detailTextLabel.text = @"副标题";
    
    // 设置内容
    if (indexPath.section == 2) {
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage systemImageNamed: @"gearshape"];
        cell.imageView.tintColor = [UIColor blueColor];
        cell.detailTextLabel.text = nil;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.textArray[indexPath.row];
        cell.imageView.image = ((UIImageView* )self.imageViews[indexPath.row]).image;
        if (indexPath.row == 0) {
            cell.imageView.tintColor = [UIColor greenColor];
        } else if (indexPath.row == 3) {
            cell.imageView.tintColor = [UIColor redColor];
        } else if (indexPath.row == 4) {
            cell.imageView.tintColor = [UIColor yellowColor];
        }
        cell.detailTextLabel.text = nil;
    } else {
        cell.textLabel.text = @"在下雨";
        cell.detailTextLabel.text = @"微信号: xtzytpl0508nrnd";
        cell.imageView.image = self.avatar;
        // 裁剪超出范围的部分
        cell.imageView.layer.masksToBounds = YES;
        // 裁剪
        cell.imageView.clipsToBounds = YES;
        // 填充
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    
    // 在cell的后面加一个 >
    // 样式: 点击查看详情指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

// 设置头标题高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 5;
    } else {
        return 0;
    }
}

// 设置头部标题
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        UIView* view = [[UIView alloc] init];
        return view;
    } else {
        return nil;
    }
}

// 设置选中行高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else {
        return 60;
    }
}

// 设置点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        Personal_Information* vc = [[Personal_Information alloc] init];
        vc.Nickname = [tableView cellForRowAtIndexPath: indexPath].textLabel.text;
        vc.account = [[tableView cellForRowAtIndexPath: indexPath].detailTextLabel.text substringFromIndex: 4] ;
        vc.avatar = [tableView cellForRowAtIndexPath: indexPath].imageView.image;
        
        [self.navigationController pushViewController: vc animated: YES]; 
    }
}

// 
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
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




















////
////  Mypage.m
////  zara
////
//
//#import "Mypage.h"
//
//@interface Mypage ()
//@property (nonatomic, strong) UITableView* tableView;
//
//// 分组数据源
//@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *sectionData;
//
//// 头像相关
//@property (nonatomic, strong) UIImageView *avatarImageView;
//@property (nonatomic, strong) UILabel *nicknameLabel;
//@property (nonatomic, strong) UILabel *wechatIdLabel;
//
//@end
//
//@implementation Mypage
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"我的";
//    
//    // 设置导航栏
//    [self setupNavigationBar];
//    
//    // 配置数据源
//    [self setupDataSource];
//    
//    // 设置表格视图
//    [self setupTableView];
//}
//
//- (void)setupNavigationBar {
//    // 设置导航栏背景色
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    
//    // 右侧相机按钮（可选）
//    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"camera"]
//                                                                     style:UIBarButtonItemStylePlain
//                                                                    target:self
//                                                                    action:@selector(cameraButtonTapped)];
//    self.navigationItem.rightBarButtonItem = cameraButton;
//}
//
//- (void)setupDataSource {
//    // 第一组：个人信息（使用自定义 header）
//    NSArray *group1 = @[
//        @{@"title": @"服务", @"icon": @"star", @"badge": @"4"},
//        @{@"title": @"收藏", @"icon": @"star", @"badge": @""}
//    ];
//    
//    // 第二组：常用功能
//    NSArray *group2 = @[
//        @{@"title": @"朋友圈", @"icon": @"person.2", @"badge": @""},
//        @{@"title": @"表情", @"icon": @"face.smiling", @"badge": @""},
//        @{@"title": @"卡包", @"icon": @"wallet.pass", @"badge": @""}
//    ];
//    
//    // 第三组：设置
//    NSArray *group3 = @[
//        @{@"title": @"设置", @"icon": @"gearshape", @"badge": @""}
//    ];
//    
//    self.sectionData = @[group1, group2, group3];
//}
//
//- (void)setupTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
//    [self.view addSubview:self.tableView];
//    
//    // 使用 Masonry 布局（如果使用的话）
//    // [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//    //     make.edges.mas_equalTo(self.view);
//    // }];
//    
//    // 或者使用 frame 布局
//    // self.tableView.frame = self.view.bounds;
//    
//    // 注册 cell
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sectionData.count + 1; // +1 是个人信息的 header
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0; // 第一行是自定义 header，不计入 rows
//    }
//    return self.sectionData[section - 1].count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    
//    // 清除旧内容
//    for (UIView *subview in cell.contentView.subviews) {
//        [subview removeFromSuperview];
//    }
//    
//    NSDictionary *item = self.sectionData[indexPath.section - 1][indexPath.row];
//    
//    // 设置图标
//    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 24, 24)];
//    iconView.image = [UIImage systemImageNamed:item[@"icon"]];
//    iconView.tintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
//    [cell.contentView addSubview:iconView];
//    
//    // 设置标题
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 200, 48)];
//    titleLabel.text = item[@"title"];
//    titleLabel.font = [UIFont systemFontOfSize:16];
//    [cell.contentView addSubview:titleLabel];
//    
//    // 设置红点/角标（如果有）
//    NSString *badge = item[@"badge"];
//    if (badge && badge.length > 0 && ![badge isEqualToString:@""]) {
//        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 12, 30, 24)];
//        badgeLabel.text = badge;
//        badgeLabel.font = [UIFont systemFontOfSize:14];
//        badgeLabel.textColor = [UIColor redColor];
//        badgeLabel.textAlignment = NSTextAlignmentCenter;
//        [cell.contentView addSubview:badgeLabel];
//    }
//    
//    // 添加箭头指示器
//    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 16, 14, 16)];
//    arrowView.image = [UIImage systemImageNamed:@"chevron.right"];
//    arrowView.tintColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//    [cell.contentView addSubview:arrowView];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
//    
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 48;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 100; // 个人信息 header 的高度
//    }
//    return 8;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01; // 最小高度，消除默认 footer
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        // 创建个人信息头部视图
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
//        headerView.backgroundColor = [UIColor whiteColor];
//        
//        // 头像
//        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 20, 60, 60)];
//        self.avatarImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
//        self.avatarImageView.tintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
//        self.avatarImageView.layer.cornerRadius = 30;
//        self.avatarImageView.clipsToBounds = YES;
//        [headerView addSubview:self.avatarImageView];
//        
//        // 昵称
//        self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 24, 200, 24)];
//        self.nicknameLabel.text = @"X.";
//        self.nicknameLabel.font = [UIFont boldSystemFontOfSize:20];
//        [headerView addSubview:self.nicknameLabel];
//        
//        // 微信号
//        self.wechatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 54, 250, 20)];
//        self.wechatIdLabel.text = @"微信号：xianan941691727";
//        self.wechatIdLabel.font = [UIFont systemFontOfSize:13];
//        self.wechatIdLabel.textColor = [UIColor grayColor];
//        [headerView addSubview:self.wechatIdLabel];
//        
//        // 二维码图标（右侧）
//        UIImageView *qrCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 35, 30, 30)];
//        qrCodeView.image = [UIImage systemImageNamed:@"qrcode"];
//        qrCodeView.tintColor = [UIColor grayColor];
//        [headerView addSubview:qrCodeView];
//        
//        // 添加点击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapped)];
//        [headerView addGestureRecognizer:tap];
//        
//        return headerView;
//    }
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 8)];
//    headerView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
//    return headerView;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSDictionary *item = self.sectionData[indexPath.section - 1][indexPath.row];
//    NSString *title = item[@"title"];
//    
//    // 点击响应
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
//                                                                   message:[NSString stringWithFormat:@"点击了%@", title]
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
//}
//
//#pragma mark - 事件响应
//
//- (void)profileTapped {
//    NSLog(@"点击了个人信息");
//    // 跳转到个人信息页面
//}
//
//- (void)cameraButtonTapped {
//    NSLog(@"相机按钮点击");
//    // 处理相机功能
//}
//
//@end
