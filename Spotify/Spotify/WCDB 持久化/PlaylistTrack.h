//
//  PlaylistTrack.h
//  Spotify
//

#import <Foundation/Foundation.h>

@interface PlaylistTrack : NSObject

@property (nonatomic, retain) NSString *playlistId;   // 歌单ID
@property (nonatomic, retain) NSString *trackId;      // 曲目ID
@property (nonatomic, assign) NSInteger sort;         // 在歌单内的排序

@end
