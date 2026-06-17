//
//  MyModel.h
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyModel : NSObject
@property (nonatomic, strong) UserModel* user;

@property (nonatomic, strong) NSMutableArray* songs; 
@end

NS_ASSUME_NONNULL_END
