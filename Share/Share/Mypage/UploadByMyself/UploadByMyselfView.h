//
//  UploadByMyselfView.h
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadByMyselfView : UIView
@property (nonatomic, strong) UIScrollView* scrollView;  
@property (nonatomic, strong) UITableView* tableViewOfTime;
@property (nonatomic, strong) UITableView* tableViewOfRecommend;
@property (nonatomic, strong) UITableView* tableViewOfShare; 
@property (nonatomic, strong) UISegmentedControl* segmentedControl;

- (void) setUpScrollView;
- (void) setUpTableView ; 
@end

NS_ASSUME_NONNULL_END
