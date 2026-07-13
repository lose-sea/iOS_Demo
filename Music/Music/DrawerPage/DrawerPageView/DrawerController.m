//
//  DrawerController.m
//  Music
//
//  Created by lose_sea on 2026/6/14.
//

#import "DrawerController.h"

@interface DrawerController () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isMenuOpen;
@property (nonatomic, assign) CGFloat menuWidth;
@end

@implementation DrawerController


- (instancetype)initWithMainViewController:(UIViewController *)main
                       menuViewController:(UIViewController *)menu {
    self = [super init];
    if (self) {
        _mainViewController = main;
        _menuViewController = menu;
        _isMenuOpen = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // 添加主视图
    [self addChildViewController: self.mainViewController];
    [self.view addSubview: self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    [self.mainViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.mainViewController.view.frame = self.view.bounds;
    
    // 添加遮罩层
    [self setupMask];
    
    
    self.menuWidth = self.view.bounds.size.width * 0.7;
    // 添加菜单视图
    [self addChildViewController: self.menuViewController];
    [self.view addSubview: self.menuViewController.view];
    [self.menuViewController didMoveToParentViewController: self];
    [self.menuViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(-self.menuWidth);
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(self.menuWidth);
        make.bottom.mas_equalTo(self.view);
    }];
//    self.menuViewController.view.frame = CGRectMake(-self.menuWidth, 0, self.menuWidth, self.view.bounds.size.height);
    [self setUpGesture];
}


- (void)setupMask {
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;

//    self.maskView.alpha = 0;//view透明度设置
    
    self.maskView.userInteractionEnabled = YES;

    [self.view insertSubview:self.maskView belowSubview:self.menuViewController.view];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
//    [self.maskView addGestureRecognizer:tap];
}

- (void)setUpGesture {
    // // 添加手势
    // // 边缘拖拽打开菜单
//    UIScreenEdgePanGestureRecognizer* edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget: self  action: @selector(handleEdgePan:)];
//    edgePan.edges = UIRectEdgeLeft;
//    [self.mainViewController.view addGestureRecognizer: edgePan];
    
    // // 全屏拖拽关闭菜单
//    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePan:)];
//    [self.view addGestureRecognizer: pan];
    
    // 点击主视图上的遮罩层关闭菜单
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(closeMenu)];
    tap.delegate = self;
    [self.maskView addGestureRecognizer: tap];
}





#pragma mark - Gesture Actions

// 边缘拖拽
- (void)handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat progress = translation.x / self.menuWidth;
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat targetX = MAX(0, MIN(self.menuWidth, progress * self.menuWidth));
        self.mainViewController.view.frame = CGRectMake(targetX, 0,
                                                        self.view.bounds.size.width,
                                                        self.view.bounds.size.height);
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat velocity = [gesture velocityInView:self.view].x;
        if (velocity > 500 || self.mainViewController.view.frame.origin.x > self.menuWidth / 2) {
            [self openMenu];
        } else {
            [self closeMenu];
        }
    }
}



- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat currentX = self.mainViewController.view.frame.origin.x;
    CGFloat targetX = MAX(0, MIN(self.menuWidth, currentX + translation.x));
    // 主视图向右移动多少，菜单视图就从左侧跟进多少
    self.mainViewController.view.frame = CGRectMake(targetX, 0,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height);
    // menuView 的 left = targetX - menuWidth，从负值向 0 靠近
    self.menuViewController.view.frame = CGRectMake(targetX - self.menuWidth, 0,
                                                    self.menuWidth,
                                                    self.view.bounds.size.height);
    [gesture setTranslation:CGPointZero inView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat velocity = [gesture velocityInView:self.view].x;
        if (velocity < -500 || targetX < self.menuWidth / 2) {
            [self closeMenu];
        } else {
            [self openMenu];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击手势只在菜单打开时生效
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return self.isMenuOpen;
    }
    return YES;
}

#pragma mark - Public Methods

- (void)closeMenu {
    [self.menuViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(-_menuWidth);
    }];
    self.maskView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0;
//        self.menuViewController.view.frame = CGRectMake(-self.menuWidth, 0, self.menuWidth, self.view.bounds.size.height);

            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isMenuOpen = NO;
        }];
}

- (void)openMenu {
    [self.menuViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
    }];
    self.maskView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.5;
//        self.menuViewController.view.frame = CGRectMake(0, 0, self.menuWidth, self.view.bounds.size.height);

            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isMenuOpen = YES;
        }];
}

- (void)switchOpen {
    self.isMenuOpen ? [self closeMenu] : [self openMenu];
}




//- (void)setUpData {
//    self.drawerModel = [[DrawerModel alloc] init];
//    self.drawerView = [[DrawerView alloc] init];
//}
//
//- (void)setUpInterface {
//    [self.view addSubview: self.drawerView];
//    [self.drawerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
//}


@end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

