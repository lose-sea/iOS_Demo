//
//  LoginController.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "Signin.h"
#import "NotificationName.h"
#import "UserModel.h"
#import "RegisterAccountController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginController : UIViewController <RegisterAccount>
@property (nonatomic, strong) LoginModel* model;
@property (nonatomic, strong) Signin* signin;
@property (nonatomic, strong) UserModel* usermodel;
@end

NS_ASSUME_NONNULL_END
