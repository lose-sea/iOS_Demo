//
//  DrawViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "PlayerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawerViewController : UIViewController

@property (nonatomic, assign) CGFloat menuWidth;

// 主视图控制器
@property (nonatomic, strong) UIViewController* mainViewController;

// 菜单控制器
@property (nonatomic, strong) UIViewController* menuViewController;

// 全局音乐播放器
@property (nonatomic, strong) PlayerViewController* miniPlayerVC;

// 菜单是否打开
@property (nonatomic, assign) BOOL isMenuOpen;


-(instancetype) initWithMainViewController: (UIViewController*) mainViewController menuViewController: (UIViewController*) menuViewController;


- (void) openMenu;
- (void) closeMenu;

/// 弹出全屏播放页（响应者链：PlayerViewController 转发过来）
- (void) openPlayerDetailPage;
@end

NS_ASSUME_NONNULL_END
    
