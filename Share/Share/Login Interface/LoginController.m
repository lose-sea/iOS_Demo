//
//  LoginController.m
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.model = [[LoginModel alloc] init];
    self.model.autoLogin = NO;
    
    self.signin = [[Signin alloc] init];
    self.signin.model = self.model;
    
    [self.view addSubview: self.signin.view];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressAutoLoginButton:) name: pressAutoLoginButton object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressRegisterButton:) name: pressRegisterButton object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressLoginButton:) name: pressLoginButton object: nil];
    
    NSLog(@"注册"); 
}

#pragma mark - 处理自动登录按钮点击
- (void) pressAutoLoginButton: (NSNotification*) notification {
    NSLog(@"hello wordl"); 
    Signin* signin = notification.object;
    signin.model.autoLogin = !signin.model.autoLogin;
    // 刷新view
    [self.signin refreshAutoButton];
}

- (void) pressRegisterButton: (NSNotification*) notification {
    RegisterAccountController* vc = [[RegisterAccountController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController: vc animated: YES];
}

- (void) pressLoginButton: (NSNotification*) notification {
    
}

// 协议方法
// 实现反向传值
- (void) refreshInterface {
    [self.signin refreshInterface]; 
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"被释放"); 
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
