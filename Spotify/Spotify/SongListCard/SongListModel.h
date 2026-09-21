//
//  SongList.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <Foundation/Foundation.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongListModel : NSObject
@property (nonatomic, strong) NSString* playlistName;
@property (nonatomic, strong) UIImage* playlistCover;
@property (nonatomic, strong) NSArray<Song*>* songs;
@end

NS_ASSUME_NONNULL_END
