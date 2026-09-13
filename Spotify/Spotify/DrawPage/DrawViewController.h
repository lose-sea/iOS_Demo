//
//  DrawViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>


NS_ASSUME_NONNULL_BEGIN

@interface DrawViewController : UIViewController

@property (nonatomic, assign) CGFloat menuWidth;

// 主内容控制器
@property (nonatomic, strong) UIViewController* mainViewController;

// 菜单控制器
@property (nonatomic, strong) UIViewController* menuViewContorller;

// 菜单是否打开
@property (nonatomic, assign) BOOL drawerOpen;

-(instancetype) initWithMainViewController: (UIViewController*) mainViewController menuViewController: (UIViewController*) menuViewController;


- (void) openDrawer;
- (void) closeDrawer;
- (void) toggleDrawer;
@end

NS_ASSUME_NONNULL_END




