//
//  Signin.h
//  Share
//
//  Created by lose_sea on 2026/5/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "LoginModel.h"
#import "NotificationName.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SetringView <NSObject>
- (void) pressAutoLogin;
@end


@interface Signin : UIViewController
@property (nonatomic, strong) UIImageView* logoShow;
@property (nonatomic, strong) UITextField* accountInput;
@property (nonatomic, strong) UITextField* passwordInput;
@property (nonatomic, strong) UIButton* loginButton;
@property (nonatomic, strong) UIButton* registerButton;
@property (nonatomic, strong) UserModel* userModel; 
@property (nonatomic, strong) UIButton* autoLoginButton; 

@property (nonatomic, strong) LoginModel* model;
// 刷新账号密码
- (void) refreshInterface;
// 刷新自动登录按钮
- (void) refreshAutoButton;

@end

NS_ASSUME_NONNULL_END
