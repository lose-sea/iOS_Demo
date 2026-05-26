//
//  SearchPageController.h
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import <UIKit/UIKit.h>
#import "SearchPageModel.h"
#import "SearchPageView.h"
#import <Masonry/Masonry.h>
#import "tagCollectionVIewCell.h"
#import "SearchResultShowController.h"
#import "SearchNotFind.h"
#import "UpLoadViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPageController : UIViewController <UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) SearchPageModel* searchModel; 
@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) SearchPageView* searchPageView;
@end

NS_ASSUME_NONNULL_END
