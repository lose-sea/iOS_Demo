//
//  MyPageController.h
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import <UIKit/UIKit.h>
#import "MyPageView.h"
#import "MyRecommendController.h"
#import "UploadByMyselfController.h"
#import "MyInformationController.h"
#import "SettingController.h"
#import "LoginController.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MyPageView* mypageView;
@property (nonatomic, strong) UserModel* userModel;
@end

NS_ASSUME_NONNULL_END
