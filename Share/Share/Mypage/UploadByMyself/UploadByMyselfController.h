//
//  UploadByMyselfController.h
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import <UIKit/UIKit.h>
#import "UploadByMyselfModel.h"
#import "UploadByMyselfView.h"
#import "ArticlePageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadByMyselfController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ArticleDelegate> 
@property (nonatomic, strong) UploadByMyselfModel* upLoadModel;
@property (nonatomic, strong) UploadByMyselfView* upLoadView;

@property (nonatomic, strong) NSIndexPath* indexPath; 
@end

NS_ASSUME_NONNULL_END
