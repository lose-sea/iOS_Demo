//
//  Signin.m
//  Share
//
//  Created by lose_sea on 2026/5/13.
//

#import "Signin.h"

@interface Signin ()
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) UIImageView* startView;

@end

@implementation Signin



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    
////    self.view.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:143.0 / 255.0 blue:203.0 / 255.0 alpha:1.0];
//    // Do any additional setup after loading the view.    self.view.backgroundColor = [UIColor systemCyanColor];
//    // Do any additional setup after loading the view.
//    [self setInterface];
////    [self setTimer];
//}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:143.0 / 255.0 blue:203.0 / 255.0 alpha:1.0];
        self.userModel = [[UserModel alloc] init]; 
        [self setInterface];
    }
    return self; 
}



- (void) setInterface {
    
    self.iView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"登录背景.png"]];
    [self addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.iView.userInteractionEnabled = YES;
    
    UIImage* logo = [UIImage imageNamed: @"Logo.png"];
    self.logoShow = [[UIImageView alloc] initWithImage: logo];
    [self.iView addSubview: self.logoShow];
    [self.logoShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.iView.mas_top).offset(100);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    UIImage* shareText = [UIImage imageNamed: @"shareText.png"];
    UIImageView* shareTextView = [[UIImageView alloc] initWithImage: shareText];
    [self.iView addSubview: shareTextView];
    [shareTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoShow.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(900);
        make.height.mas_equalTo(90);
    }];
    
    self.accountInput = [[UITextField alloc] init];
    [self.iView addSubview: self.accountInput];
    [self.accountInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shareTextView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    self.accountInput.backgroundColor = [UIColor whiteColor];
    self.accountInput.textColor = [UIColor blackColor];
    // 边框风格
    self.accountInput.borderStyle = UITextBorderStyleRoundedRect;
    // 设置左边的视图
    UIImage* accountImage = [UIImage systemImageNamed: @"person"];
    UIImageView* accountImageView = [[UIImageView alloc] initWithImage: accountImage];
//    accountImageView.frame = CGRectMake(0, 0, 40, 40);
    self.accountInput.leftView = accountImageView;
    // 设置显示 (默认不显示)
    self.accountInput.leftViewMode = UITextFieldViewModeAlways;
    
    
    self.passwordInput = [[UITextField alloc] init];
    [self.iView addSubview: self.passwordInput];
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountInput.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.textColor = [UIColor blackColor];
    self.passwordInput.borderStyle = UITextBorderStyleRoundedRect;
    // 设置左边的视图
    UIImage* passwordImage = [UIImage systemImageNamed: @"lock"];
    UIImageView* passwordImageView = [[UIImageView alloc] initWithImage: passwordImage];
//    accountImageView.frame = CGRectMake(0, 0, 40, 40);
    self.passwordInput.leftView = passwordImageView;
    // 设置显示 (默认不显示)
    self.passwordInput.leftViewMode = UITextFieldViewModeAlways;
    // 密码显示隐藏
    self.passwordInput.secureTextEntry = YES;
    
    self.loginButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.loginButton setTitle: @"登陆" forState: UIControlStateNormal];
    [self.loginButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    
    // 设置边框样式
    self.loginButton.layer.borderWidth = 1.0;       // 边框宽度
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor; // 边框颜色
    self.loginButton.layer.cornerRadius = 5.0;      // 圆角半径
    self.loginButton.clipsToBounds = YES;            // 开启裁剪，让圆角生效
    [self.loginButton addTarget: self action: @selector(pressLoginButton) forControlEvents: UIControlEventTouchUpInside]; 
    
    [self.iView addSubview: self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.passwordInput).offset(40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.passwordInput.mas_bottom).offset(10);
    }];
    
    
    self.registerButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.registerButton setTitle: @"注册" forState: UIControlStateNormal];
    [self.registerButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    
    // 设置边框样式
    self.registerButton.layer.borderWidth = 1.0;       // 边框宽度
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor; // 边框颜色
    self.registerButton.layer.cornerRadius = 5.0;      // 圆角半径
    self.registerButton.clipsToBounds = YES;            // 开启裁剪，让圆角生效
//    self.registerButton.tintColor = [UIColor blackColor];
    [self.registerButton addTarget: self action: @selector(pressRigisterButton) forControlEvents: UIControlEventTouchUpInside];
    
    [self.iView addSubview: self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.loginButton.mas_right).offset(50);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.passwordInput.mas_bottom).offset(10);
    }];
    
    
    
    UILabel* label = [[UILabel alloc] init];
    label.text = @"自动登录";
    label.textColor = [UIColor clearColor];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize: 15];
    [self.iView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordInput).offset(23);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(10);
    }];
    
    // 设置自动登录按钮
    self.autoLoginButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    autoLoginButton.backgroundColor = [UIColor whiteColor];
    [self.iView addSubview: self.autoLoginButton];
    
    [self.autoLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(10);
            make.left.mas_equalTo(self.passwordInput);
            make.width.height.mas_equalTo(20);
    }];
    self.autoLoginButton.tintColor = [UIColor blackColor];
    [self.autoLoginButton addTarget: self action: @selector(pressAutoLogin) forControlEvents: UIControlEventTouchUpInside];
    
    [self refreshAutoButton];
}
 
#pragma mark - 点击自动登录
- (void) pressAutoLogin {
    NSLog(@"点击自动登录");
    //    不处理时间, 传递给controler处理
    [[NSNotificationCenter defaultCenter] postNotificationName: pressAutoLoginButton object: self];
}

#pragma mark - 点击注册按钮
- (void) pressRigisterButton {
    NSLog(@"点击注册");
    [[NSNotificationCenter defaultCenter] postNotificationName: pressRegisterButton object: self];
}

#pragma mark - 点击登录按钮
- (void) pressLoginButton {
    NSLog(@"点击登陆按钮"); 
    [[NSNotificationCenter defaultCenter] postNotificationName: pressLoginButton object: self];
}



- (void) refreshAutoButton {
    if (self.model.autoLogin == YES) {
        UIImage* image = [UIImage systemImageNamed: @"checkmark.rectangle"];
        [self.autoLoginButton setImage: image forState: UIControlStateNormal];
    } else {
        UIImage* image = [UIImage systemImageNamed: @"square"];
        [self.autoLoginButton setImage: image forState: UIControlStateNormal];
    }
}

// 刷新
- (void) refreshInterface {
    self.accountInput.text = self.userModel.account;
    self.passwordInput.text = self.userModel.password;
    
}

//- (void) setInterface {
//    UIImage* image = [UIImage imageNamed: @"1.jpg"];
//    self.startView = [[UIImageView alloc] initWithImage: image];
//    [self.view addSubview: self.startView];
//    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
//}
//
//- (void) setTimer {
//    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(hideStartView) userInfo: nil repeats: NO];
//}
//- (void) hideStartView {
//    self.startView.hidden = YES;
//}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end





