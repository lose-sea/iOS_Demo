//
//  UserModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) NSString* user_name;
@property (nonatomic, strong) UIImage* avatarImage;
@end

NS_ASSUME_NONNULL_END
