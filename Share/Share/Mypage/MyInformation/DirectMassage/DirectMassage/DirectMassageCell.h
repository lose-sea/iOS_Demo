//
//  DirectMassageCell.h
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import <UIKit/UIKit.h>
#import "Follower.h"
#import <Masonry/Masonry.h> 

NS_ASSUME_NONNULL_BEGIN

@interface DirectMassageCell : UITableViewCell
@property (nonatomic, strong) Follower* user;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UILabel* nickLabel;
@property (nonatomic, strong) UILabel* massageLabel;
@property (nonatomic, strong) UILabel* timeLabel;

- (void) configWithFollower: (Follower*) follower; 
@end

NS_ASSUME_NONNULL_END
