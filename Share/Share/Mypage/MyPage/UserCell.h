//
//  UserCell.h
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (nonatomic, strong) UserModel* mypageModel;

@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UILabel* nickLabel;
@property (nonatomic, strong) UILabel* massageLabel;
@property (nonatomic, strong) UILabel* signatureLabel;
@property (nonatomic, strong) UIButton* saveButton;
@property (nonatomic, strong) UILabel* saveLabel;
@property (nonatomic, strong) UIButton* likeButton;
@property (nonatomic, strong) UILabel* likeLabel;
@property (nonatomic, strong) UIImageView* viewImageView;
@property (nonatomic, strong) UILabel* viewLabel;

- (void) configWithUser: (UserModel*) User; 
@end

NS_ASSUME_NONNULL_END
