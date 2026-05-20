//
//  HomepageController.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"
#import "CustomCell.h"
#import "HomepageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomepageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HomepageModel* homeModel;
@property (nonatomic, strong) HomepageView* homepage;

@property (nonatomic, strong) UITableView* tableView; 

@end

NS_ASSUME_NONNULL_END
