//
//  PlayListModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/20.
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayListModel : NSObject
@property (nonatomic, strong) NSString* playlistName;
@property (nonatomic, strong) UIImage* playlistCover;
@property (nonatomic, strong) NSArray<Song*>* songs;
@end

NS_ASSUME_NONNULL_END
