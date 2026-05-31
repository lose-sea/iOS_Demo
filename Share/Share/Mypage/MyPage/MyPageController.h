//
//  MyPageController.h
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import <UIKit/UIKit.h>
#import "MyPageModel.h"
#import "MyPageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface MyPageController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MyPageView* mypageView;
@property (nonatomic, strong) MyPageModel* mypageModel;
@end

NS_ASSUME_NONNULL_END
