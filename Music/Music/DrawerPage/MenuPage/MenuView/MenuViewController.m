//
//  MenuController.m
//  Music
//
//  Created by lose_sea on 2026/6/15.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

//- (instancetype) init {
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self setUpInterface];
}

- (void)setUpData {
    self.menuModel = [[MenuModel alloc] init];
    
    self.menuModel.tagTitles = @[@"我的消息", @"我的云贝", @"装扮中心", @"创作者中心", @"最近播放", @"定时关闭", @"商城", @"夜间模式"];
    UIImage* a1 = [UIImage systemImageNamed: @"envelope"];
    UIImage* a2 = [UIImage systemImageNamed: @"cloud"];
    UIImage* a3 = [UIImage systemImageNamed: @"tshirt"];
    UIImage* a4 = [UIImage systemImageNamed: @"lightbulb.max.fill"];
    UIImage* a5 = [UIImage systemImageNamed: @"clock"];
    UIImage* a6 = [UIImage systemImageNamed: @"timer"];
    UIImage* a7 = [UIImage systemImageNamed: @"handbag"];
    UIImage* a8 = [UIImage systemImageNamed: @"moon"];
    self.menuModel.tagImages = @[a1, a2, a3, a4, a5, a6, a7, a8]; 
    
    
    self.menuView = [[MenuView alloc] init];
    
    [self.menuView configWithUser: self.menuModel.user];
    
    self.menuView.tableView.delegate = self;
    self.menuView.tableView.dataSource = self;
    
    self.mySwitch = [[UISwitch alloc] init];
    [self.mySwitch setOn: NO animated: YES];
}


- (void)setUpInterface {
    [self.view addSubview: self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



#pragma mark - UITableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuModel.tagImages.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell* cell = [tableView dequeueReusableCellWithIdentifier: @"MenuCellID" forIndexPath: indexPath];
    cell.tagView.image = self.menuModel.tagImages[indexPath.row];
    cell.tagLabel.text = self.menuModel.tagTitles[indexPath.row];
    if ([cell.tagLabel.text  isEqualToString: @"夜间模式"]) {
        cell.accessoryView = self.mySwitch;
        [self.mySwitch addTarget: self action: @selector(switchChange) forControlEvents: UIControlEventValueChanged];
    }
    
    return cell;
}

- (void) switchChange {
    if (self.mySwitch.on == YES) {
        self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    } else {
        self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
