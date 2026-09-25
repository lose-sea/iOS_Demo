//
//  Singer.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@class Song;
NS_ASSUME_NONNULL_BEGIN

@interface Singer : NSObject <YYModel>

/// 歌手 id
@property (nonatomic, copy) NSString *singerId;
@property (nonatomic, copy) NSString *singerName;
/// 头像地址：网络 URL 或本地资源名
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, strong) NSArray<Song *> *songs;

- (instancetype) initWithSingerName: (NSString*) name; 
@end

NS_ASSUME_NONNULL_END
