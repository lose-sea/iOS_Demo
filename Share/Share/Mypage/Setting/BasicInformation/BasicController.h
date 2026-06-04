//
//  BasicController.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import "BasicView.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BasicView* basicView;
@property (nonatomic, strong) UserModel* user; 
@end

NS_ASSUME_NONNULL_END
