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

NS_ASSUME_NONNULL_BEGIN

@interface MyController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) MyModel* myModel;
@property (nonatomic, strong) MyView* myView;
@end

NS_ASSUME_NONNULL_END
