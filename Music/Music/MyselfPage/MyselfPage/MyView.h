//
//  MyView.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
#import "UserCell.h"
#import "PlayListCell.h"
#import "ScrollViewCell.h"
#import "PlayView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyView : UIView
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) PlayView* playView; 
@end

NS_ASSUME_NONNULL_END
