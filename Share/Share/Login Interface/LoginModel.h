//
//  LoginModel.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject

@property (nonatomic, assign) BOOL autoLogin;

@property (nonatomic, strong) UserModel* user;

@end

NS_ASSUME_NONNULL_END
