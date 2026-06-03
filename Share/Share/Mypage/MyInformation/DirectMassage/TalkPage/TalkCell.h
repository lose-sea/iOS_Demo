//
//  TalkCell.h
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
#import "Follower.h"

NS_ASSUME_NONNULL_BEGIN

@interface TalkCell : UITableViewCell
@property (nonatomic, assign) BOOL isMyself;
@property (nonatomic, strong) UIImageView* avatarImageView;   
@property (nonatomic, strong) UILabel* messageLabel;
@property (nonatomic, strong) Follower* user;
- (void) configWithFollower: (Follower*) follower Message: (NSString*) message isMyself: (BOOL)isMyself; 

@end

NS_ASSUME_NONNULL_END
