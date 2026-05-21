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
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(pressConfirmRegister:) name: pressConfirmRegister object: nil];
}

- (void) pressConfirmRegister: (NSNotification*) notification {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
