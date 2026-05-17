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
