//
//  CityPageViewController.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import "CityPageViewController.h"

@interface CityPageViewController ()

@end

@implementation CityPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
    
    [self setUpNavigation];
    [self setUpInitialPage];
}

- (void) setUpNavigation {
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) pressBack {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIViewController*) viewControllerAtIndex: (NSInteger) index {
    
    CityModel* city = self.cityList[index];
    WeatherController* vc = [[WeatherController alloc] init];
    vc.city = city; 
    vc.index = index;
    HomeModel* homeModel = [HomeModel shareInstance];
    [vc configWithDict: homeModel.dicts[index]];
    
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
    NSInteger idx = [(WeatherController *)viewController index];
    if (idx <= 0) {
        return nil;
    }
    return [self viewControllerAtIndex: idx - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
        viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger idx = [(WeatherController *)viewController index];
    if (idx == self.cityList.count - 1) {
        return nil;
    }
    return [self viewControllerAtIndex:idx + 1];
}


@end
