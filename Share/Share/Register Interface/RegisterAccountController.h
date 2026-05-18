//
//  RegisterAccountController.h
//  Share
//
//  Created by lose_sea on 2026/5/18.
//

#import <UIKit/UIKit.h>
#import "RegisterAccount.h"
#import "UserModel.h"
#import "NotificationName.h"
#import "UserModel.h"

////不用 @import, 防止头文件循环引用
//@class LoginController;

NS_ASSUME_NONNULL_BEGIN

@protocol RegisterAccount <NSObject>
- (void) refreshInterface;
@end

@interface RegisterAccountController : UIViewController
@property (nonatomic,strong) RegisterAccount* registerAccont;
@property (nonatomic, strong) UserModel* userModel;
@property (nonatomic, weak) id<RegisterAccount> delegate; 
@end

NS_ASSUME_NONNULL_END
