//
//  MenuViewControler.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "MenuViewController.h"
#import "DrawerViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    // Do any additional setup after loading the view.
    
//    [self setUpNavigation];
    
    [self setUpInterface];
}


- (void) setUpInterface {
    self.menuView = [[MenuView alloc] init];
    [self.view addSubview: self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}



- (void) setUpNavigation {
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithTitle: @"back" style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backItem;
}


- (void) pressBack {
    NSLog(@"点击了 back 按钮");
    UIViewController* root = self.view.window.rootViewController;
    if ([root isKindOfClass: [DrawerViewController class]]) {
        [(DrawerViewController*)root closeMenu]; 
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

