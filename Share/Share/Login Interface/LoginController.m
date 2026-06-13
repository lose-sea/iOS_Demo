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
    [self.view endEditing: YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:143.0 / 255.0 blue:203.0 / 255.0 alpha:1.0]; 
    
    
    [self setUpData];

    // Do any additional setup after loading the view.


    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressAutoLoginButton:) name: pressAutoLoginButton object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressRegisterButton:) name: pressRegisterButton object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressLoginButton:) name: pressLoginButton object: nil];
    
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    NSLog(@"注册");
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    // 不取消其他触摸事件，让 cell 的点击仍然有效
//    tap.cancelsTouchesInView = NO;
    
//    [self.signin.accountInput addGestureRecognizer:tap];
//    [self.signin.passwordInput addGestureRecognizer:tap];
    
//    [self.view addGestureRecognizer:tap];
}





- (void)setUpData {
    self.model = [[LoginModel alloc] init];
    self.signin = [[Signin alloc] init];
    [self.view addSubview: self.signin];
    [self.signin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];  // 收起键盘
}

//- (void)keyboardWillShow:(NSNotification *)notification {
//    // 获取键盘高度
//    NSDictionary *userInfo = notification.userInfo;
//    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardHeight = keyboardFrame.size.height;
//    
//    self.signin.iView.frame = CGRectMake(0, -keyboardHeight / 3.0, self.view.frame.size.width, self.view.frame.size.height);
//    
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    
//    self.signin.iView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.signin.bounds.size.height);
//}


- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.signin.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight / 3.0);
    }];
}
 
- (void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.25 animations:^{
        self.signin.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - 处理自动登录按钮点击
- (void) pressAutoLoginButton: (NSNotification*) notification {
    NSLog(@"hello wordl"); 
    self.model.autoLogin = !self.model.autoLogin;
    // 刷新view
    if (self.model.autoLogin == YES) {
        UIImage* image = [UIImage systemImageNamed: @"checkmark.rectangle"];
        [self.signin.autoLoginButton setImage: image forState: UIControlStateNormal];
    } else {
        UIImage* image = [UIImage systemImageNamed: @"square"];
        [self.signin.autoLoginButton setImage: image forState: UIControlStateNormal];
    }
}

#pragma mark - 注册
- (void) pressRegisterButton: (NSNotification*) notification {
    [self.view endEditing: YES];
    RegisterAccountController* vc = [[RegisterAccountController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController: vc animated: YES];
}
#pragma mark - 登录
- (void) pressLoginButton: (NSNotification*) notification {
    NSLog(@"接收到点击登陆按钮");
    NSLog(@"账号: %@ 密码: %@", self.signin.userModel.account, self.signin.userModel.password);
    if (self.signin.userModel.account != nil && self.signin.userModel.password != nil && [self.signin.accountInput.text isEqualToString: self.signin.userModel.account] && [self.signin.passwordInput.text isEqualToString: self.signin.userModel.password]) {
        NSLog(@"hello");
        
        [self switchToHomepage];

    } else if (self.signin.accountInput.text.length == 0 || self.signin.passwordInput.text.length == 0) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"账号或密码不能为空" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
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
    
    HomepageController* homePageController = [[HomepageController alloc] init];
        UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController: homePageController];
        homePageController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"首页" image: [UIImage systemImageNamed: @"house"] selectedImage: [UIImage systemImageNamed: @"house.fill"]];
        
        SearchPageController* searchPageController = [[SearchPageController alloc] init];
        UINavigationController* searchNav = [[UINavigationController alloc] initWithRootViewController: searchPageController];
        searchPageController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"搜索" image: [UIImage systemImageNamed: @"magnifyingglass"] selectedImage: [UIImage systemImageNamed: @"magnifyingglass"]];
        
        ArticlesCategoryController* articlesCategoryController = [[ArticlesCategoryController alloc] init];
        UINavigationController* articlesCategoryNav = [[UINavigationController alloc] initWithRootViewController: articlesCategoryController];
        articlesCategoryController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"文章分类" image: [UIImage systemImageNamed: @"square.and.pencil"] selectedImage: [UIImage systemImageNamed: @"square.and.pencil.fill"]];
        
        ActivityController* activityController = [[ActivityController alloc] init];
        UINavigationController* activityNav = [[UINavigationController alloc] initWithRootViewController: activityController];
        activityController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"活动" image: [UIImage systemImageNamed: @"trophy"] selectedImage: [UIImage systemImageNamed: @"trophy.fill"]];
        
        
        MyPageController* myPageController = [[MyPageController alloc] init];
        UINavigationController* myPageControllerNav = [[UINavigationController alloc] initWithRootViewController: myPageController];
        myPageController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"我的" image: [UIImage systemImageNamed: @"person"] selectedImage: [UIImage systemImageNamed: @"person.fill"]];
        
        
        UITabBarController* tabbarController = [[UITabBarController alloc] init];
        tabbarController.viewControllers = @[homeNav, searchNav, articlesCategoryNav, activityNav, myPageControllerNav];
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
