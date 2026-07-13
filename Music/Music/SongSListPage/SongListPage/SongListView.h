//
//  SongListView.h
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongListView : UIView
@property (nonatomic, strong) UIImageView* coverView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* messageLabel;
@property (nonatomic, strong) UIView* menuView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) PlayView* playView; 

@end

NS_ASSUME_NONNULL_END
