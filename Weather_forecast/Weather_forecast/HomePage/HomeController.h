//
//  HomeController.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) UISearchController* searchController;


@end

NS_ASSUME_NONNULL_END
