//
//  HomeController.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "HomeView.h"
#import "UserModel.h"
#import "DrawerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) HomeModel* homeModel;
@property (nonatomic, strong) HomeView* homeView;
@property (nonatomic, strong) UISearchController* searchController; 
@end

NS_ASSUME_NONNULL_END
