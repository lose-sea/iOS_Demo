//
//  HomepageView.h
//  Share
//
//  Created by lose_sea on 2026/5/20.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"
#import "CustomCell.h"
#import "ScrollViewCell.h"
#import "article.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomepageView : UIView
@property (nonatomic, strong) HomepageModel* homeModel; 
@property (nonatomic, strong) UITableView* tableView;
- (void) setTableView; 
@end

NS_ASSUME_NONNULL_END
