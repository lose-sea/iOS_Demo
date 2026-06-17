//
//  UserCell.h
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UILabel* nickLabel;

@property (nonatomic, strong) UILabel* followLabel;
@property (nonatomic, strong) UILabel* followerLabel;
@property (nonatomic, strong) UILabel* levelLabel;
@property (nonatomic, strong) UILabel* hourLabel;

@property (nonatomic, strong) UserModel* user;

- (void)configWithUser: (UserModel*) user; 
@end

NS_ASSUME_NONNULL_END
