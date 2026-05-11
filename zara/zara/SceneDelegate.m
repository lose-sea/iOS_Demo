//
//  SceneDelegate.m
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    UIWindowScene* myscene = (UIWindowScene*)scene;
    self.window = [[UIWindow alloc] initWithWindowScene: myscene];

    [self.window makeKeyAndVisible];
    
    [self setTabBarController];
    
}

- (void) setTabBarController {
    Homepage* homepage = [[Homepage alloc] init];
    Searchpage* searchpage = [[Searchpage alloc] init];
    Shoppage* shoppage = [[Shoppage alloc] init];
    Mypage* mypage = [[Mypage alloc] init];
    
    
    // 为每个页面分别创建导航控制器
    UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController:homepage];
    UINavigationController* searchNav = [[UINavigationController alloc] initWithRootViewController:searchpage];
    UINavigationController* shopNav = [[UINavigationController alloc] initWithRootViewController:shoppage];
    UINavigationController* myNav = [[UINavigationController alloc] initWithRootViewController: mypage];
    
    
//    // 在这里统一设置 TabBarItem (分栏控制器)
    
    // 首页, 按钮为一个房子形状
    homepage.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"首页" image: [UIImage systemImageNamed: @"house"] selectedImage:[UIImage systemImageNamed: @"house.fill"]];
    
    // 搜索,按钮为一个放大镜形状
    // magnifyingglass  放大镜
    searchpage.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"搜索" image:[UIImage systemImageNamed: @"magnifyingglass"] selectedImage:[UIImage systemImageNamed: @"magnifyingglass.fill"]];
    
//    searchpage.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem: UITabBarSystemItemSearch tag: 1];
    
    // 购物, 按钮为一个购物车形状
    shoppage.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"购物" image: [UIImage systemImageNamed: @"cart"] selectedImage: [UIImage systemImageNamed: @"cart.fill"]];
    
    // 我的,按钮为一个人的形状
    mypage.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"我的" image: [UIImage systemImageNamed: @"person"] selectedImage: [UIImage systemImageNamed: @"person.fill"]];
    
        
    // 3. 创建 TabBarController 并设置控制器数组
    UITabBarController* tabbarController = [[UITabBarController alloc] init];
    tabbarController.viewControllers = @[homeNav, searchNav, shopNav, myNav];
    
    self.window.rootViewController = tabbarController;
}




- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
