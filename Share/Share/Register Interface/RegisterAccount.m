//
//  RegisterAccount.m
//  Share
//
//  Created by lose_sea on 2026/5/18.
//

#import "RegisterAccount.h"

@interface RegisterAccount ()

@end

@implementation RegisterAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册账号";
    self.view.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:143.0 / 255.0 blue:203.0 / 255.0 alpha:1.0];
    // Do any additional setup after loading the view.
    [self setInterface];
}

- (void) setInterface {
    UIImage* logo = [UIImage imageNamed: @"Logo.png"];
    self.logoShow = [[UIImageView alloc] initWithImage: logo];
    [self.view addSubview: self.logoShow];
    [self.logoShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(200);
    }];
    
    self.emailInput = [[UITextField alloc] init];
    [self.view addSubview: self.emailInput];
    [self.emailInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoShow.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
    self.emailInput.backgroundColor = [UIColor whiteColor];
    self.emailInput.textColor = [UIColor blackColor];
    // 边框风格
    self.emailInput.borderStyle = UITextBorderStyleRoundedRect;
    // 设置左边的视图
    UIImage* emailImage = [UIImage systemImageNamed: @"envelope"];
    UIImageView* emailImageView = [[UIImageView alloc] initWithImage: emailImage];
//    accountImageView.frame = CGRectMake(0, 0, 40, 40);
    self.emailInput.leftView = emailImageView;
    // 设置显示 (默认不显示)
    self.emailInput.leftViewMode = UITextFieldViewModeAlways;
    
    self.accountInput = [[UITextField alloc] init];
    [self.view addSubview: self.accountInput];
    [self.accountInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emailInput.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view);
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
    [self.view addSubview: self.passwordInput];
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountInput.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view);
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
    
    self.registerButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.view addSubview: self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.passwordInput.mas_bottom).offset(20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
    }];
    [self.registerButton setTitle: @"注册" forState: UIControlStateNormal];
    [self.registerButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    // 设置边框样式
    self.registerButton.layer.borderWidth = 1.0;       // 边框宽度
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor; // 边框颜色
    self.registerButton.layer.cornerRadius = 5.0;      // 圆角半径
    self.registerButton.clipsToBounds = YES;            // 开启裁剪，让圆角生效
//    self.registerButton.tintColor = [UIColor blackColor];
    [self.registerButton addTarget: self action: @selector(pressRegisterButton) forControlEvents: UIControlEventTouchUpInside];
}

- (void) pressRegisterButton {
    [[NSNotificationCenter defaultCenter] postNotificationName: pressConfirmRegister object: self];
    

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
