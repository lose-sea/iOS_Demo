//
//  RegisterAccountController.m
//  Share
//
//  Created by lose_sea on 2026/5/18.
//

#import "RegisterAccountController.h"

@interface RegisterAccountController ()

@end

@implementation RegisterAccountController

- (void)viewDidLoad {
    [super viewDidLoad];self.title = @"注册账号";
    self.view.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:143.0 / 255.0 blue:203.0 / 255.0 alpha:1.0];
    // Do any additional setup after loading the view.
    self.registerAccont = [[RegisterAccount alloc] init];
    
    [self.view addSubview: self.registerAccont];
    [self.registerAccont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
   
    
    self.view.backgroundColor = self.registerAccont.backgroundColor;
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressConfirmRegister:) name: pressConfirmRegister object: nil];
    
    // 注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    // 不取消其他触摸事件，让 cell 的点击仍然有效
//    tap.cancelsTouchesInView = NO;
    
//    [self.registerAccont.emailInput addGestureRecognizer:tap];
//    [self.registerAccont.accountInput addGestureRecognizer:tap];
//    [self.registerAccont.passwordInput addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];  // 收起键盘
}


- (void) keyboardWillShow: (NSNotification*) notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.registerAccont.iView.frame = CGRectMake(0, -keyboardFrame.size.height / 2.0, self.view.bounds.size.width,  self.view.bounds.size.height);
    [self.view layoutIfNeeded];

}
- (void) keyboardWillHide: (NSNotification*) notification {
    self.registerAccont.iView.frame = self.view.frame;
    [self.view layoutIfNeeded];

}



- (void) pressConfirmRegister: (NSNotification*) notification {
    [self.view endEditing: YES];
    if (self.registerAccont.passwordInput.text.length == 0 || self.registerAccont.accountInput.text.length == 0) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"账号或密码不能为空" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
    if (self.registerAccont.passwordInput.text.length < 6 || self.registerAccont.passwordInput.text.length > 10 || ![self isAlnum: self.registerAccont.passwordInput.text]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil message: @"密码由6 - 10 位数字或字母组成" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: @"是否确认注册" message: nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* cacelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        [alertController addAction: cacelAction];
        UIAlertAction* confirm = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.userModel = [[UserModel alloc] init];
            self.userModel.account = self.registerAccont.accountInput.text;
            self.userModel.password = self.registerAccont.passwordInput.text;
            if ([self.delegate respondsToSelector: @selector(refreshInterface)]) {
                [self.delegate refreshInterface];
            }
            
            [self.navigationController popViewControllerAnimated: YES];
        }];
        [alertController addAction: confirm];
        
        [self presentViewController: alertController animated: YES completion: nil];
    }
    
    
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) isAlnum: (NSString*) str {
    if (str.length == 0) {
        return YES;
    } else {
        for (int i = 0; i < str.length; i++) {
            unichar c = [str characterAtIndex: i];
            if (!isalnum(c)) {
                return NO;
            }
        }
        return YES;
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
