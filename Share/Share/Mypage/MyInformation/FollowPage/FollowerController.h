//
//  FollowerController.h
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import <UIKit/UIKit.h>
#import "FollowerModel.h"
#import "FollowerView.h"


NS_ASSUME_NONNULL_BEGIN

@interface FollowerController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) FollowerModel* followModel;
@property (nonatomic, strong) FollowerView* followView;
@end

NS_ASSUME_NONNULL_END
