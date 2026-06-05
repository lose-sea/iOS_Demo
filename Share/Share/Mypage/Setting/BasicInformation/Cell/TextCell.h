//
//  TextCell.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TextCell : UITableViewCell
@property (nonatomic, strong) UILabel* tagLabel;

@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, strong) UserModel* user;

- (void) configWithUser: (NSString*) string; 
@end

NS_ASSUME_NONNULL_END
