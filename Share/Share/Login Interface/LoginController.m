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
    
//    self.usermodel = [[UserModel alloc] init];
    self.signin.userModel = [[UserModel alloc] init]; 
    
    
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

#pragma mark - 注册
- (void) pressRegisterButton: (NSNotification*) notification {
    RegisterAccountController* vc = [[RegisterAccountController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController: vc animated: YES];
}
#pragma mark - 登录
- (void) pressLoginButton: (NSNotification*) notification {
    NSLog(@"接收到点击登陆按钮");
    NSLog(@"账号: %@ 密码: %@", self.signin.userModel.account, self.signin.userModel.password);
    if (self.signin.userModel.account != nil && self.signin.userModel.password != nil && [self.signin.accountInput.text isEqual: self.signin.userModel.account] && [self.signin.passwordInput.text isEqualToString: self.signin.userModel.password]) {
        NSLog(@"hello");
        
        [self switchToHomepage];

    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"账号或密码错误, 请重新输入" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        // 使警告对话框显示
        [self presentViewController: alertController animated: YES completion: nil];
    }
}

#pragma mark - 登陆成功, 跳转至主界面
- (void) switchToHomepage {
    
    SceneDelegate* sceneDelegate = (SceneDelegate*)UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
//    HomepageController* homepageController = [[HomepageController alloc] init];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: homepageController];
//    sceneDelegate.window.rootViewController = nav;
    
    HomepageController* homepageController = [[HomepageController alloc] init];
    UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController: homepageController];
    homepageController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"首页" image: [UIImage systemImageNamed: @"house"] selectedImage: [UIImage systemImageNamed: @"house.fill"]];
    
    UITabBarController* tabbarController = [[UITabBarController alloc] init];
    tabbarController.viewControllers = @[homeNav];
    sceneDelegate.window.rootViewController = tabbarController; 
    
}

// 协议方法
// 实现反向传值
- (void) refreshInterface {
    [self.signin refreshInterface];
    NSLog(@"账号: %@ 密码: %@", self.signin.userModel.account, self.signin.userModel.password);
}

// 移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"被释放"); 
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES]; 
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
