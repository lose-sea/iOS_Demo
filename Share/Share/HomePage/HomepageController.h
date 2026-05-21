//
//  HomepageController.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"
#import "CustomCell.h"
#import "HomepageView.h"
#import "ScrollViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomepageController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) HomepageModel* homeModel;
@property (nonatomic, strong) HomepageView* homepageView;

@end

NS_ASSUME_NONNULL_END
