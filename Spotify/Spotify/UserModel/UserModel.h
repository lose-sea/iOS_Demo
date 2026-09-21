//
//  UserModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"
#import "Singer.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) NSString* user_name;
@property (nonatomic, strong) UIImage* avatarImage;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSArray<Song*>* favoriteSongs;
@property (nonatomic, strong) NSArray<Singer*>* favouriteSingers;

@property (nonatomic, strong) NSArray* userSongLists;
@end

NS_ASSUME_NONNULL_END
