//
//  MyRecommendController.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import "MyRecommendModel.h"
#import "MyRecommendView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecommendController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MyRecommendModel* myRecommendModel;
@property (nonatomic, strong) MyRecommendView* myRecommendView;
@end

NS_ASSUME_NONNULL_END
