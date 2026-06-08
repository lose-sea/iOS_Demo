//
//  SettingController.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import "SettingView.h"
#import "SettingModel.h"
#import "BasicController.h"
#import "ChangePasswordController.h"
#import "MessageSettingController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SettingModel* settingModel;
@property (nonatomic, strong) SettingView* settingView; 
@end

NS_ASSUME_NONNULL_END
