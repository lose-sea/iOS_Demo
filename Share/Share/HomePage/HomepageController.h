//
//  HomepageController.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"
#import "CustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomepageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HomepageModel* homeModel;

@end

NS_ASSUME_NONNULL_END
