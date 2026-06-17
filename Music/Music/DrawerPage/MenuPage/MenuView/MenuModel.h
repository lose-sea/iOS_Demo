//
//  MenuModel.h
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MenuModel : NSObject
@property (nonatomic, strong) UserModel* user;

@property (nonatomic, strong) NSArray* tagImages;
@property (nonatomic, strong) NSArray* tagTitles;
@end

NS_ASSUME_NONNULL_END
