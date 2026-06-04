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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerAccont = [[RegisterAccount alloc] init];
    
    [self.view addSubview: self.registerAccont.view];
    [self.registerAccont.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
   
    
    self.view.backgroundColor = self.registerAccont.view.backgroundColor;
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
    self.registerAccont.view.frame = CGRectMake(0, -keyboardFrame.size.height / 3.0, self.view.bounds.size.width,  self.view.bounds.size.height);
}
- (void) keyboardWillHide: (NSNotification*) notification {
    self.registerAccont.view.frame = self.view.frame;
}



- (void) pressConfirmRegister: (NSNotification*) notification {
    [self.view endEditing: YES];
    UIAlertController* alerterController = [UIAlertController alertControllerWithTitle: @"是否确认注册" message: nil preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction* cacelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alerterController addAction: cacelAction];
    UIAlertAction* confirm = [UIAlertAction actionWithTitle: @"确认" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.userModel = [[UserModel alloc] init];
        self.userModel.account = self.registerAccont.accountInput.text;
        self.userModel.password = self.registerAccont.passwordInput.text;
        if ([self.delegate respondsToSelector: @selector(refreshInterface)]) {
            [self.delegate refreshInterface];
        }
        
        [self.navigationController popViewControllerAnimated: YES];
    }];
    [alerterController addAction: confirm];
    
    [self presentViewController: alerterController animated: YES completion: nil];
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
