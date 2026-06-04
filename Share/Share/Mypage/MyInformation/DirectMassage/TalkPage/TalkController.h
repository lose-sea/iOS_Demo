//
//  TalkController.h
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import <UIKit/UIKit.h>
#import "TalkModel.h"
#import "TalkView.h"
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TalkController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TalkModel* talkModel;
@property (nonatomic, strong) TalkView* talkView;
@property (nonatomic, assign) BOOL isMyself;
@property (nonatomic, strong) Follower* user;
@property (nonatomic, strong) Follower* other; 
@end

NS_ASSUME_NONNULL_END
