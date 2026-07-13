//
//  UserModel.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger followerCount;


@property (nonatomic, strong) Song* song;
@property (nonatomic, assign) BOOL isPlay;

+ (instancetype) shareInstance;
@end

NS_ASSUME_NONNULL_END
