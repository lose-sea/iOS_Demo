//
//  LoginController.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "Signin.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginController : UIViewController
@property (nonatomic, strong) LoginModel* model;
@property (nonatomic, strong) Signin* signin; 
@end

NS_ASSUME_NONNULL_END
