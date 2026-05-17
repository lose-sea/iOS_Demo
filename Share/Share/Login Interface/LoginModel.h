//
//  LoginModel.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : UIViewController
@property (nonatomic, strong) UIImage* logoShow;
@property (nonatomic, strong) UITextField* accountInput;
@property (nonatomic, strong) UITextField* passwordInput;
@property (nonatomic, assign) BOOL autoLogin;
@end

NS_ASSUME_NONNULL_END
