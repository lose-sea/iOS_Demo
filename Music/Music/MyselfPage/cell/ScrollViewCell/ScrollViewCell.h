//
//  ScrollViewCell.h
//  Music
//
//  Created by lose_sea on 2026/7/12.
//

#import <UIKit/UIKit.h>
#import "PlayListCell.h"
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewCell : UITableViewCell
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* scrollContentView; 
@property (nonatomic, strong) UITableView* musicTableView;
@property (nonatomic, strong) UITableView* playTableView;

@end

NS_ASSUME_NONNULL_END
