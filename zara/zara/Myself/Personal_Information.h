//
//  Personal_Information.h
//  zara
//
//  Created by lose_sea on 2026/5/8.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "AvatarShow.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personal_Information : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString* Nickname;

@property (nonatomic, strong) UIImage* avatar;

@property (nonatomic, strong) NSString* account; 

@end

NS_ASSUME_NONNULL_END
