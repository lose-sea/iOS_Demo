//
//  SceneDelegate.m
//  Music
//
//  Created by lose_sea on 2026/4/29.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    UIWindowScene* myscene = (UIWindowScene*) scene;
    self.window = [[UIWindow alloc] initWithWindowScene: myscene];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: [[ViewController alloc] init]];
    
    HomeController* homeController = [[HomeController alloc] init];
    UINavigationController* homeNav = [[UINavigationController alloc] initWithRootViewController: homeController];
    homeController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"首页" image: [UIImage systemImageNamed: @"house"] selectedImage: [UIImage systemImageNamed: @"house.fill"]];
    
    SearchController* searchController = [[SearchController alloc] init];
    UINavigationController* searchNav = [[UINavigationController alloc] initWithRootViewController: searchController];
    searchController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"搜索" image: [UIImage systemImageNamed: @"magnifyingglass"] selectedImage: [UIImage systemImageNamed: @"magnifyingglass"]];
    
    NoteController* noteController = [[NoteController alloc] init];
    UINavigationController* noteNav = [[UINavigationController alloc] initWithRootViewController: noteController];
    noteController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"文章分类" image: [UIImage systemImageNamed: @"square.and.pencil"] selectedImage: [UIImage systemImageNamed: @"square.and.pencil.fill"]];
    
    MyController* myController = [[MyController alloc] init];
    UINavigationController* myNav = [[UINavigationController alloc] initWithRootViewController: myController];
    myController.tabBarItem =  [[UITabBarItem alloc] initWithTitle: @"我的" image: [UIImage systemImageNamed: @"person"] selectedImage: [UIImage systemImageNamed: @"person.fill"]];
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    
    
    tabBarController.viewControllers = @[homeNav, searchNav, noteNav, myNav];
//    self.window.rootViewController = nav;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
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
