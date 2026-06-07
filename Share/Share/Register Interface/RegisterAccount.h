//
//  RegisterAccount.h
//  Share
//
//  Created by lose_sea on 2026/5/18.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "USerModel.h"
#import "NotificationName.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterAccount : UIView
@property (nonatomic, strong) UIImageView* iView; 
@property (nonatomic, strong) UIImageView* logoShow;
@property (nonatomic, strong) UITextField* emailInput; 
@property (nonatomic, strong) UITextField* accountInput;
@property (nonatomic, strong) UITextField* passwordInput;
@property (nonatomic, strong) UIButton* registerButton;
@property (nonatomic, strong) UserModel* userModel; 
@end

NS_ASSUME_NONNULL_END
