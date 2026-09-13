//
//  DrawViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "DrawViewController.h"


@interface DrawViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView* maskView;



@end

@implementation DrawViewController


- (instancetype) initWithMainViewController:(UIViewController *)mainViewController menuViewController:(UIViewController *)menuViewController {
    self = [super init];
    if (self) {
        self.mainViewController = mainViewController;
        self.menuViewContorller = menuViewController;
        self.drawerOpen = NO;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuWidth = self.view.bounds.size.width * 0.7;    
    NSLog(@"viewDidLoad 开始时候 %f", self.menuWidth);
    
    // 添加主视图
    [self addChildViewController: self.mainViewController];
    [self.view addSubview: self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController: self];
    
    [self.mainViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    
    // 添加遮罩层
    [self setUpMaskView];
    
    
    
    
    // 添加菜单视图
    [self addChildViewController: self.menuViewContorller];
    [self.view addSubview: self.menuViewContorller.view];
    [self.menuViewContorller didMoveToParentViewController: self];
    [self.menuViewContorller.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(-self.menuWidth);
            make.top.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(self.menuWidth);
    }];
    
    // 添加手势
    [self setUpGesture];
    
    NSLog(@"viewDidLoad 中2  %f", self.menuWidth);
}

- (void) setUpGesture {
    NSLog(@"添加手势");
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(closeMenu)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer: tap];
}

- (void) closeMenu {
    
}


- (void) setUpMaskView {
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    
    self.maskView.userInteractionEnabled = YES;
    
    [self.view insertSubview: self.maskView belowSubview: self.menuViewContorller.view];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
}

//
//- (void) viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    self.menuWidth = self.view.bounds.size.width * 0.7;
//    NSLog(@"viewDidLayoutSubviews 中 %f", self.menuWidth);
//}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
