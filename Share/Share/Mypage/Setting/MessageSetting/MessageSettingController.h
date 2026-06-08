//
//  MessageSettingController.h
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import <UIKit/UIKit.h>
#import "MessageSettingModel.h"
#import "MessageSettingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageSettingController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MessageSettingModel* messageSettingModel;
@property (nonatomic, strong) MessageSettingView* messageSettingView; 
@end

NS_ASSUME_NONNULL_END
