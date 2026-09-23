//
//  MenuView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface MenuView : UIView

/// 夜间模式开关被点击后回调，isNightMode 为切换后的状态
@property (nonatomic, copy, nullable) void (^onNightModeToggle)(BOOL isNightMode);

- (void)configureWithUser:(UserModel *)user;

@end

NS_ASSUME_NONNULL_END
