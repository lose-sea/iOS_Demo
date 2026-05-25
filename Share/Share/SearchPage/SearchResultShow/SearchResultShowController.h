//
//  SearchResultShowController.h
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import <UIKit/UIKit.h>
#import "article.h"
#import <Masonry/Masonry.h>
#import "SearchResultShowView.h"
#import "SearchPageModel.h"
#import "CustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultShowController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SearchPageModel* searchPageModel;
@property (nonatomic, strong) SearchResultShowView* searchResultShowView;
@end

NS_ASSUME_NONNULL_END
