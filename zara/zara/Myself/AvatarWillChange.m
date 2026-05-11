//
//  AvatarWillChange.m
//  zara
//
//  Created by lose_sea on 2026/5/10.
//

#import "AvatarWillChange.h"
   
@interface AvatarWillChange ()
 
@end


static NSString* const AvatarNotification = @"AvatarNotification";

@implementation AvatarWillChange

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self setImageView];
}


- (void) setImageView {
    UIImageView* iView = [[UIImageView alloc] initWithImage: self.image];
    [self.view addSubview: iView];
    [iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(100, 20, 100, 20));
    }];
}


// 设置导航栏
- (void) setNavigation {
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle: @"确认更换" style: UIBarButtonItemStylePlain target: self action: @selector(changeAvatar)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void) changeAvatar {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName: AvatarNotification object: self userInfo: @{@"avatar": self.image}];
    
    // 跳转回信息页
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass: [Personal_Information class]]) {
            
            [self.navigationController popToViewController: vc animated: YES];
            break;
        }
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
