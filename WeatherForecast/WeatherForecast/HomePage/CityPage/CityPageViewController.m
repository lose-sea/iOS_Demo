//
//  CityPageViewController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import "CityPageViewController.h"

@interface CityPageViewController ()
@property (nonatomic, strong) CityModel* city;

@property (nonatomic, strong) UIBarButtonItem* addButton;
@property (nonatomic, strong) UIBarButtonItem* backButton;
@property (nonatomic, strong) UIBarButtonItem* deleteButton;
@end

@implementation CityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
}

- (void) setUpData {
    WeatherController* firstVC = (WeatherController*)self.viewControllers.firstObject;
    self.city = firstVC.city;
    self.currentIndex = self.initialIndex;
    self.dataSource = self;
    self.delegate = self;
    [self setUpNavigation];
    [self setUpInitialPage];
}

- (void) setUpNavigation {
//    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    
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
    HomeModel* homeModel = [HomeModel shareInstance];

    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        
        [homeModel addCityToSave: self.city];
                
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
    HomeModel* homeModel = [HomeModel shareInstance];
    
    if (!homeModel.homeCities) {
        homeModel.homeCities = [[NSMutableArray alloc] init];
    }

    
    if ([homeModel.homeCities indexOfObject: self.city] != NSNotFound) {
        
        [homeModel removeCityFormSave: self.city];
                
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

 





- (void) updateNavigationRightItem {
    HomeModel* homeModel = [HomeModel shareInstance];
    if ([homeModel.homeCities indexOfObject: self.city] == NSNotFound) {
        self.navigationItem.rightBarButtonItem = self.addButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.deleteButton;
    }
}


// 滑动完成后调用
- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        WeatherController* vc = self.viewControllers.firstObject;
        self.city = vc.city;
        [self updateNavigationRightItem];
    }
}







#pragma mark - UIPageViewController

- (UIViewController*) viewControllerAtIndex: (NSInteger) index {
    NSLog(@"更新pageViewController");
    HomeModel* homeModel = [HomeModel shareInstance];
    WeatherController* vc = [[WeatherController alloc] init];
    vc.city = homeModel.homeCities[index];
    NSDictionary* dict = homeModel.dicts[index];
    [vc configWithDict: dict];
    
    return vc;
}

- (void) setUpInitialPage {
    UIViewController* initialVC = [self viewControllerAtIndex: self.initialIndex];
    if (initialVC) {
        [self setViewControllers: @[initialVC] direction: UIPageViewControllerNavigationDirectionForward  animated: NO completion: nil];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerBeforeViewController:(UIViewController *)viewController {
    HomeModel* homeModel = [HomeModel shareInstance];
    NSInteger index = [homeModel.homeCities indexOfObject: self.city];
    if (index <= 0) {
        return [self viewControllerAtIndex: [HomeModel shareInstance].homeCities.count -  1];
    }
    return [self viewControllerAtIndex: index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
        viewControllerAfterViewController:(UIViewController *)viewController {
//    NSInteger idx = [(WeatherController *)viewController index];
//    if (idx == [HomeModel shareInstance].homeCities.count - 1) {
//        return [self viewControllerAtIndex: 0];
//    }
//    return [self viewControllerAtIndex:idx + 1];
    HomeModel* homeModel = [HomeModel shareInstance];
    NSInteger index = [homeModel.homeCities indexOfObject: self.city];
    if (index == homeModel.homeCities.count) {
        return [self viewControllerAtIndex: 0];
    }
    return [self viewControllerAtIndex: index + 1];
    
}


@end
