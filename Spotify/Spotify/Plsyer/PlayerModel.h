//
//  PlayerModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayerModel : NSObject
@property (nonatomic, strong) Song* song;
@property (nonatomic, assign) BOOL isPlay;
@end

NS_ASSUME_NONNULL_END
