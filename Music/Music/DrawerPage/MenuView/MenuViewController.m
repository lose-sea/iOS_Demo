//
//  MenuController.m
//  Music
//
//  Created by lose_sea on 2026/6/15.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (instancetype) init {
    self = [super init];
    if (self) {
//        [self viewDidLoad];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"调用了 viewDidLoad ");
    self.view.backgroundColor = [UIColor systemRedColor];
    // Do any additional setup after loading the view.
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
