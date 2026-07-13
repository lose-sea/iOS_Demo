//
//  MyController.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import "DrawerController.h"
#import "MyModel.h"
#import "MyView.h"
#import "SongListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) MyModel* myModel;
@property (nonatomic, strong) MyView* myView;

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UIScrollView* scrollView; 


@end

NS_ASSUME_NONNULL_END
