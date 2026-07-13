//
//  SongPlayModel.h
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "PlayView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongPlayModel : NSObject
@property (nonatomic, strong) Song* song;

@property (nonatomic, strong) NSArray* songs;

@end

NS_ASSUME_NONNULL_END
