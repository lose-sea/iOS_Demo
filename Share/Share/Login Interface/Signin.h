//
//  Signin.h
//  Share
//
//  Created by lose_sea on 2026/5/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SetringView <NSObject>
- (void) pressAutoLogin;
@end


@interface Signin : UIViewController
@property (nonatomic, strong) UIImageView* logoShow;
@property (nonatomic, strong) UITextField* accountInput;
@property (nonatomic, strong) UITextField* passwordInput;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, strong) UIButton* loginButton;
@property (nonatomic, strong) UIButton* registerButton;

@property (nonatomic, strong) LoginModel* model; 
@end

NS_ASSUME_NONNULL_END
