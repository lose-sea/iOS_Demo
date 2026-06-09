//
//  ArticlePageController.h
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import <UIKit/UIKit.h>
#import "ArticlePageModel.h"
#import "ArticlePageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  ArticleDelegate <NSObject>
- (void) refreshArticle: (article*) article;

@end

@interface ArticlePageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ArticlePageModel* articlePageModel;
@property (nonatomic, strong) ArticlePageView* articlePageView;
@property (nonatomic, strong) article* article;
@property (nonatomic, weak) id<ArticleDelegate> delegate; 
@end



NS_ASSUME_NONNULL_END
