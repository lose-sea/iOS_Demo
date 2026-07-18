//
//  HomeController.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "HomeModel.h"
#import "HomeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) HomeModel* homeModel;
@property (nonatomic, strong) HomeView* homeView;

@end

NS_ASSUME_NONNULL_END
