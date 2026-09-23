//
//  MenuViewControler.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "MenuViewController.h"
#import "UserModel.h"
#import "UIResponder+AppActions.h"
#import <Masonry/Masonry.h>

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];

    [self setUpInterface];
    [self configureMenu];
}

#pragma mark - Private

- (void)setUpInterface {
    self.menuView = [[MenuView alloc] init];
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)configureMenu {
    // 占位用户数据，后续接登录后替换
    UserModel *user = [[UserModel alloc] init];
    user.user_name = @"lose_sea";
    user.avatarURL = @"51.jpg";
    user.email = @"lose_sea@spotify.com";

    [self.menuView configureWithUser:user];

    // 夜间模式：沿响应者链交给容器切换全局主题
    __weak typeof(self) weakSelf = self;
    self.menuView.onNightModeToggle = ^(BOOL isNightMode) {
        [UIApplication.sharedApplication sendAction:@selector(toggleNightMode)
                                                 to:nil
                                                 from:weakSelf
                                             forEvent:nil];
    };
}

- (void)pressBack {
    [[UIApplication sharedApplication] sendAction:@selector(closeMenu)
                                               to:nil
                                               from:self
                                           forEvent:nil];
}

@end
