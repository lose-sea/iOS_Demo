//
//  AvatarCell.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AvatarCell : UITableViewCell
@property (nonatomic, strong) UILabel* tagLabel;

@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UserModel* user; 

- (void) configWithUser: (UserModel*) user; 
@end

NS_ASSUME_NONNULL_END
