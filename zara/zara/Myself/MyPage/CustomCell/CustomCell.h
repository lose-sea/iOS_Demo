//
//  CustomCell.h
//  
//
//  Created by lose_sea on 2026/5/12.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UIImageView* avatarView;
@property (nonatomic, strong) UILabel* NickTextLabel;
@property (nonatomic, strong) UILabel* accountTextLabel;

@property (nonatomic, strong) UserModel* model;

@end

NS_ASSUME_NONNULL_END
