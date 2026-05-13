//
//  ChangeNickName.m
//  zara
//
//  Created by lose_sea on 2026/5/12.
//

#import "ChangeNickName.h"
#import "NotificationName.h"

@interface ChangeNickName ()

@end

@implementation ChangeNickName

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改昵称";
    // Do any additional setup after loading the view.
    
    [self  setInterface];
    [self setNavigationController];
}



- (void) setInterface {
    self.textField = [[UITextField alloc] init];
    UILabel* label = [[UILabel alloc] init];
    [self.view addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(300);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
    }];
    label.text = @"请输入你要修改的昵称";
    
    [self.view addSubview: self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(350);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
    }];
    self.textField.text = self.nickname;
    // 输入框风格
    // 线框风格
    self.textField.borderStyle = UITextBorderStyleLine;
    
    // 设置虚拟键盘
    self.textField.keyboardType = UIKeyboardTypeDefault;
}

- (void) setNavigationController {
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle: @"back" style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = back;
}

// 发送通知
- (void) pressBack {
    NSLog(@"昵称修改完成, 返回上一个界面");
    // 检查是否实现了代理方法
    if ([self.delegate respondsToSelector: @selector(vcChangeNickName:didSendText:)]) {
        [self.delegate vcChangeNickName: self didSendText: self.textField.text];
    }
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName: NickNameNotification object: self userInfo: @{@"NickName": self.textField.text}]; 
    [self.navigationController popViewControllerAnimated: YES];
}

// 点击空白隐藏键盘
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder]; 
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
