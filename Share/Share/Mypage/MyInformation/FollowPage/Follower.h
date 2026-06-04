//
//  Follower.h
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Follower : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSString* massage; 
@property (nonatomic, assign) BOOL isFollow;

- (instancetype) initWithAvatar: (UIImage*) avatar nickName: (NSString*) nickName;
- (instancetype) initWithUser: (UserModel*) user; 
@end

NS_ASSUME_NONNULL_END
