//
//  MenuView.h
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UserModel.h"
#import "MenuCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuView : UIView
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UILabel* nickNameLabel;

@property (nonatomic, strong) UIImageView* VIPView;

@property (nonatomic, strong) UIButton* setButton;
@property (nonatomic, strong) UIButton* moreButton;

- (void) configWithUser: (UserModel*) user;
@end

NS_ASSUME_NONNULL_END
