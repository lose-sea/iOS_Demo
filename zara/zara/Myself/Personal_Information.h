//
//  Personal_Information.h
//  zara
//
//  Created by lose_sea on 2026/5/8.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "AvatarShow.h"
#import "ChangeNickName.h"
#import "ChangeSignature.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personal_Information : UIViewController <UITableViewDelegate, UITableViewDataSource, ChangeNickName> 

// 昵称
@property (nonatomic, strong) NSString* Nickname;
// 头像
@property (nonatomic, strong) UIImage* avatar;
// 账号
@property (nonatomic, strong) NSString* account;
// 签名
@property (nonatomic, strong) NSString* signature;

@end

NS_ASSUME_NONNULL_END
