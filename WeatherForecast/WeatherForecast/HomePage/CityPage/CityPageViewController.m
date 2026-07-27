//
//  CityPageViewController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import "CityPageViewController.h"

@interface CityPageViewController ()

@property (nonatomic, strong) UIBarButtonItem* addButton;
@property (nonatomic, strong) UIBarButtonItem* backButton;
@property (nonatomic, strong) UIBarButtonItem* deleteButton;
@end

@implementation CityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
//    [self updateNavigationRightItem];
    
}

- (void) setUpData {
    self.dataSource = self;
    self.delegate = self;
    [self setUpNavigation];
    [self setUpInitialPage];
}

- (void) setUpNavigation {
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    self.addButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"plus"] style: UIBarButtonItemStylePlain target: self action: @selector(pressAdd)];
    
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle: @"删除" style: UIBarButtonItemStylePlain target: self action: @selector(pressDelete)];
    
    [self updateNavigationRightItem];
}


- (void) pressBack {
    [self dismissViewControllerAnimated: YES completion: nil];
}

//- (void) pressAdd {
//    
//}
//
//- (void) pressDelete {
//    
//}

- (void) pressAdd {
    
    WeatherController *currentVC = (WeatherController *)self.viewControllers.firstObject;
    CityModel* city = currentVC.city;
    HomeModel* homeModel = [HomeModel shareInstance];

    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }
    if ([homeModel.homeCities indexOfObject: city] == NSNotFound) {
        
        [homeModel addCityToSave: city];
                
        self.navigationItem.rightBarButtonItem = self.deleteButton;

        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"添加成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName: ReleadNotification object: self userInfo: nil];
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"该城市已经添加收藏夹, 重复添加" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
}

- (void) pressDelete {
    
    WeatherController *currentVC = (WeatherController *)self.viewControllers.firstObject;
    CityModel* city = currentVC.city;
    HomeModel* homeModel = [HomeModel shareInstance];

    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }

    
    if ([homeModel.homeCities indexOfObject: city] != NSNotFound) {
        
        [homeModel removeCityFormSave: city];
                
        self.navigationItem.rightBarButtonItem = self.addButton;
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"删除成功" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName: ReleadNotification object: self userInfo: nil];
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: nil  message: @"删除失败, 未添加该城市" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK");
        }];
        [alertController addAction: okAction];
        [self presentViewController: alertController animated: YES completion: nil];
    }
}

 





//- (void) updateNavigationRightItem {
//    HomeModel* homeModel = [HomeModel shareInstance];
//    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
//        self.navigationItem.rightBarButtonItem = self.addButton;
//    } else {
//        self.navigationItem.rightBarButtonItem = self.deleteButton;
//    }
//}

- (void)updateNavigationRightItem {
    WeatherController *currentVC = (WeatherController *)self.viewControllers.firstObject;
    if (![currentVC isKindOfClass:[WeatherController class]]) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    CityModel *city = currentVC.city;
    HomeModel *homeModel = [HomeModel shareInstance];
    if ([homeModel.homeCities containsObject:city]) {
        self.navigationItem.rightBarButtonItem = self.deleteButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
}



// 滑动完成后调用
- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        [self updateNavigationRightItem];
    }
}







#pragma mark - UIPageViewController


- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    HomeModel *homeModel = [HomeModel shareInstance];
    if (index < 0 || index >= homeModel.homeCities.count) {
        return nil;
    }
    WeatherController *vc = [[WeatherController alloc] init];
    vc.city = homeModel.homeCities[index];
    [vc configWithDict:homeModel.dicts[index]];
    return vc;
}

- (void) setUpInitialPage {
    UIViewController* initialVC = [self viewControllerAtIndex: self.initialIndex];
    if (initialVC) {
        [self setViewControllers: @[initialVC] direction: UIPageViewControllerNavigationDirectionForward  animated: NO completion: nil];
        [self updateNavigationRightItem];
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerBeforeViewController:(UIViewController *)viewController {
    CityModel *city = [(WeatherController *)viewController city];
    HomeModel *homeModel = [HomeModel shareInstance];
    NSInteger index = [homeModel.homeCities indexOfObject:city];
    if (index == NSNotFound) {
        return nil;
    }
    NSInteger count = homeModel.homeCities.count;
    if (count == 0) return nil;
    if (index <= 0) return [self viewControllerAtIndex:count - 1];
    return [self viewControllerAtIndex:index - 1];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
        viewControllerAfterViewController:(UIViewController *)viewController {
    CityModel *city = [(WeatherController *)viewController city];
    HomeModel *homeModel = [HomeModel shareInstance];
    NSInteger index = [homeModel.homeCities indexOfObject:city];
    if (index == NSNotFound) {
        return nil;
    }
    NSInteger count = homeModel.homeCities.count;
    if (count == 0) {
        return nil;
    }
    if (index == count - 1) {
        return [self viewControllerAtIndex:0];
    }
    return [self viewControllerAtIndex:index + 1];
}


@end
