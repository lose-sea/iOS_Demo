//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import <Masonry/Masonry.h>
#import "DrawViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self setUpNavigation];
}


//- (void) setUpNavigation {
//
//    
//    UIButton* imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    [imageButton setImage: [UIImage imageNamed: @"51.jpg"] forState: UIControlStateNormal];
//    imageButton.frame = CGRectMake(60, 400, 44, 44);
//
//    
//    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(44);
//        make.height.mas_equalTo(44);
//    }];
//    
//    imageButton.clipsToBounds = YES;
//    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageButton.imageView.clipsToBounds = YES;
//    imageButton.layer.cornerRadius = 22;
//    
////    [self.view addSubview: imageButton];
//    
//    // 消除UIButton自带的内边距
//    imageButton.contentEdgeInsets = UIEdgeInsetsZero;
//    imageButton.imageEdgeInsets = UIEdgeInsetsZero;
//    
//    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
//    config.contentInsets = NSDirectionalEdgeInsetsZero;
//    imageButton.configuration = config;
//    
//    
//    [imageButton addTarget: self action: @selector(switchButton) forControlEvents: UIControlEventTouchUpInside];
//    
//    UIBarButtonItem* avatarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: imageButton];
//    
//    self.navigationItem.leftBarButtonItem = avatarButtonItem;
//}

- (void) setUpNavigation {
    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"text.justify"] style: UIBarButtonItemStylePlain target: self action: @selector(switchButton)];
    self.navigationItem.leftBarButtonItem = menus;
}
    


- (void) switchButton {
    NSLog(@"点击了菜单按钮");
    UIViewController* root = self.view.window.rootViewController;
    if ([root isKindOfClass: [DrawViewController class]]) {
        [(DrawViewController*)root openMenu];
    }
}


@end
