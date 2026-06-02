//
//  FollowerCellCell.h
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import <UIKit/UIKit.h>
#import "Follower.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowerCellCell : UITableViewCell
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* nickLabel;
@property (nonatomic, strong) UIButton* followButton;
@property (nonatomic, strong) Follower* follower;

- (void) configWithFollow: (Follower*) follow; 
@end

NS_ASSUME_NONNULL_END
