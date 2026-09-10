//
//  HomeViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}


- (void) setUpNavigation {
    UIBarButtonItem* avatarButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"51.jpg"] style: UIBarButtonItemStylePlain target: self action: @selector(openMenu)];
}

@end
