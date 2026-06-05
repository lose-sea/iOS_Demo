//
//  ChangePasswordView.h
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "ChangePasswordCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordView : UIView
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIButton* commitButton; 
@end

NS_ASSUME_NONNULL_END
