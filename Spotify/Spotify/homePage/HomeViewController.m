//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"
#import <Masonry/Masonry.h>
#import "DrawerViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self setUpNavigation];
    
    self.view.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}

- (void)setUpNavigation {
    
    // 设置头像按钮, 打开菜单视图
    UIImage *image = [UIImage imageNamed:@"51.jpg"];

    UIButton* imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [imageButton setImage: image forState: UIControlStateNormal];
    
    [self.view addSubview: imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(44);
    }];
    [imageButton addTarget: self action: @selector(pressMenuButton) forControlEvents: UIControlEventAllEvents];
    imageButton.clipsToBounds = YES;
    imageButton.layer.cornerRadius = 22;
    
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithCustomView: imageButton];
//    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIBarButtonItemGroup* menuGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems: @[menuButton] representativeItem: nil];
    
    
    // 添加选项按钮
    UIBarButtonItem* allItem = [[UIBarButtonItem alloc] initWithTitle: @"全部" style: UIBarButtonItemStylePlain target: self action: @selector(pressAllPage)];
    
    UIBarButtonItem* musicItem = [[UIBarButtonItem alloc] initWithTitle: @"音乐" style: UIBarButtonItemStylePlain target: self action: @selector(pressMusicPage)];
    
    UIBarButtonItem* blogItem = [[UIBarButtonItem alloc] initWithTitle: @"播客" style: UIBarButtonItemStylePlain target: self action: @selector(pressBlogPage)];
    
    UIBarButtonItemGroup *itemsGroup = [[UIBarButtonItemGroup alloc]
        initWithBarButtonItems:@[allItem, musicItem, blogItem]
        representativeItem:nil];
    
    self.navigationItem.leadingItemGroups = @[menuGroup, itemsGroup];
}


- (void)pressAllPage {
    NSLog(@"点击全部");
}
- (void)pressMusicPage {
    NSLog(@"点击音乐");
}
- (void)pressBlogPage {
    NSLog(@"点击播客");
}


//- (void) setUpNavigation {
//    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"51.jpg"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
//    self.navigationItem.leftBarButtonItem = menus;
//}
    


- (void) pressMenuButton {
    NSLog(@"点击了菜单按钮");
    UIViewController* root = self.view.window.rootViewController;
    if ([root isKindOfClass: [DrawerViewController class]]) {
        [(DrawerViewController*)root openMenu];
    }
}

@end








