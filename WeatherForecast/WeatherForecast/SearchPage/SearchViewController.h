//
//  SeachController.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
#import "SearchModel.h"
#import "WeatherController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SearchView* searchView;
@property (nonatomic, strong) SearchModel* searchModel;

@end

NS_ASSUME_NONNULL_END
