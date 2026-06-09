//
//  ArticlesCategory.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <UIKit/UIKit.h>
#import "ArticlesCategoryView.h"
#import "ArticlesCategoryModel.h"
#import "article.h"
#import "CustomCell.h"
#import "ArticlePageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticlesCategoryController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ArticleDelegate>
@property (nonatomic, strong) ArticlesCategoryView* articleCategoryView;
@property (nonatomic, strong) ArticlesCategoryModel* articleCategoryModel;
//@property (nonatomic, strong) NSInteger selection; 
@property (nonatomic, strong) NSIndexPath* indexPath;
@end

NS_ASSUME_NONNULL_END
