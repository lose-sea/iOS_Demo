//
//  ScrollViewCell.h
//  Share
//
//  Created by lose_sea on 2026/5/20.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewCell : UITableViewCell <UIScrollViewDelegate> 
@property (nonatomic, strong) HomepageModel* homeModel;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSTimer* timer;

- (void) configureData: (NSMutableArray*) images; 
@end

NS_ASSUME_NONNULL_END
