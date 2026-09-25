//
//  Song.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@class Singer;
NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject <YYModel>

/// 歌曲 id
@property (nonatomic, copy) NSString *songId;

/// 封面地址：网络 URL 或本地资源名（由 View 层用 sp_setImageWithSource: 决定怎么加载）
@property (nonatomic, copy) NSString *coverURL;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, strong) Singer *singer;
@property (nonatomic, assign) BOOL isFavourite;

/// 音频地址：http(s) 开头的网络直链，或本地音频文件名（mainBundle / 沙盒 Documents）
/// 为空时该歌曲不会真正出声，播放器会直接忽略并打日志
@property (nonatomic, copy) NSString *audioURL;

/// 时长（秒）
@property (nonatomic, assign) NSTimeInterval duration;

#pragma mark - 版权信息（网易云接口下发的字段，播放前要判断）

/// 是否可以播放
@property (nonatomic, assign) BOOL canPlay;
/// 是否需要 VIP 才能播放
@property (nonatomic, assign) BOOL needVip;
/// 是否支持试听（付费歌一般只能试听片段）
@property (nonatomic, assign) BOOL supportTrail;

- (instancetype) initWithCoverURL: (NSString*) coverURL name: (NSString*) songName singer: (Singer*) singer;
- (instancetype) initWithCoverURL: (NSString*) coverURL name: (NSString*) songName singer: (Singer*) singer audioURL: (nullable NSString*) audioURL;

/// Demo 用的公开测试音源（SoundHelix 示例 mp3）。
/// 想换成自己/真实的歌：把 mp3 拖进工程后直接写文件名，或填一个 http(s) 直链即可，不需要改这里。
+ (NSString *)demoAudioURLAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
