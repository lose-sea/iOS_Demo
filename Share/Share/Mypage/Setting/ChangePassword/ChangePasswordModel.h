//
//  ChangePasswordModel.h
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordModel : NSObject
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) UserModel *user;

@end

NS_ASSUME_NONNULL_END
