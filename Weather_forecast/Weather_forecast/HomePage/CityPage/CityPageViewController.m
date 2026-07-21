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
    [self setUpData];
    [self setUpNavigation];
    [self setUpInitialPage];
    
}

- (void) setUpData {
    
}

- (void) setUpNavigation {
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"chevron.left"] style: UIBarButtonItemStylePlain target: self action: @selector(pressBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) pressBack {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIViewController*) viewControllerAtIndex: (NSInteger) index {
    
    NSDictionary* cityInformation = self.cityList[index];
    WeatherController* vc = [[WeatherController alloc] init];
    vc.cityName = cityInformation[@"name"];
    vc.latitude = [cityInformation[@"latitude"] doubleValue];
    vc.longitude = [cityInformation[@"longitude"] doubleValue];
    vc.index = index;
    HomeModel* homeModel = [[HomeModel alloc] init];
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


- (void) setUpInterface {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
