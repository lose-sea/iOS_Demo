//
//  ActivityController.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <UIKit/UIKit.h>
#import "ActivityView.h"
#import "ActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ActivityController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ActivityModel* activityModel;
@property (nonatomic, strong) ActivityView* activityView;
@end

NS_ASSUME_NONNULL_END
