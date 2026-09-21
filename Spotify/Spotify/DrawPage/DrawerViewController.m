//
//  DrawViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "DrawerViewController.h"


@interface DrawerViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView* maskView;

@end

@implementation DrawerViewController


- (instancetype) initWithMainViewController:(UIViewController *)mainViewController menuViewController:(UIViewController *)menuViewController {
    self = [super init];
    if (self) {
        self.mainViewController = mainViewController;
        self.menuViewController = menuViewController;
        self.isMenuOpen = NO;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 添加主视图
    // 1. 建立父子关系
    [self addChildViewController:self.mainViewController];
    // 2. 把 view 加进来
    [self.view addSubview:self.mainViewController.view];
    // 3. 通知添加完成
    [self.mainViewController didMoveToParentViewController:self];
    

    
    [self.mainViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    

    // 添加遮罩层
    [self setUpMaskView];
    
    
    
    self.menuWidth = self.view.bounds.size.width * 0.7;
    NSLog(@"viewDidLoad 开始时候 %f", self.menuWidth);
    // 添加菜单视图
    [self addChildViewController: self.menuViewController];
    [self.view addSubview: self.menuViewController.view];
    [self.menuViewController didMoveToParentViewController: self];
    [self.menuViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(-self.menuWidth);
            make.top.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(self.menuWidth);
    }];
    
    // 添加手势
    [self setUpGesture];
}


- (void) setUpGesture {
    NSLog(@"添加手势");
    
    // 点击主视图上的遮罩层关闭菜单
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(closeMenu)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer: tap];
}




- (void) setUpMaskView {
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    // 透明度小于 < 0.01时,不接收触摸事件
    self.maskView.alpha = 0;
    
    self.maskView.userInteractionEnabled = NO;
    
    [self.view insertSubview: self.maskView belowSubview: self.menuViewController.view];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
}



- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}






#pragma mark - public method
// 手势事件, 收起抽屉视图
- (void) closeMenu {
    [self.menuViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.right.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.menuWidth);
        
    }];
    
    self.maskView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0;

            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isMenuOpen = NO;
        }];
    
}


// 展开菜单视图
- (void) openMenu {
    [self.menuViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.menuWidth);
    }];
    self.maskView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.5;

            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isMenuOpen = YES;
        }];
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
