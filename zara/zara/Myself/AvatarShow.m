//
//  AvatarShow.m
//  zara
//
//  Created by lose_sea on 2026/5/10.
//

#import "AvatarShow.h"

@interface AvatarShow ()

@end

@implementation AvatarShow

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImageView];
    [self setNavigation];
}

// 设置导航栏
- (void) setNavigation {
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle: @"更换头像" style: UIBarButtonItemStylePlain target: self action: @selector(changeAvatar)];
    self.navigationItem.rightBarButtonItem = item;
}

// 设置导航栏事件
- (void) changeAvatar {
    Avatars* vc = [[Avatars alloc] init];
    [self.navigationController pushViewController: vc animated: YES]; 
}

- (void) setImageView {
    UIImageView* iView = [[UIImageView alloc] initWithImage: self.avatar];
    [self.view addSubview: iView];
    [iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(100, 20, 100, 20));
    }];
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
